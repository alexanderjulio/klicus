# Guía de Despliegue — KLICUS en cPanel (CloudLinux)

## Arquitectura de producción

```
cPanel (CloudLinux NodeJS Selector)
├── Dominio: klicus.com.co → public_html/
│   └── .htaccess          ← proxy Passenger → app Node.js
└── App Node.js: ~/klicus_prod/
    ├── server.cjs          ← startup file (carga app/server.js)
    ├── package.json        ← mínimo, sin dependencias
    ├── .env                ← variables de entorno (NO en git)
    └── app/                ← build standalone de Next.js
        ├── server.js       ← servidor HTTP de Next.js
        ├── node_modules/   ← dependencias incluidas en el standalone
        ├── .next/          ← build compilado
        └── public/         ← assets estáticos
```

**Por qué standalone en `app/`**: CloudLinux exige que `node_modules` en la raíz sea un symlink de su entorno virtual. El standalone de Next.js genera una carpeta real `node_modules`. Al colocarla en el subdirectorio `app/`, se evita el conflicto.

---

## Variables de entorno requeridas (`.env` en `~/klicus_prod/`)

```env
# Base de datos MySQL (cPanel → MySQL Databases)
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_USER=klicuson_XXXX
MYSQL_PASSWORD=tu_password
MYSQL_DATABASE=klicuson_XXXX

# Autenticación NextAuth
NEXTAUTH_SECRET=cadena_aleatoria_larga
NEXTAUTH_URL=https://klicus.com.co

# Firebase Admin (notificaciones push)
# Generar con: PowerShell → ver sección Firebase más abajo
FIREBASE_SERVICE_ACCOUNT_BASE64=base64_de_firebase_admin_json

# Mercado Pago
MP_ACCESS_TOKEN=APP_USR-...

# CORS: dominios que pueden llamar a la API
ALLOWED_ORIGINS=https://klicus.com.co,https://app.klicus.com.co

# Puerto (cPanel lo inyecta automáticamente via PORT, no cambiar)
```

---

## Generar deploy.zip localmente

### Requisitos
- Node.js 20 instalado localmente
- Git Bash (incluido con Git para Windows)

### Pasos

```bash
# 1. Construir la aplicación
npm run build

# 2. Crear la estructura del paquete
rm -rf deploy_package deploy.zip
mkdir -p deploy_package/app

cp -r .next/standalone/. deploy_package/app/
cp -r public/. deploy_package/app/public/
cp -r .next/static deploy_package/app/.next/static
cp server.cjs deploy_package/
echo '{"name":"klicus","version":"0.1.0","private":true}' > deploy_package/package.json

# 3. Generar el zip (requiere Windows 10+ por tar.exe)
/c/Windows/System32/tar.exe -a -c -f deploy.zip -C deploy_package .
```

> **Importante**: usar `tar.exe` de Windows (no el de Git Bash). El zip de PowerShell `Compress-Archive` no incluye carpetas ocultas (`.next/`) ni genera paths correctos para Linux.

---

## Despliegue en cPanel

### Primera vez

1. En **cPanel → Node.js App** → crear aplicación:
   - Node.js version: `20`
   - Application root: `klicus_prod`
   - Application URL: `klicus.com.co`
   - Application startup file: `server.cjs`

2. En **cPanel → File Manager → `public_html/`** → crear `.htaccess` con:
   ```apache
   PassengerAppRoot /home/klicuson/klicus_prod
   PassengerBaseURI /
   PassengerNodejs /home/klicuson/nodevenv/klicus_prod/20/bin/node
   PassengerStartupFile server.cjs
   PassengerFriendlyErrorPages on
   ```

3. Subir `deploy.zip` a `klicus_prod/` y extraerlo ahí.

4. Crear el archivo `.env` en `~/klicus_prod/` con las variables requeridas.

5. **Node.js App → Restart**.

### Actualizaciones posteriores

1. Generar nuevo `deploy.zip` localmente.
2. En **File Manager → `klicus_prod/`** → seleccionar todo → eliminar.
3. Subir y extraer el nuevo `deploy.zip`.
4. Verificar que `.env` sigue en su lugar (no se debe eliminar).
5. **Node.js App → Restart**.

---

## Configurar Firebase Admin (notificaciones push)

El JSON de credenciales debe codificarse en base64 para evitar problemas con saltos de línea en el `.env`.

**En PowerShell (local)**:
```powershell
$bytes = [System.Text.Encoding]::UTF8.GetBytes(
    [System.IO.File]::ReadAllText("config\firebase-admin.json", [System.Text.Encoding]::UTF8)
)
[Convert]::ToBase64String($bytes)
```

Copiar el resultado y pegarlo como valor de `FIREBASE_SERVICE_ACCOUNT_BASE64` en `.env`.

> El archivo `config/firebase-admin.json` está en `.gitignore` y nunca debe subirse al repositorio.

---

## Configurar base de datos MySQL

1. En **cPanel → MySQL Databases**:
   - Crear base de datos: `klicuson_klicus`
   - Crear usuario con contraseña segura
   - Asignar todos los privilegios al usuario sobre la base de datos

2. Importar el esquema:
   - En **cPanel → phpMyAdmin** → seleccionar la base de datos → **Importar** → subir el archivo SQL

3. El host siempre es `localhost` (cPanel usa socket Unix, no TCP `127.0.0.1`).

---

## Solución de problemas

| Error | Causa | Solución |
|-------|-------|----------|
| `Cannot find module 'next'` | `.next/` no incluido en el zip | Usar `tar.exe` de Windows, no `Compress-Archive` |
| `fork: Resource temporarily unavailable` | Límite de procesos de CloudLinux | `turbopackPluginRuntimeStrategy` debe ser `inProcess` en `server.js` |
| `ECONNREFUSED 127.0.0.1:3306` | MySQL host incorrecto | Usar `MYSQL_HOST=localhost` en `.env` |
| `Firebase Admin init error: not valid JSON` | Base64 con encoding incorrecto | Regenerar con PowerShell usando `UTF8.GetBytes` |
| `403 Forbidden` | Falta el `.htaccess` de Passenger | Crear `.htaccess` en `public_html/` |
| `503 Service Unavailable` | App crashea al arrancar | Revisar logs en cPanel → Node.js App |
| Logo/assets con 404 | `public/` copiada anidada | Usar `cp -r public/. dest/` (con barra punto) |

---

## Notas importantes

- **No hacer `npm install` manualmente** en `klicus_prod/`. El standalone incluye todas las dependencias en `app/node_modules/`. CloudLinux gestiona el symlink de la raíz.
- **El `.env` no se sube al repositorio** ni se incluye en el zip. Debe crearse manualmente en el servidor.
- **El puerto lo asigna cPanel** automáticamente via la variable `PORT`. No hardcodear puertos en el código.
- **CORS** se gestiona en `src/middleware.js`. Agregar dominios nuevos en `ALLOWED_ORIGINS` en el `.env`.
