# KLICUS — Referencia de API

Todos los endpoints siguen el patrón de respuesta unificado:

```json
{ "success": true, "data": {}, "error": null, "timestamp": "...", "apiVersion": "1.0" }
```

Los endpoints marcados con 🔒 requieren sesión NextAuth activa (cookie) o header `Authorization: Bearer <token>` para clientes móviles.  
Los marcados con 🛡️ requieren además `role = "admin"`.

---

## Autenticación

### `POST /api/auth/register`
Registra un nuevo usuario.

**Body:**
```json
{ "fullName": "Juan Pérez", "email": "juan@email.com", "password": "segura123" }
```

**Respuesta exitosa:**
```json
{ "success": true, "message": "Usuario registrado correctamente" }
```

---

### `POST /api/auth/login`
Login manual (usado por clientes móviles). La web usa NextAuth directamente en `/api/auth/[...nextauth]`.

**Body:**
```json
{ "email": "juan@email.com", "password": "segura123" }
```

**Respuesta exitosa:**
```json
{ "success": true, "token": "<jwt>", "user": { "id": "...", "name": "...", "role": "anunciante" } }
```

---

### `GET /api/auth/me` 🔒
Retorna los datos del usuario autenticado.

---

## Anuncios (Pautas)

### `GET /api/pautas`
Lista pública de anuncios activos. Soporta filtros por query string.

**Query params:**
| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `category` | string | Slug de categoría (`all` por defecto) |
| `q` | string | Búsqueda por título o descripción |
| `city` | string | Filtro por ciudad/zona |
| `page` | number | Paginación |

---

### `POST /api/pautas/nueva` 🔒
Crea un nuevo anuncio. Acepta `multipart/form-data`.

**Campos del form:**
| Campo | Tipo | Requerido |
|-------|------|-----------|
| `title` | string | ✅ |
| `description` | string | ✅ |
| `categoryId` | number | ✅ |
| `priority` | `basic` / `pro` / `diamond` | ✅ |
| `location` | string | ✅ |
| `images` | File[] | Según plan (1/3/5) |
| `address` | string | |
| `businessHours` | string | |
| `phone` | string | |
| `cellphone` | string | |
| `email` | string | |
| `websiteUrl` | string | |
| `facebookUrl` | string | |
| `instagramUrl` | string | |
| `deliveryInfo` | string | |
| `priceRange` | string | |
| `isOffer` | boolean | |

**Efectos colaterales:** notifica a todos los admins con template `ADMIN_NEW_AD`.

---

### `GET /api/pautas/[id]`
Retorna los datos completos de un anuncio por ID.

---

### `PUT /api/pautas/[id]` 🔒
Edita un anuncio existente. Solo el dueño o un admin pueden editar.  
Acepta `multipart/form-data` con los mismos campos que la creación, más:

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `existingImages` | JSON string | Array de URLs ya guardadas que se conservan |
| `images` | File[] | Nuevas imágenes a subir |

El anuncio vuelve a estado `pending` al guardar.  
**Efectos colaterales:** notifica a todos los admins con template `ADMIN_AD_EDITED`.

---

### `DELETE /api/pautas/[id]` 🔒
Elimina un anuncio. Solo el dueño o un admin pueden eliminar. El CASCADE elimina métricas y billings asociados.

---

### `GET /api/anuncio/[id]`
Vista pública de un anuncio individual (usada para SEO y deep links).

---

## Perfil de usuario

### `GET /api/user/profile` 🔒
Retorna el perfil completo del usuario autenticado.

**Respuesta:**
```json
{
  "profile": {
    "id": "uuid", "email": "...", "full_name": "...", "business_name": "...",
    "phone": "...", "bio": "...", "website": "...", "role": "anunciante",
    "plan_type": "Basic", "created_at": "..."
  }
}
```

---

### `PUT /api/user/profile` 🔒
Actualiza datos del perfil.

**Body:**
```json
{ "full_name": "...", "business_name": "...", "phone": "...", "bio": "...", "website": "..." }
```

---

### `DELETE /api/user/profile` 🔒
Elimina permanentemente la cuenta del usuario autenticado.  
Bloqueado para cuentas con `role = "admin"`.

**Body (opcional):**
```json
{ "reason": "Ya no necesito el servicio" }
```

**Proceso:**
1. Registra el evento en `account_deletion_requests`
2. Ejecuta `DELETE FROM profiles WHERE id = ?`
3. El CASCADE elimina: anuncios, métricas, billings, notificaciones, tokens FCM

---

### `GET /api/user/ads` 🔒
Lista los anuncios del usuario autenticado.

---

### `GET /api/user/dashboard-stats` 🔒
Estadísticas del dashboard del anunciante (vistas, clics, contactos por anuncio).

---

### `GET /api/user/analytics/[adId]` 🔒
Serie temporal de métricas para un anuncio específico.

---

## Notificaciones

### `GET /api/user/notifications` 🔒
Lista las últimas 30 notificaciones del usuario autenticado, ordenadas por fecha descendente.

**Respuesta:**
```json
{
  "notifications": [
    { "id": 1, "title": "...", "message": "...", "type": "success", "link": "...", "is_read": false, "created_at": "..." }
  ]
}
```

---

### `PATCH /api/user/notifications` 🔒
Marca notificaciones como leídas.

**Body — marcar una:**
```json
{ "id": 42 }
```

**Body — marcar todas:**
```json
{ "all": true }
```

---

### `POST /api/user/fcm-token` 🔒
Registra o actualiza el token FCM de un dispositivo.

**Body:**
```json
{ "token": "<fcm_token>", "deviceType": "android", "guestId": "gst_xxx" }
```

---

## Búsqueda

### `GET /api/search`
Búsqueda full-text de anuncios activos.

**Query params:** `q`, `category`, `city`, `page`

---

## Categorías

### `GET /api/categories`
Lista todas las categorías activas.

**Respuesta:**
```json
{ "categories": [{ "id": 1, "name": "Tecnología", "slug": "tecnologia" }] }
```

---

## Métricas

### `POST /api/metrics/track`
Registra un evento de interacción con un anuncio.

**Body:**
```json
{ "adId": "uuid", "eventType": "view" | "click" | "contact", "deviceType": "mobile" | "desktop" }
```

---

## Banners

### `GET /api/banners`
Lista los banners activos para la página principal.

---

## Pagos

### `POST /api/payments/checkout` 🔒
Crea una preferencia de pago en Mercado Pago.

**Body:**
```json
{ "adId": "uuid", "planType": "pro" | "diamond" }
```

**Respuesta:**
```json
{ "preferenceId": "...", "initPoint": "https://www.mercadopago.com.co/checkout/v1/redirect?pref_id=..." }
```

---

### `POST /api/billing/webhook`
Webhook de Mercado Pago. Recibe notificaciones de pago y activa los anuncios automáticamente.  
**No requiere autenticación** — la validación se realiza consultando la API de MP con el `payment_id`.

**Efectos al recibir `status = "approved"`:**
1. Actualiza `billings.status = "paid"`
2. Activa el anuncio con el plan correspondiente
3. Notifica al dueño del anuncio (`PAYMENT_SUCCESS`)
4. Notifica a todos los admins (`ADMIN_PAYMENT_SUCCESS`)

---

## Chat

### `GET /api/chat/conversations` 🔒
Lista las conversaciones del usuario autenticado.

### `POST /api/chat/conversations` 🔒
Crea o recupera una conversación con otro usuario.

**Body:**
```json
{ "targetUserId": "uuid", "adId": "uuid" }
```

### `GET /api/chat/messages/[conversationId]` 🔒
Lista los mensajes de una conversación.

### `POST /api/chat/messages/[conversationId]` 🔒
Envía un mensaje. Notifica al destinatario vía FCM.

---

## Admin

> Todos los endpoints de `/api/admin/*` requieren `role = "admin"` 🛡️

### `GET /api/admin/stats`
Dashboard principal: usuarios totales, anuncios activos, pendientes, ingresos del mes, datos para gráfico semanal/mensual y cola de aprobaciones.

**Query params:** `period=7d` (default) | `period=30d`

---

### `POST /api/admin/approve-ad` 🛡️
Aprueba, rechaza o pausa un anuncio.

**Body:**
```json
{ "adId": "uuid", "status": "active" | "paused" | "rejected", "reason": "..." }
```

Al aprobar, busca billings pendientes para asignar el plan correcto y calcula la fecha de expiración desde `plans.js`.

---

### `POST /api/admin/broadcast` 🛡️
Envía una notificación push.

**Body — a todos los usuarios:**
```json
{ "title": "...", "message": "...", "image": "https://..." }
```

**Body — a un usuario específico:**
```json
{ "title": "...", "message": "...", "targetUserId": "uuid" }
```

---

### `GET /api/admin/users` 🛡️
Lista todos los usuarios de la plataforma.

### `GET /api/admin/users/search` 🛡️
Busca usuarios por nombre o email.

### `POST /api/admin/users/create` 🛡️
Crea un usuario manualmente.

### `POST /api/admin/users/action` 🛡️
Ejecuta acciones sobre un usuario.

**Body:**
```json
{ "action": "promote_admin" | "promote_anunciante" | "set_plan_gratis" | "set_plan_basico" | "set_plan_premium" | "delete", "targetUserId": "uuid" }
```

---

### `GET /api/admin/analytics` 🛡️
Métricas globales de la plataforma.

### `GET /api/admin/analytics/[adId]` 🛡️
Métricas detalladas de un anuncio específico.

### `GET /api/admin/metrics/ranking` 🛡️
Ranking de anuncios por clics, vistas o contactos.

---

### `GET /api/admin/banners` 🛡️
### `POST /api/admin/banners` 🛡️
### `DELETE /api/admin/banners` 🛡️
CRUD de banners promocionales de la página principal.

---

### `GET /api/admin/settings` 🛡️
### `PUT /api/admin/settings` 🛡️
Lectura y escritura de configuraciones globales del sistema (`settings` table).

### `POST /api/admin/settings/upload-qr` 🛡️
Sube la imagen del código QR de pagos manuales.

### `POST /api/admin/upload` 🛡️
Sube assets de marketing/banners al sistema.

---

### `GET /api/admin/plans` 🛡️
### `PUT /api/admin/plans` 🛡️
Configuración de precios de planes.

### `GET /api/admin/roles` 🛡️
Lista los roles disponibles en la plataforma.

### `GET /api/admin/notifications/broadcast` 🛡️
Historial de notificaciones masivas enviadas.
