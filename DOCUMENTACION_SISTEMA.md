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
