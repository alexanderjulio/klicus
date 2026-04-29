# KLICUS — Flujos de Negocio

---

## 1. Registro y autenticación

```
Usuario → POST /api/auth/register
         ↓
   INSERT profiles (role='cliente', plan_type='Basic')
         ↓
   NextAuth: POST /api/auth/callback/credentials
         ↓
   JWT generado con: { id, name, email, role, plan_type }
   Cookie: next-auth.session-token (httpOnly, secure)
```

**Sesión universal (`getUniversalSession`):**  
El helper verifica en este orden:
1. Cookie NextAuth (`getServerSession`) — para web
2. Header `Authorization: Bearer <jwt>` — para app móvil
3. Token NextAuth JWT (`getToken`) — fallback web
4. Header `X-Guest-ID: gst_xxx` — para usuarios invitados

---

## 2. Creación de anuncio

```
Anunciante → POST /api/pautas/nueva (multipart/form-data)
                 ↓
         Verificar sesión
                 ↓
         Procesar imágenes (Sharp → WebP 1200×800 80%)
                 ↓
         ┌─── Firebase disponible? ──────────┐
         │ Sí                                │ No
         ▼                                   ▼
   Firebase Storage               public/uploads/ads/
   ads/{nombre}-{timestamp}.webp
         │                                   │
         └──────────── URL ──────────────────┘
                         ↓
         INSERT advertisements (status='pending')
                         ↓
         Notificar a todos los admins → ADMIN_NEW_AD
```

**Límites por plan:**
- `basic`: 1 imagen
- `pro`: 3 imágenes
- `diamond`: 5 imágenes

---

## 3. Flujo de aprobación

```
Admin → Dashboard /admin → Cola de aprobaciones
             ↓
   POST /api/admin/approve-ad { adId, status }
             ↓
   status = 'active'?
   ┌─── Sí ──────────────────────────────────────────────┐
   │  Buscar billing pendiente → obtener plan             │
   │  Si no hay billing → usar priority_level actual      │
   │  Calcular expires_at según plans.js                  │
   │  UPDATE advertisements SET status='active',          │
   │    priority_level=?, expires_at=?                    │
   │  Marcar billing como 'paid' si existía               │
   └──────────────────────────────────────────────────────┘
   status = 'rejected'?
   ┌─── Sí ──────────────────────────────────────────────┐
   │  UPDATE SET status='rejected', rejection_reason=?   │
   └──────────────────────────────────────────────────────┘
             ↓
   createNotification(owner_id, template)
   AD_APPROVED | AD_PAUSED | AD_REJECTED
             ↓
   sendPushToUser(owner_id, ...) → FCM → dispositivo
```

**Duración por plan** (configurable en `src/config/plans.js`):
- `basic`: 15 días
- `pro`: 30 días
- `diamond`: 3650 días (≈10 años)

---

## 4. Flujo de pago (Mercado Pago)

```
Anunciante → POST /api/payments/checkout { adId, planType }
                  ↓
        INSERT billings (status='pending', plan_type=planType)
        Crear preferencia MP con external_reference = adId
                  ↓
        Retorna { preferenceId, initPoint }
                  ↓
        Usuario → Mercado Pago (checkout externo)
                  ↓
        MP → POST /api/billing/webhook?type=payment
                  ↓
        Verificar pago con API MP (payment.status)
                  ↓
        status = 'approved' AND external_reference?
                  ↓
        UPDATE billings SET status='paid'
        UPDATE advertisements SET status='active',
          priority_level=planType, expires_at=+días
                  ↓
        createNotification → PAYMENT_SUCCESS (anunciante)
        createNotification → ADMIN_PAYMENT_SUCCESS (todos los admins)
```

**Nota importante:** El webhook debe estar configurado en el panel de Mercado Pago apuntando a `https://tudominio.com/api/billing/webhook`.

---

## 5. Sistema de notificaciones

### Notificaciones internas (campana)

```
createNotification({ userId, title, message, type, link })
         ↓
INSERT notifications (user_id, title, message, type, link)
         ↓ (en background, sin await)
sendPushToUser(userId, payload)
         ↓
SELECT token FROM user_fcm_tokens WHERE user_id = ?
         ↓
admin.messaging().sendEachForMulticast(tokens)
         ↓
Limpiar tokens inválidos automáticamente
```

### Polling en el dashboard (cada 60 segundos)

```
NotificationCenter → GET /api/user/notifications
                          ↓
                   SELECT * FROM notifications
                   WHERE user_id = ? ORDER BY created_at DESC LIMIT 30
                          ↓
                   Mostrar en dropdown con badge de no leídas
```

### Broadcast (admin → todos)

```
Admin → POST /api/admin/broadcast { title, message }
                  ↓
        broadcastPush(payload)
                  ↓
        SELECT DISTINCT token FROM user_fcm_tokens
                  ↓
        Envío en chunks de 500 tokens (límite FCM)
```

---

## 6. Edición de anuncio

```
Anunciante → PUT /api/pautas/[id] (multipart/form-data)
                  ↓
        Verificar propiedad (owner_id = user.id) o admin
                  ↓
        existingImages (URLs string) + nuevos Files
                  ↓
        Procesar nuevos archivos → Firebase/local
        Combinar: finalImageUrls = [...existingImages, ...nuevasURLs]
        Respetar límite del plan actual
                  ↓
        UPDATE advertisements SET ..., status='pending'
                  ↓
        Notificar admins → ADMIN_AD_EDITED
```

---

## 7. Eliminación de cuenta (usuario)

```
Anunciante → DELETE /api/user/profile { reason? }
                  ↓
        Verificar sesión (bloquear si role='admin')
                  ↓
        Snapshot: email, full_name, count(ads)
                  ↓
        INSERT account_deletion_requests (auditoría)
                  ↓
        DELETE FROM profiles WHERE id = ?
                  ↓ (CASCADE automático)
        advertisements → metrics, billings
        notifications
        user_fcm_tokens
                  ↓
        Frontend: signOut() → redirect('/')
```

---

## 8. Expiración automática de anuncios

No hay un cron job dedicado. La expiración se ejecuta como efecto colateral al consultar el dashboard admin:

```
GET /api/admin/stats
         ↓
UPDATE advertisements
SET status = 'expired'
WHERE status = 'active' AND expires_at < NOW()
```

Si el admin no consulta el dashboard, los anuncios vencidos siguen con `status='active'` en BD pero pueden filtrarse por `expires_at` en consultas públicas.

**Recomendación a futuro:** Crear un cron job en cPanel que ejecute este UPDATE periódicamente.

---

## 9. Tracking de métricas

```
Visitante ve anuncio → POST /api/metrics/track
{ adId, eventType: 'view', deviceType: 'mobile' }
         ↓
INSERT metrics (ad_id, event_type, device_type)

Visitante hace clic → eventType: 'click'
Visitante contacta → eventType: 'contact'
```

Las métricas se agregan por día en `/api/admin/stats` y `/api/user/analytics/[adId]` para mostrar gráficos.

---

## 10. Roles y permisos

| Acción | cliente | anunciante | admin |
|--------|---------|------------|-------|
| Ver anuncios públicos | ✅ | ✅ | ✅ |
| Crear anuncio | ❌ | ✅ | ✅ |
| Editar propio anuncio | ❌ | ✅ | ✅ |
| Eliminar propio anuncio | ❌ | ✅ | ✅ |
| Eliminar cualquier anuncio | ❌ | ❌ | ✅ |
| Aprobar/rechazar anuncios | ❌ | ❌ | ✅ |
| Ver dashboard admin | ❌ | ❌ | ✅ |
| Gestionar usuarios | ❌ | ❌ | ✅ |
| Enviar broadcast push | ❌ | ❌ | ✅ |
| Eliminar propia cuenta | ✅ | ✅ | ❌ |
