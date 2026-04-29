# KLICUS — Base de Datos

Motor: **MySQL 8** con charset `utf8mb4` y collation `utf8mb4_unicode_ci`.  
El schema maestro está en `schema.sql`. Las tablas adicionales creadas por migraciones posteriores se documentan al final.

---

## Diagrama de relaciones

```
roles ◄──────────────── profiles ─────────────────────────────────┐
                            │                                      │
                            │ owner_id (ON DELETE CASCADE)         │
                            ▼                                      │
                     advertisements ──────────────────► categories │
                            │                                      │
              ┌─────────────┼─────────────────┐                   │
              ▼             ▼                  ▼                   │
           metrics       billings         notifications            │
                                                                   │
                         user_fcm_tokens ──────────────────────────┘
                   account_deletion_requests (auditoría, sin FK)
```

---

## Tablas

### `roles`
Niveles de permiso del sistema.

| Columna | Tipo | Descripción |
|---------|------|-------------|
| `id` | VARCHAR(50) PK | Identificador (`admin`, `anunciante`, `cliente`) |
| `name` | VARCHAR(100) | Nombre para mostrar |
| `color` | VARCHAR(50) | Color hex para UI |
| `description` | TEXT | Descripción del rol |
| `created_at` | TIMESTAMP | Fecha de creación |

**Valores por defecto:**
- `admin` — Administrador (color: `#FFD700`)
- `anunciante` — Anunciante (color: `#F59E0B`)
- `cliente` — Cliente estándar (color: `#94A3B8`)

---

### `profiles`
Usuarios del sistema. Central de todas las relaciones.

| Columna | Tipo | Descripción |
|---------|------|-------------|
| `id` | VARCHAR(255) PK | UUID generado en registro |
| `email` | VARCHAR(255) UNIQUE | Email de acceso |
| `full_name` | VARCHAR(255) | Nombre completo |
| `business_name` | VARCHAR(255) | Nombre comercial |
| `avatar_url` | VARCHAR(255) | URL de foto de perfil |
| `banner_url` | TEXT | URL de banner de perfil |
| `bio` | TEXT | Descripción del negocio |
| `role` | VARCHAR(50) FK→roles | Rol del usuario |
| `password_hash` | VARCHAR(255) | Hash bcrypt (cost 12) |
| `plan_type` | VARCHAR(50) | Plan actual (`Basic`, `Premium`) |
| `created_at` | TIMESTAMP | Fecha de registro |
| `updated_at` | TIMESTAMP | Última actualización |

**Índices:** `email` (UNIQUE)  
**Notas:** Al eliminar un perfil, se eliminan en cascada todos sus anuncios, métricas, billings y notificaciones.

---

### `categories`
Segmentos del marketplace para clasificar anuncios.

| Columna | Tipo | Descripción |
|---------|------|-------------|
| `id` | INT PK AUTO_INCREMENT | |
| `name` | VARCHAR(100) | Nombre de la categoría |
| `slug` | VARCHAR(100) UNIQUE | URL-friendly (ej: `tecnologia`) |
| `icon` | VARCHAR(50) | Nombre del ícono Lucide |
| `active` | BOOLEAN | Si aparece en listados públicos |
| `created_at` | TIMESTAMP | |

**Valores iniciales:** Tecnología, Hogar, Servicios.

---

### `advertisements`
Anuncios (pautas) publicados por los anunciantes. Tabla principal del negocio.

| Columna | Tipo | Descripción |
|---------|------|-------------|
| `id` | VARCHAR(255) PK | UUID generado al crear |
| `owner_id` | VARCHAR(255) FK→profiles CASCADE | Dueño del anuncio |
| `category_id` | INT FK→categories | Categoría del anuncio |
| `title` | VARCHAR(255) | Nombre del negocio |
| `description` | TEXT | Descripción del servicio |
| `image_urls` | JSON | Array de URLs de imágenes |
| `priority_level` | ENUM | `basic` / `pro` / `diamond` |
| `status` | ENUM | `pending` / `active` / `paused` / `expired` / `rejected` |
| `rejection_reason` | TEXT | Motivo de rechazo (visible al anunciante) |
| `location` | VARCHAR(255) | Ciudad o zona (ej: `Medellín, Antioquia`) |
| `address` | VARCHAR(255) | Dirección física |
| `business_hours` | TEXT | Horarios de atención |
| `phone` | VARCHAR(50) | Teléfono fijo |
| `cellphone` | VARCHAR(50) | WhatsApp / celular |
| `email` | VARCHAR(255) | Email de contacto del negocio |
| `website_url` | VARCHAR(255) | Sitio web |
| `facebook_url` | VARCHAR(255) | Facebook |
| `instagram_url` | VARCHAR(255) | Instagram (solo el handle) |
| `delivery_info` | TEXT | Info sobre domicilios |
| `price_range` | VARCHAR(255) | Rango de precios |
| `is_offer` | BOOLEAN | Si está en oferta especial |
| `clicks` | INT | Contador legacy de clics |
| `impressions` | INT | Contador legacy de impresiones |
| `expires_at` | TIMESTAMP NULL | Fecha de expiración según plan |
| `created_at` | TIMESTAMP | |

**Ciclo de vida del status:**
```
[Creación] → pending
[Admin aprueba] → active
[Admin pausa] → paused
[Admin rechaza] → rejected
[expires_at < NOW()] → expired  (migrado automáticamente en GET /api/admin/stats)
[Usuario edita] → pending (re-verificación)
```

**Imágenes:** Se almacenan en Firebase Storage bajo `ads/{nombre}-{timestamp}.webp` y la URL pública se guarda en `image_urls` como array JSON. En desarrollo sin Firebase, se guardan en `public/uploads/ads/`.

---

### `metrics`
Eventos de interacción con anuncios para analítica.

| Columna | Tipo | Descripción |
|---------|------|-------------|
| `id` | INT PK AUTO_INCREMENT | |
| `ad_id` | VARCHAR(255) FK→advertisements CASCADE | |
| `event_type` | ENUM | `view` / `click` / `contact` |
| `device_type` | VARCHAR(50) | `mobile` / `desktop` |
| `created_at` | TIMESTAMP | Momento del evento |

**Nota:** No se registra IP ni datos personales del visitante.

---

### `billings`
Registro de pagos de Mercado Pago asociados a anuncios.

| Columna | Tipo | Descripción |
|---------|------|-------------|
| `id` | INT PK AUTO_INCREMENT | |
| `ad_id` | VARCHAR(255) FK→advertisements CASCADE | |
| `amount` | DECIMAL(10,2) | Monto cobrado |
| `currency` | VARCHAR(3) | `COP` |
| `status` | ENUM | `pending` / `paid` / `failed` / `refunded` |
| `mp_preference_id` | VARCHAR(255) | ID de preferencia Mercado Pago |
| `external_ref` | VARCHAR(255) | Referencia externa (= adId) |
| `plan_type` | VARCHAR(50) | Plan comprado (`pro` / `diamond`) |
| `created_at` | TIMESTAMP | |

---

### `notifications`
Notificaciones internas del sistema (campana en dashboard).

| Columna | Tipo | Descripción |
|---------|------|-------------|
| `id` | INT PK AUTO_INCREMENT | |
| `user_id` | VARCHAR(255) | ID del destinatario |
| `title` | VARCHAR(255) | Título de la notificación |
| `message` | TEXT | Mensaje completo |
| `type` | VARCHAR(50) | `info` / `success` / `warning` / `error` |
| `link` | VARCHAR(255) | URL de destino al hacer clic |
| `is_read` | BOOLEAN | Estado de lectura |
| `created_at` | TIMESTAMP | |

**Índice:** `(user_id, is_read)` para consultas rápidas de no leídas.

**Templates disponibles** (en `src/lib/notifications.js`):

| Template | Destinatario | Trigger |
|----------|-------------|---------|
| `AD_APPROVED` | Anunciante | Admin aprueba anuncio |
| `AD_PAUSED` | Anunciante | Admin pausa anuncio |
| `AD_REJECTED` | Anunciante | Admin rechaza anuncio |
| `PAYMENT_SUCCESS` | Anunciante | Webhook MP pago aprobado |
| `ADMIN_NEW_AD` | Todos los admins | Usuario crea nuevo anuncio |
| `ADMIN_AD_EDITED` | Todos los admins | Usuario edita anuncio |
| `ADMIN_PAYMENT_SUCCESS` | Todos los admins | Webhook MP pago aprobado |

---

### `user_fcm_tokens`
Tokens de Firebase Cloud Messaging para notificaciones push a dispositivos.

| Columna | Tipo | Descripción |
|---------|------|-------------|
| `id` | INT PK AUTO_INCREMENT | |
| `user_id` | VARCHAR(255) | FK→profiles (sin CASCADE) |
| `token` | TEXT | Token FCM del dispositivo |
| `device_type` | VARCHAR(50) | `android` / `ios` / `web` |
| `last_used` | TIMESTAMP | Última vez que se usó |

**Índice:** `token(255)` UNIQUE para evitar duplicados.  
**Limpieza automática:** Cuando FCM reporta un token inválido, se elimina automáticamente en `sendPushToUser`.

---

### `settings`
Configuración global del sistema en clave-valor.

| Columna | Tipo | Descripción |
|---------|------|-------------|
| `setting_key` | VARCHAR(100) PK | Nombre de la configuración |
| `setting_value` | LONGTEXT | Valor (puede ser JSON) |
| `updated_at` | TIMESTAMP | |

**Claves usadas:**
- `manual_payments` — JSON con info de pagos manuales (transferencia, Nequi, etc.)
- `qr_image_url` — URL de código QR para pagos manuales

---

### `account_deletion_requests` *(creada automáticamente)*
Auditoría de eliminaciones de cuentas. Se crea con `CREATE TABLE IF NOT EXISTS` en el primer `DELETE /api/user/profile`.

| Columna | Tipo | Descripción |
|---------|------|-------------|
| `id` | INT PK AUTO_INCREMENT | |
| `user_id` | VARCHAR(255) | UUID del usuario eliminado |
| `email` | VARCHAR(255) | Email (snapshot antes de borrar) |
| `full_name` | VARCHAR(255) | Nombre completo |
| `reason` | TEXT | Motivo indicado por el usuario |
| `ads_deleted` | INT | Cantidad de anuncios que tenía |
| `requested_at` | TIMESTAMP | Fecha y hora de la solicitud |

**Sin FK** intencionalmente, para que el registro persista aunque el perfil ya no exista.

---

## Tablas adicionales (migración fase 3)

Las siguientes tablas se crean mediante `migrate_fase3.js`:

- **`chat_conversations`** — Conversaciones entre usuarios
- **`chat_messages`** — Mensajes individuales dentro de conversaciones
- **`banners`** — Banners promocionales para la página principal

Ejecutar para crear estas tablas en producción:
```bash
node migrate_fase3.js
```

---

## Respaldo y mantenimiento

```sql
-- Exportar base de datos
mysqldump -u usuario -p klicus_db > backup_$(date +%Y%m%d).sql

-- Expirar anuncios vencidos manualmente
UPDATE advertisements SET status = 'expired' WHERE status = 'active' AND expires_at < NOW();

-- Ver solicitudes de eliminación de cuenta
SELECT * FROM account_deletion_requests ORDER BY requested_at DESC;

-- Limpiar tokens FCM huérfanos (usuarios eliminados)
DELETE FROM user_fcm_tokens WHERE user_id NOT IN (SELECT id FROM profiles);
```
