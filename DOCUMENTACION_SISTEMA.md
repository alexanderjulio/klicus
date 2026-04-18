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
