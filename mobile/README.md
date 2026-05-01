# KLICUS Mobile

Aplicación móvil oficial del marketplace KLICUS, construida con **Flutter**.  
Soporta **Android**, **iOS** y **Web** desde una única base de código.

---

## Requisitos

| Herramienta | Versión mínima |
|-------------|---------------|
| Flutter     | 3.22+         |
| Dart        | 3.2+          |
| Android SDK | API 21+       |
| Xcode       | 15+           |

---

## Instalación rápida

```bash
flutter pub get
flutter run                  # dispositivo conectado / emulador
flutter run -d chrome        # web
```

---

## Arquitectura

La app sigue el patrón **Provider + Repository**:

```
lib/
├── main.dart                    # Árbol de providers, bootstrap de Firebase
├── core/
│   ├── api_service.dart         # Cliente HTTP (Dio) con interceptor de auth
│   ├── nav_provider.dart        # Estado de navegación
│   ├── repositories/
│   │   ├── ad_repository.dart   # Anuncios: fetchAds, fetchSuggestions, updateAd
│   │   ├── admin_repository.dart# Admin: stats, aprobación, banners, push
│   │   ├── chat_repository.dart # Mensajes: getMessages, sendMessage, sendImage
│   │   └── user_repository.dart # Perfil: fetchUserAds, deleteAccount, notif. prefs.
│   ├── services/
│   │   ├── analytics_service.dart
│   │   ├── chat_service.dart
│   │   ├── chat_ws_service.dart # WebSocket con fallback a polling
│   │   ├── connectivity_provider.dart
│   │   ├── favorites_provider.dart
│   │   ├── image_cache_manager.dart
│   │   ├── push_service.dart    # FCM + local notifications
│   │   └── stats_provider.dart
│   └── widgets/
│       ├── main_navigation.dart
│       └── offline_banner.dart  # Banner rojo animado cuando no hay red
├── features/
│   ├── admin/
│   │   ├── admin_analytics_screen.dart   # Dashboard con gráficos fl_chart
│   │   ├── admin_approval_screen.dart    # Cola de aprobación de anuncios
│   │   ├── admin_marketing_screen.dart   # CRUD banners carrusel + pantalla intersticial
│   │   └── admin_push_screen.dart        # Envío de notificaciones push
│   ├── auth/
│   │   ├── auth_provider.dart    # Estado de sesión (inyección por constructor)
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── chat/
│   │   ├── chat_detail_screen.dart  # Mensajería con WS + optimistic updates
│   │   └── chat_list_screen.dart
│   ├── home/
│   │   ├── home_screen.dart         # Feed paginado con favoritos + lógica intersticial
│   │   ├── interstitial_screen.dart # Pantalla completa con imagen + CTA + botón cerrar
│   │   ├── ad_detail_screen.dart
│   │   ├── create_ad_screen.dart
│   │   └── widgets/
│   │       └── banner_carousel.dart # Carrusel de banners promocionales
│   ├── notifications/
│   │   └── notification_provider.dart  # Polling con exponential backoff
│   ├── onboarding/
│   │   └── onboarding_screen.dart
│   ├── splash/
│   │   └── splash_screen.dart       # Logo 3s sobre fondo amarillo #E2E000
│   └── profile/
│       ├── profile_screen.dart
│       ├── edit_ad_screen.dart         # Auto-guardado de borrador cada 3s
│       ├── edit_profile_screen.dart
│       ├── notification_settings_screen.dart
│       ├── privacy_security_screen.dart # Incluye cierre de cuenta
│       └── profile_provider.dart
└── models/
    └── ad_model.dart
```

---

## Providers registrados en `main.dart`

| Provider | Tipo | Descripción |
|----------|------|-------------|
| `ApiService` | `Provider` | Singleton del cliente HTTP |
| `AuthProvider` | `ChangeNotifier` | Sesión, login, logout |
| `StatsProvider` | `ChangeNotifier` | Estadísticas del dashboard |
| `ProfileProvider` | `ChangeNotifier` | Datos del perfil activo |
| `NotificationProvider` | `ChangeNotifier` | Polling de notificaciones |
| `NavigationProvider` | `ChangeNotifier` | Tab activo |
| `ConnectivityProvider` | `ChangeNotifier` | Estado de red |
| `FavoritesProvider` | `ChangeNotifier` | Favoritos persistidos en `SharedPreferences` |
| `AdRepository` | `ProxyProvider` | Repositorio de anuncios |
| `AdminRepository` | `ProxyProvider` | Repositorio de pantallas admin |
| `UserRepository` | `ProxyProvider` | Repositorio de usuario |
| `ChatRepository` | `ProxyProvider` | Repositorio de mensajería |
| `AnalyticsService` | `ProxyProvider` | Registro de eventos |

---

## Funcionalidades principales

### Autenticación
- Login / Registro con validación de formulario (`GlobalKey<FormState>`)
- Token JWT guardado en `FlutterSecureStorage`
- Auto-logout en respuesta 401 vía callback `onSessionExpired`
- Usuarios no registrados identificados con `guestId` efímero

### Feed de anuncios
- Paginación: 12 anuncios por página, carga incremental al llegar al final del scroll
- Filtros por categoría y ciudad
- Favoritos persistidos localmente con corazón superpuesto en cada card

### Chat
- Transporte preferente: **WebSocket** (`web_socket_channel`)
- Fallback automático: polling cada 5 segundos si el WS no conecta
- Mensajes optimistas: aparecen en UI antes de confirmación del servidor
- Soporte de imágenes: comprimidas al 70% antes de enviar
- Separadores de fecha (HOY / AYER / dd MMM yyyy)

### Notificaciones
- Push via **Firebase Cloud Messaging**
- Polling in-app con **exponential backoff**: 10s → 20s → 40s … cap 5 min
- Reinicio del intervalo al reanudar la app (`WidgetsBindingObserver`)
- Pausa automática al minimizar

### Splash screen
- Fondo `#E2E000`, logo `assets/splash_padded.png` centrado, duración 3 segundos
- Ruta inicial `/splash` → navega al Home al completarse

### Pantalla intersticial
Aparece al abrir la app si hay un intersticial activo en el servidor.

**Flujo sin parpadeo:**
1. Home invisible (`AnimatedOpacity opacity:0`) mientras se verifica
2. `precacheImage()` carga la imagen antes de pushear la ruta
3. `Navigator.push` con `opaque: false` (overlay sobre el home)
4. Anuncios se cargan en paralelo durante la visualización del intersticial
5. Al cerrar: `_interstitialChecked = true` → home hace fade-in 200 ms con anuncios ya cargados

**Display:** `BoxFit.fitWidth` — llena el ancho de pantalla escalando el alto proporcionalmente.

### Pantallas admin
Accesibles solo si el usuario tiene rol admin:

| Pantalla | Endpoint principal |
|----------|--------------------|
| Analytics | `GET /admin/stats` |
| Cola de aprobación | `GET /admin/stats` + `POST /admin/approve-ad` |
| Marketing / Banners | CRUD `/admin/banners` — carrusel e intersticial |
| Centro Push | `POST /admin/broadcast` |

**AdminMarketingScreen** gestiona dos tipos:
- **Pantalla intersticial**: imagen a pantalla completa con CTA opcional. Solo una activa.  Tamaño recomendado: 1080 × 1920 px.
- **Banners de carrusel**: deslizables en el Home. Tamaño recomendado: 1200 × 450 px.

Los cambios se reflejan **en caliente** al cambiar de tab vía `NavigationProvider` + `ValueKey(_bannerRefreshKey)`.

Hot-reload de banners: listener en `NavigationProvider` detecta regreso al tab Home e incrementa `_bannerRefreshKey`, forzando re-fetch del `BannerCarousel`.

### Perfil y cuenta
- Edición de anuncios con auto-guardado de borrador cada 3 segundos (`SharedPreferences`)
- Geocodificación inversa de coordenadas GPS (`geocoding`)
- Compresión de imágenes antes de subir: 85 % calidad / 1280 px, fallback 60 % / 960 px
- Cierre de cuenta con confirmación + logout limpio
- Configuración de preferencias de notificaciones

### Offline
- `ConnectivityProvider` escucha `connectivity_plus`
- `OfflineBanner` (banner rojo animado) se muestra en `HomeScreen` y `ChatDetailScreen`

---

## Tests unitarios

```bash
flutter test
```

| Archivo | Cobertura |
|---------|-----------|
| `test/features/auth/auth_provider_test.dart` | Login, logout, delegación, estados de carga |
| `test/core/services/favorites_provider_test.dart` | Toggle, persistencia, restauración |
| `test/features/notifications/notification_provider_test.dart` | Backoff: 10s→20s→40s→300s, reset |

**33 tests, 0 fallos.**

---

## Variables de entorno / Configuración

Editar `lib/core/api_service.dart`:

```dart
static String get baseUrl {
  if (kIsWeb) return 'http://localhost:4000/api';
  return 'http://192.168.1.5:4000/api'; // IP WiFi para dispositivos reales
}
```

Para producción, reemplazar con la URL del servidor desplegado.

---

## Build de producción

```bash
# Android APK
flutter build apk --release

# Android App Bundle (Play Store)
flutter build appbundle --release

# iOS (requiere Mac + Xcode)
flutter build ios --release

# Web
flutter build web --release
```

Los iconos y splash screen se generan con:

```bash
flutter pub run flutter_launcher_icons
flutter pub run flutter_native_splash:create
```

---

## Dependencias clave

| Paquete | Uso |
|---------|-----|
| `dio` | Cliente HTTP con interceptores |
| `provider` | Gestión de estado |
| `flutter_secure_storage` | Token JWT seguro |
| `shared_preferences` | Favoritos y borradores |
| `cached_network_image` + `flutter_cache_manager` | Caché de imágenes (7 días, 200 objetos) |
| `web_socket_channel` | Chat en tiempo real |
| `connectivity_plus` | Detección de red |
| `geocoding` | Geocodificación inversa |
| `flutter_image_compress` | Compresión antes de subir |
| `firebase_core` + `firebase_messaging` | Push notifications |
| `fl_chart` | Gráficos de analíticas admin |
| `google_fonts` | Tipografía (Inter + Outfit) |
| `url_launcher` | Abrir enlaces externos desde el intersticial |
