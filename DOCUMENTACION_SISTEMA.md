# 📘 Guía de Optimización del Marketplace - KLICUS

Esta documentación detalla las intervenciones críticas realizadas para estabilizar, migrar y modernizar el Marketplace de KLICUS.

---

## 1. Estabilidad de Base de Datos (MySQL)

### Problema
El sistema presentaba errores de tipo `ER_CON_COUNT_ERROR`, lo que causaba caídas del servidor y fallos en la carga de imágenes debido a la saturación de conexiones en el entorno de desarrollo.

### Solución: Singleton V6 (Ultra-Estable)
Se implementó un patrón **Singleton** en [db.js](file:///c:/KLICUS/src/lib/db.js) que asegura que solo exista una instancia del pool de conexiones en toda la aplicación, incluso durante las recargas automáticas de Next.js (HMR).

**Configuración clave:**
- `connectionLimit: 1`: Restringe el uso a una sola conexión simultánea para evitar exceder los límites del servidor local.
- `globalThis`: Se utiliza para persistir la conexión en la memoria global de Node.js, evitando recrear el pool en cada cambio de código.
- **Auto-recuperación**: Si se detecta saturación, el sistema espera 500ms y reintenta la consulta automáticamente.

---

## 2. Migración de Datos (Firebase a MySQL)

Se migraron exitosamente **110 anuncios comerciales** desde el export JSON de Firebase.

### Script de Migración
Ubicación: [import_firebase_to_mysql.mjs](file:///c:/KLICUS/scratch/import_firebase_to_mysql.mjs)

**Mapeo de Campos Críticos:**
- **Imágenes**: Se extrajeron las URLs de `IMAGE_URL` y el objeto `GALLERY`, convirtiéndolas en un array JSON para la base de datos MySQL.
- **Redes Sociales**: Se normalizaron los campos `FB` e `IG` para alimentar los enlaces directos en el perfil.
- **Domicilios**: El campo `DOMICILIO` se mapeó para indicar disponibilidad de servicio de entrega.
- **Contacto**: Se separaron los teléfonos fijos (`TEL`) de los celulares (`CEL`) para optimizar los botones de interacción.

---

## 3. Configuración de Imágenes (Next.js)

Para permitir que el marketplace muestre imágenes alojadas externamente sin errores de seguridad, se modificó [next.config.js](file:///c:/KLICUS/next.config.js).

**Dominios Autorizados:**
- `firebasestorage.googleapis.com`: (Obligatorio para los anuncios migrados).
- `images.unsplash.com`: (Para imágenes de relleno o placeholders de alta calidad).

---

## 4. Diseño y UX (Premium White & Blue)

El Marketplace ha sido refinado para ofrecer una estética profesional inspirada en líderes de e-commerce, manteniendo la identidad visual solicitada.

### Cabecera (Branding Original)
- **Fondo Amarillo (`#E2E000`)**: Se mantuvo la identidad visual característica de KLICUS en la barra de navegación superior.
- **Iconografía**: Enlaces y botones de acción en color **Azul Navy (`#0E2244`)** para máxima legibilidad.
- **Lógica de Notificaciones**: La campana de alertas ahora solo se renderiza si el usuario ha iniciado sesión.

### Detalle del Anuncio
Se rediseñó la vista [page.js](file:///c:/KLICUS/src/app/anuncio/[id]/page.js) con un enfoque "Mobile First" y elegante:
- **Acentos Azules**: Uso de `#3483FA` para elementos de acción y resaltados.
- **Cards Informativas**: Seccionamiento claro de descripción, redes sociales y horarios.
- **Optimización de Espaciado**: Se ajustó el `padding-top` para asegurar una transición suave desde la cabecera fija.

---

## 5. Notas de Mantenimiento

- **Puerto Dev**: El servidor está configurado para correr en el puerto **4000** (`npm run dev`).
- **Nuevos Anuncios**: Al crear anuncios nuevos, asegurarse de que el array de imágenes se guarde como un JSON string en la columna `image_urls`.
- **Modo Oscuro**: Ha sido desactivado globalmente para priorizar la claridad y limpieza de la interfaz "White".

---

## 6. Flujo de Creación de Pautas (Correcciones)

### Problemas corregidos

**`processAdImage` retorna objeto, no string**
`src/lib/image-service.js` retorna `{ url, width, height, size }`. Las rutas API guardaban el objeto completo como string (`[object Object]`) en la columna `image_urls`. Corregido en:
- `src/app/api/pautas/nueva/route.js` → `imageUrls.push(result.url)`
- `src/app/api/pautas/[id]/route.js` → `finalImageUrls.push(result.url)`

**Tabla `plans` inexistente**
Las rutas consultaban una tabla `plans` que no existe en la base de datos. Reemplazado por importación de `src/config/plans.js`:
```js
import { getPlanById } from '@/config/plans';
const plan = getPlanById(requestedPriority);
const durationDays = plan.duration || 365;
```

**Todos los planes: duración 365 días**
`src/config/plans.js` — todos los planes (basic/pro/diamond) configurados a `duration: 365`.

**Respuesta de la API (`result.data?.adId`)**
La utilidad `apiResponse()` envuelve la respuesta en `{ success, data, error }`. El componente `AdCreationForm` leía `result.adId` (incorrecto), corregido a `result.data?.adId`.

### Campos añadidos al formulario de creación
- **Paso 3**: `priceRange` (rango de precios), `deliveryInfo` (información de entrega)
- **Paso 4**: `phone`, `email`, `facebookUrl`

---

## 7. Panel Administrativo

### Dashboard de Administrador (`/dashboard/admin`)
El archivo correcto servido es `src/app/dashboard/admin/page.js` (no el de `(dashboard)/admin/`).

**Bug corregido**: `setData(result)` → `setData(result.data)` — la respuesta de `apiResponse()` tiene la data anidada en `.data`.

### Visibilidad del menú admin
La navegación global (amarilla, `z-50`, fixed) se superponía sobre la barra de navegación del admin. Solución:
- Admin nav con `bg-[#0E2244]` (opaco) y `z-[60]` para quedar por encima de la navegación global.

### Botones de aprobación/rechazo de pautas
Nuevo componente `src/components/admin/AdActionButtons.js`:
- Botones cliente de Aprobar / Rechazar conectados a `/api/admin/approve-ad`
- Solicita motivo de rechazo con `window.prompt` antes de enviar
- Muestra etiqueta "Activado" o "Rechazado" tras la acción para evitar doble clic

---

## 8. Autenticación — UX (Login y Registro)

### Login (`src/app/(auth)/login/page.js`)
- Indicador de progreso animado en 3 pasos durante el inicio de sesión:
  1. "Verificando credenciales..."
  2. "Iniciando sesión..."
  3. "Redireccionando a tu cuenta..."
- Barra de progreso con `framer-motion` avanza proporcionalmente a cada paso
- Link "¿Olvidaste tu contraseña?" con ícono `KeyRound` debajo del input de contraseña → `/recuperar-contrasena`
- Inputs deshabilitados durante carga

### Registro (`src/app/(auth)/register/page.js`)
- Eliminados todos los `alert()` — reemplazados por banners inline animados
- Banner rojo (error) con `AnimatePresence` para mensajes de validación
- Banner verde (éxito) con auto-redirección a `/login` tras 2.5 segundos
- Validación client-side: contraseñas deben coincidir y tener mínimo 6 caracteres
- Indicador en tiempo real de coincidencia de contraseñas bajo los inputs
- Estados progresivos del botón: normal → "Creando tu cuenta..." → "Cuenta creada"

---

## 9. Analítica de Anuncios

### API (`src/app/api/user/analytics/[adId]/route.js`)

**Shape de respuesta corregida** — El componente `AnalyticsDashboard` espera:
```json
{
  "adTitle": "...",
  "createdAt": "...",
  "timeSeries": [...],
  "devices": [...],
  "stats": { "views": 0, "clicks": 0, "contacts": 0, "chats": 0, "ctr": "0.0", "conversionRate": "0.0" }
}
```
Anteriormente la API retornaba `ad_title`, `daily`, `totals` (snake_case y nombres distintos).

**Desglose de dispositivos** — Nueva query sobre `metrics.device_type` (valores: `desktop`, `mobile-web`, `mobile-app`).

**Filtro por rango de fechas** — Soporte para `?startDate=YYYY-MM-DD&endDate=YYYY-MM-DD` además de `?range=7|30|90|total`.

**`createdAt` incluido** — Recuperado de `advertisements.created_at` y expuesto en la respuesta.

### Componente (`src/components/dashboard/AnalyticsDashboard.js`)
- `timeSeries` y `devices` con default `= []` para evitar crash si la API retorna `undefined`
- Estado vacío "Sin datos de dispositivos aún." cuando el array de dispositivos está vacío

---

## 10. Aplicación Móvil (Flutter)

Ubicación: `mobile/`  
Plataformas: **Android · iOS · Web** desde una única base de código Flutter.

### Arquitectura

Patrón **Provider + Repository**. Cada fuente de datos tiene su propio repositorio; los providers de estado reciben los repositorios vía inyección por constructor, lo que permite tests unitarios sin HTTP real.

```
ApiService (Dio)
    └── Repositories          ← thin wrappers sobre ApiService
          ├── AdRepository
          ├── AdminRepository
          ├── ChatRepository
          └── UserRepository
    └── Providers             ← estado reactivo (ChangeNotifier)
          ├── AuthProvider    ← delega stats → StatsProvider, perfil → ProfileProvider
          ├── StatsProvider
          ├── ProfileProvider
          ├── NotificationProvider
          ├── FavoritesProvider
          └── ConnectivityProvider
```

### Fase 1 — Estabilidad

| Mejora | Detalle |
|--------|---------|
| `dispose()` en `EditAdScreen` | Cancelaba timer y 13 controllers que quedaban activos |
| Polling guard en `ChatDetailScreen` | `if (_pollingTimer!.isActive) return` evitaba timers duplicados |
| `onSessionExpired` callback | `ApiService` llama al callback en 401; `AuthProvider` hace logout limpio sin ciclos |
| `print()` → `debugPrint()` | Evita logs en release builds |

### Fase 2 — UX

| Mejora | Detalle |
|--------|---------|
| `ConnectivityProvider` + `OfflineBanner` | Banner rojo animado en Home y Chat cuando no hay red (`connectivity_plus`) |
| Validación de formularios | Login y Registro usan `GlobalKey<FormState>` + `TextFormField` con validadores |
| Auto-guardado de borrador | `EditAdScreen` guarda en `SharedPreferences` cada 3 segundos y restaura al abrir |
| Cierre de cuenta | `PrivacySecurityScreen` confirma, llama a `UserRepository.deleteAccount()` y hace logout |
| Preferencias de notificaciones | `NotificationSettingsScreen` carga y persiste preferencias vía `UserRepository` |

### Fase 3 — Performance

| Mejora | Detalle |
|--------|---------|
| Paginación en Home | 12 anuncios por página, carga incremental a 300 px del final del scroll |
| Caché de imágenes | `KlicusCacheManager` (7 días, 200 objetos) via `flutter_cache_manager` |
| Compresión antes de subir | `flutter_image_compress`: 85 % / 1280 px, fallback 60 % / 960 px |
| Geocodificación inversa | `geocoding` convierte coordenadas GPS a nombre de lugar legible |
| FavoritesProvider | `Set<String>` persistido en `SharedPreferences`; corazón superpuesto en cada card |

### Fase 4 — Arquitectura

| Mejora | Detalle |
|--------|---------|
| `AuthProvider` refactorizado | Constructor injection de `ApiService`, `StatsProvider`, `ProfileProvider`; zero breaking changes en 11 call sites |
| Capa de repositorios | `AdRepository`, `AdminRepository`, `ChatRepository`, `UserRepository` |
| Chat en tiempo real | `ChatWsService` intenta WebSocket primero; si falla, fallback automático a polling 5s |
| Exponential backoff en notificaciones | `NotificationProvider`: 10s → 20s → 40s … cap 5 min; reset en éxito; pausa en background |
| Tests unitarios | 33 tests, 0 fallos (auth, favorites, backoff) |

### Pantallas Admin

Accesibles solo con rol admin. Todas usan `AdminRepository` (no `ApiService` directo):

| Pantalla | Función |
|----------|---------|
| `AdminAnalyticsScreen` | Dashboard con gráficos de línea y barra (`fl_chart`), selector 7d / 30d |
| `AdminApprovalScreen` | Cola de anuncios pendientes; aprobar / rechazar con motivo |
| `AdminMarketingScreen` | CRUD de banners: crear, editar, activar/desactivar, eliminar, subir imagen |
| `AdminPushScreen` | Envío de notificaciones push: broadcast o usuario específico con buscador |

### Identidad visual

| Token | Valor | Uso |
|-------|-------|-----|
| Navy | `#0E2244` | Fondo de AppBar, burbujas propias en chat, botones primarios |
| Yellow | `#E2E000` | Acentos, badges activos, íconos destacados |
| Background | `#F4F7FA` | Scaffold de todas las pantallas |
| Tipografía heading | Outfit (900) | Títulos, labels, botones |
| Tipografía body | Inter | Contenido de mensajes, descripciones |

### Variables de configuración

Editar `lib/core/api_service.dart`:

```dart
static String get baseUrl {
  if (kIsWeb) return 'http://localhost:4000/api';
  return 'http://192.168.1.5:4000/api'; // IP WiFi para dispositivos reales
}
```

### Comandos de build

```bash
flutter pub get
flutter test                          # 33 tests unitarios
flutter run                           # debug en dispositivo/emulador
flutter build apk --release           # Android APK
flutter build appbundle --release     # Play Store
flutter build ios --release           # App Store (requiere Mac)
flutter build web --release           # Web
```

---

## 11. Sistema de Marketing (Banners e Intersticial)

### Estructura de datos

La tabla `banners` unifica banners de carrusel y pantalla intersticial mediante el campo `type`:

| `type` | Uso |
|--------|-----|
| `carousel` (o NULL) | Banner deslizable en el Home |
| `interstitial` | Pantalla completa al abrir la app |

Solo puede haber **un intersticial activo** a la vez. La API pública (`GET /api/banners`) filtra por `type = 'carousel' OR type IS NULL` para no mezclar tipos.

### APIs

| Endpoint | Método | Descripción |
|----------|--------|-------------|
| `GET /api/banners` | público | Banners del carrusel (excluye interstitial) |
| `GET /api/interstitial` | público | Intersticial activo (image_url, cta_link) |
| `GET /api/admin/banners` | admin | Lista todos (carousel + interstitial) |
| `POST /api/admin/banners` | admin | Crear banner/intersticial |
| `PUT /api/admin/banners` | admin | Editar (constructor dinámico, evita COALESCE con booleanos) |
| `DELETE /api/admin/banners` | admin | Eliminar por id |
| `POST /api/admin/upload` | admin | Subir imagen (type: `marketing`, `interstitial`, `ad`) |

### Procesamiento de imágenes (`src/lib/image-service.js`)

```
sharp.concurrency(1)  ← evita error "glib: Error creating thread" en CloudLinux
```

| Función | Dimensiones | `fit` | Uso |
|---------|-------------|-------|-----|
| `processMarketingImage` | 1200 × 600 | `cover` | Banners de carrusel |
| `processInterstitialImage` | 1080 × 1920 max | `inside` | Pantalla intersticial (preserva aspect ratio) |
| `processAdImage` | 1200 × 800 max | `inside` | Imágenes de anuncios |
| `processQRImage` | 600 × 600 max | `inside` | Códigos QR |

> **Tamaños recomendados para subir:**
> - Carrusel: **1200 × 450 px** (landscape, ratio 8:3)
> - Intersticial: **1080 × 1920 px** (portrait, ratio 9:16)

### AdminMarketingScreen (Flutter)

- Sección **PANTALLA INTERSTICIAL**: vista previa, toggle activo/inactivo, editar, eliminar
- Sección **BANNERS DE CARRUSEL**: lista con toggle, editar, eliminar, agregar nuevo
- Los cambios se aplican **en caliente**: al regresar al tab Home se refrescan banners y se re-verifica el intersticial via `NavigationProvider` listener + `ValueKey(_bannerRefreshKey)`
- El formulario muestra errores inline (no snackbars) mientras el modal está abierto; el snackbar de éxito se muestra desde el contexto padre tras cerrar el modal

### Flujo de la pantalla intersticial (Flutter Home)

```
initState → _fetchInitialData()
  ├── _fetchCategories()          ← sin await, fija estado local
  ├── _fetchAds()                 ← inicia en paralelo (carga mientras se muestra el intersticial)
  └── _checkInterstitial()
        ├── GET /api/interstitial
        ├── precacheImage()       ← imagen en caché antes de mostrar (sin spinner)
        ├── Navigator.push(InterstitialScreen, opaque: false)
        └── finally → setState(_interstitialChecked = true)
```

- Mientras `_interstitialChecked = false`, el home es invisible (`AnimatedOpacity(opacity: 0)`)
- Al cerrar el intersticial, el home aparece con **fade suave de 200 ms** y los anuncios ya están cargados (parallel fetch)
- `InterstitialScreen` usa `BoxFit.fitWidth`: llena el ancho de pantalla escalando el alto proporcionalmente (sin zoom excesivo)

### Bugs corregidos en esta fase

| Bug | Causa | Fix |
|-----|-------|-----|
| Toggle activo/inactivo no funcionaba | `COALESCE` con `false` de JS se interpreta como NULL | Constructor dinámico de UPDATE + `is_active ? 1 : 0` explícito |
| INSERT de banner fallaba | `subtitle`/`cta_text`/`cta_link` llegaban como `undefined` a los bind params | `?? null` en los tres campos opcionales |
| `ERR_SERVER_NOT_RUNNING` en producción | `ensureTypeColumn()` hacía ALTER TABLE en **cada request** disparando nproc limit | Función eliminada (migración ya aplicada) |
| `ad_id cannot be null` en métricas | Eventos globales (install/session) no tienen ad_id pero columna era NOT NULL | Early return en `/api/metrics/track` para eventos globales sin adId |
| Intersticial aparecía en el carrusel | `/api/banners` devolvía todos los tipos | Filtro `AND (type = 'carousel' OR type IS NULL)` |
| Zoom excesivo en el intersticial | Imagen procesada a 1200×600 landscape, mostrada con `BoxFit.cover` en pantalla portrait | `processInterstitialImage` con `fit: inside` + `BoxFit.fitWidth` en display |
| Parpadeo al abrir la app | Home reconstruía con shimmer antes de que apareciera el intersticial | `AnimatedOpacity` + precaching + carga paralela de anuncios |
| Error de hilos en CloudLinux (sharp) | libvips detecta N CPUs y crea N hilos, excediendo nproc | `sharp.concurrency(1)` al inicio de `image-service.js` |

---

## 12. Splash Screen

- Archivo: `mobile/lib/features/splash/splash_screen.dart`
- Fondo amarillo `#E2E000`, logo centrado (`assets/splash_padded.png`, 260 px de ancho)
- Duración: **3 segundos** → `Future.delayed(Duration(seconds: 3), _navigate)`
- Ruta inicial: `/splash` en `main.dart`
- Asset declarado en `pubspec.yaml` bajo `flutter: assets: - assets/`

### Deploy a producción (cPanel / Passenger)

```bash
# 1. Build Next.js standalone
npm run build

# 2. Empaquetar
rm -rf deploy_package/app
cp -r .next/standalone deploy_package/app
cp -r .next/static deploy_package/app/.next/static
cp -r public/. deploy_package/app/public/
Compress-Archive -Path deploy_package/app -DestinationPath klicus_cpanel_deploy.zip -Force

# 3. Subir klicus_cpanel_deploy.zip a cPanel → Administrador de archivos → extraer
# 4. Reiniciar Node.js app en cPanel → Setup Node.js App → Restart
```
