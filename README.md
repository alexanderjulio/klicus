# KLICUS — Directorio Comercial Colombia

Plataforma de marketplace y directorio de negocios para Colombia. Permite a comerciantes publicar anuncios (pautas), recibir pagos vía Mercado Pago y ser descubiertos por clientes. Incluye panel de administración, notificaciones push y app móvil.

---

## Stack Tecnológico

| Capa | Tecnología |
|------|------------|
| Framework | Next.js 16 (App Router) |
| Base de datos | MySQL 8 (vía cPanel / mysql2) |
| Autenticación | NextAuth.js v4 — estrategia JWT |
| Almacenamiento imágenes | Firebase Storage (prod) / disco local (dev) |
| Notificaciones push | Firebase Cloud Messaging (FCM) |
| Pagos | Mercado Pago SDK v2 |
| Procesamiento imágenes | Sharp (conversión a WebP, máx 1200×800) |
| UI | Tailwind CSS v4 + Framer Motion + Lucide React |
| Gráficas | Recharts |
| App móvil | Capacitor (iOS + Android) |

---

## Requisitos previos

- Node.js ≥ 18
- MySQL 8
- Cuenta Firebase (Storage + FCM habilitados)
- Cuenta Mercado Pago Colombia

---

## Variables de entorno

Copia `.env.production.sample` como `.env` en producción, o `.env.local` en desarrollo.

```env
# Servidor
PORT=4000
NODE_ENV=production

# Base de datos
MYSQL_HOST=localhost
MYSQL_USER=usuario_db
MYSQL_PASSWORD=password_seguro
MYSQL_DATABASE=klicus_db

# NextAuth
NEXTAUTH_URL=https://tudominio.com
NEXTAUTH_SECRET=clave_aleatoria_muy_larga   # openssl rand -base64 32

# Firebase Admin SDK
# Producción — JSON en base64 (sin saltos de línea en .env):
FIREBASE_SERVICE_ACCOUNT_BASE64=<json_en_base64>
# Alternativa — JSON crudo (solo si el .env escapa correctamente los \n):
# FIREBASE_SERVICE_ACCOUNT={"type":"service_account",...}
# Desarrollo — archivo local gitignored:
# config/firebase-admin.json

# Firebase Storage (bucket para imágenes de anuncios)
FIREBASE_STORAGE_BUCKET=klicus-4b8a7.appspot.com

# Mercado Pago
MP_ACCESS_TOKEN=APP_USR-...

# CORS (orígenes permitidos, separados por coma, sin espacios)
ALLOWED_ORIGINS=https://tudominio.com

# Sharp (producción cPanel)
NEXT_SHARP_PATH=/home/usuario/klicus/node_modules/sharp
```

---

## Instalación (desarrollo local)

```bash
# 1. Instalar dependencias
npm install

# 2. Crear base de datos
mysql -u root -e "CREATE DATABASE klicus_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
mysql -u root klicus_db < schema.sql

# 3. Variables de entorno
cp .env.production.sample .env.local
# Editar .env.local con tus credenciales locales

# 4. Servidor de desarrollo
npm run dev          # http://localhost:4000
```

---

## Scripts disponibles

```bash
npm run dev      # Servidor de desarrollo (puerto 4000)
npm run build    # Build optimizado de producción
npm run start    # Iniciar servidor de producción
npm run lint     # Linter ESLint
```

---

## Estructura del proyecto

```
src/
├── app/
│   ├── (dashboard)/              # Rutas protegidas (layout compartido)
│   │   ├── admin/                # Panel administrador
│   │   └── dashboard/            # Panel anunciante
│   ├── api/                      # API Routes (Next.js App Router)
│   │   ├── admin/
│   │   │   ├── approve-ad/       # Aprobar / rechazar anuncios
│   │   │   ├── analytics/        # Métricas por anuncio
│   │   │   ├── banners/          # Gestión de banners
│   │   │   ├── broadcast/        # Notificaciones masivas
│   │   │   ├── plans/            # Configuración de planes
│   │   │   ├── settings/         # Ajustes globales del sistema
│   │   │   ├── stats/            # Estadísticas del dashboard
│   │   │   ├── upload/           # Subida de assets admin
│   │   │   └── users/            # Gestión de usuarios
│   │   ├── auth/                 # Registro, login, NextAuth
│   │   ├── billing/webhook/      # Webhook Mercado Pago
│   │   ├── categories/           # Listado de categorías (público)
│   │   ├── chat/                 # Mensajería entre usuarios
│   │   ├── metrics/track/        # Registro de eventos (view/click/contact)
│   │   ├── payments/checkout/    # Crear preferencia de pago MP
│   │   ├── pautas/               # CRUD de anuncios
│   │   ├── search/               # Búsqueda pública
│   │   └── user/
│   │       ├── ads/              # Anuncios del usuario autenticado
│   │       ├── analytics/        # Analytics por anuncio (usuario)
│   │       ├── dashboard-stats/  # Stats del dashboard anunciante
│   │       ├── fcm-token/        # Registro de tokens push
│   │       ├── notifications/    # Notificaciones internas
│   │       └── profile/          # Perfil + eliminación de cuenta
│   └── (páginas públicas)/
├── components/                   # Componentes React reutilizables
│   ├── admin/                    # Componentes exclusivos del panel admin
│   ├── ui/                       # Primitivas UI (Notification, etc.)
│   └── NotificationCenter.js     # Campana de notificaciones
├── config/
│   └── plans.js                  # Definición de planes y duraciones
└── lib/                          # Servicios del servidor
    ├── auth.js                   # Configuración NextAuth + callbacks JWT
    ├── auth-helper.js            # getUniversalSession (web + móvil + guest)
    ├── db.js                     # Pool de conexiones MySQL
    ├── firebase-admin.js         # Inicialización Firebase Admin SDK
    ├── image-service.js          # Sharp + upload Firebase/local
    ├── notifications.js          # createNotification + templates
    └── push-notifications.js     # FCM: sendPushToUser / broadcastPush

schema.sql                        # Schema maestro de base de datos
.env.production.sample            # Plantilla de variables de entorno
docs/                             # Documentación técnica detallada
```

---

## Documentación técnica detallada

| Documento | Descripción |
|-----------|-------------|
| [docs/API.md](docs/API.md) | Todos los endpoints REST con parámetros y respuestas |
| [docs/BASE_DE_DATOS.md](docs/BASE_DE_DATOS.md) | Esquema completo de tablas y relaciones |
| [docs/FLUJOS.md](docs/FLUJOS.md) | Flujos de negocio (pautas, pagos, notificaciones) |
| [docs/DESPLIEGUE.md](docs/DESPLIEGUE.md) | Guía de despliegue en cPanel |

---

## Planes de anuncios

| Plan | Imágenes | Duración | Precio |
|------|----------|----------|--------|
| Basic | 1 foto | 15 días | Gratis |
| Pro | 3 fotos | 30 días | $45.000 COP |
| Diamond | 5 fotos | 10 años | $99.000 COP |

---

Desarrollado para KLICUS Marketplace — Colombia 🇨🇴
