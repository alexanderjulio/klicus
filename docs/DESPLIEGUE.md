# KLICUS — Guía de Despliegue en cPanel

---

## Requisitos del servidor

- Node.js ≥ 18 (activado en cPanel → Software → Node.js)
- MySQL 8 (incluido en cPanel)
- Passenger (maneja el proceso Node.js automáticamente)
- Suficiente memoria RAM: mínimo 512MB recomendado 1GB+

---

## Preparación local

```bash
# 1. Build de producción
npm run build

# 2. Comprimir para subir (excluir node_modules y archivos sensibles)
zip -r klicus_deploy.zip . \
  --exclude "node_modules/*" \
  --exclude ".git/*" \
  --exclude ".env.local" \
  --exclude "config/firebase-admin.json" \
  --exclude "*.zip"
```

---

## Configuración en cPanel

### 1. Subir archivos

1. Ir a **File Manager** en cPanel
2. Subir `klicus_deploy.zip` a la carpeta de la aplicación (ej: `/home/usuario/klicus/`)
3. Extraer el ZIP

### 2. Configurar Node.js App

1. Ir a **Setup Node.js App** en cPanel
2. Crear nueva aplicación:
   - **Node.js version:** 18+ (o la más reciente disponible)
   - **Application mode:** Production
   - **Application root:** `/home/usuario/klicus`
   - **Application URL:** `tudominio.com`
   - **Application startup file:** `server.cjs`

3. Hacer clic en **Run NPM Install**

### 3. Variables de entorno

En la sección **Environment Variables** de la app Node.js en cPanel, agregar todas las variables del `.env.production.sample`:

```
NODE_ENV=production
PORT=3000
MYSQL_HOST=localhost
MYSQL_USER=usuario_cpanel_db
MYSQL_PASSWORD=password_db
MYSQL_DATABASE=nombre_db
NEXTAUTH_URL=https://tudominio.com
NEXTAUTH_SECRET=clave_generada_con_openssl
FIREBASE_SERVICE_ACCOUNT_BASE64=<base64_del_json>
FIREBASE_STORAGE_BUCKET=klicus-4b8a7.appspot.com
MP_ACCESS_TOKEN=APP_USR-...
ALLOWED_ORIGINS=https://tudominio.com
NEXT_SHARP_PATH=/home/usuario/klicus/node_modules/sharp
```

**Cómo generar `FIREBASE_SERVICE_ACCOUNT_BASE64`:**
```bash
# En tu máquina local
cat config/firebase-admin.json | base64 -w 0
# Pegar el resultado como valor de la variable
```

### 4. Base de datos

1. En cPanel → **MySQL Databases**: crear base de datos y usuario
2. Asignar todos los privilegios al usuario sobre la base de datos
3. Importar el schema:
   - Via **phpMyAdmin**: importar `schema.sql`
   - Via terminal: `mysql -u usuario -p nombre_db < schema.sql`
4. Ejecutar migraciones adicionales:
   ```bash
   node migrate_fase3.js
   ```

---

## Configuración de Firebase

### Storage Rules
En **Firebase Console → Storage → Rules**, verificar que los anuncios sean de lectura pública:
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /ads/{allPaths=**} {
      allow read: if true;
      allow write: if false;
    }
    match /marketing/{allPaths=**} {
      allow read: if true;
      allow write: if false;
    }
  }
}
```

### FIREBASE_STORAGE_BUCKET
El valor debe coincidir con el nombre del bucket en **Firebase Console → Storage**.  
Formato típico: `nombreproyecto.appspot.com`

---

## Webhook de Mercado Pago

Configurar en **Mercado Pago Developers → Webhooks**:
- URL: `https://tudominio.com/api/billing/webhook`
- Eventos: `payment`

Verificar que el servidor sea accesible públicamente desde Internet (MP necesita hacer el POST).

---

## Proceso de actualización (deploy)

```bash
# 1. En local: build
npm run build

# 2. Subir solo los archivos cambiados, o el ZIP completo
# Opción rápida — solo los archivos compilados:
zip -r update.zip .next/ src/ public/ schema.sql package.json

# 3. En cPanel — después de subir y extraer:
#    - Setup Node.js App → Restart application
```

---

## Verificación post-deploy

```bash
# Comprobar que la app responde
curl https://tudominio.com/api/categories

# Comprobar auth (debe retornar 401)
curl https://tudominio.com/api/user/profile

# Ver logs de Passenger
# cPanel → Errors o revisar el archivo de logs de la aplicación
```

---

## Solución de problemas comunes

### La app no inicia
- Verificar que `server.cjs` existe en la raíz del proyecto
- Revisar el log de errores de Passenger en cPanel
- Confirmar que todas las variables de entorno están configuradas

### Error de conexión a MySQL
- Verificar `MYSQL_HOST=localhost` (en cPanel siempre es localhost)
- Confirmar que el usuario tiene privilegios sobre la base de datos
- Probar conexión desde phpMyAdmin

### Imágenes no se suben
- Verificar `FIREBASE_STORAGE_BUCKET` — debe coincidir con el bucket real
- Verificar que `FIREBASE_SERVICE_ACCOUNT_BASE64` es válido:
  ```bash
  echo "<valor>" | base64 -d | python3 -m json.tool
  ```
- Revisar Firebase Storage Rules (lectura pública habilitada)

### Las notificaciones push no llegan
- Verificar que la service account de Firebase tiene el rol **Firebase Cloud Messaging Admin**
- Confirmar que los tokens FCM están siendo registrados (`user_fcm_tokens` tiene registros)

### Sharp no funciona
- Asegurarse de que `NEXT_SHARP_PATH` apunta al directorio correcto
- Ejecutar `npm install --platform=linux --arch=x64 sharp` en el servidor si es necesario

---

## Estructura de archivos en producción

```
/home/usuario/klicus/
├── .next/              # Build de Next.js (generado por npm run build)
├── src/                # Código fuente
├── public/
│   └── uploads/        # Imágenes locales (fallback cuando Firebase no está)
│       └── ads/
├── node_modules/
├── server.cjs          # Archivo de inicio para Passenger
├── package.json
├── schema.sql
└── .env                # Variables de entorno (NO subir al repositorio)
```
