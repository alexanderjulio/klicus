# 🚀 Guía de Despliegue en Conexcol (Hosting Compartido sin Terminal) - KLICUS

Si tu hosting no permite el acceso a la Terminal (SSH), seguiremos una estrategia de **Construcción Local y Carga Manual**. Esto es más seguro y evita límites de memoria en el servidor.

## 0. Conexión Automática (GitHub Actions + FTP)
Esta es la forma de "conectar" GitHub con tu hosting para que el despliegue sea automático cada vez que hagas un `git push`:

He creado un archivo en `.github/workflows/deploy.yml` que hace lo siguiente:
1. Detecta cuando subes cambios a la rama `main` en GitHub.
2. Ejecuta el `build` en los servidores de GitHub (así no dependes de la memoria de tu hosting).
3. Envía los archivos listos (`standalone`) a tu hosting vía FTP.

**Para que esto funcione, debes configurar 3 "Secrets" en tu repositorio de GitHub:**
1. Ve a tu repo en GitHub -> **Settings** -> **Secrets and variables** -> **Actions**.
2. Añade los siguientes **New repository secret**:
   - `FTP_SERVER`: La dirección FTP de Conexcol (ej: `ftp.tudominio.com`).
   - `FTP_USERNAME`: Tu usuario de FTP/cPanel.
   - `FTP_PASSWORD`: Tu contraseña de FTP/cPanel.

---

## 1. Preparación de la Base de Datos en cPanel
1. Entra a cPanel -> **MySQL Database Wizard**.
2. Crea una base de datos (ej: `klicus_db`), un usuario y una contraseña fuerte.
3. Entra a **phpMyAdmin**, selecciona la base de datos y haz clic en **Importar**.
4. Sube el archivo `klicus_backup_stable_2026-04-25.sql` de tu proyecto.

## 2. Construcción Local (En tu computadora)
1. Abre tu terminal local en la carpeta del proyecto.
2. Ejecuta el comando:
   ```bash
   npm run build
   ```
3. Next.js creará una carpeta oculta llamada `.next`. Dentro de ella, gracias a la configuración `output: 'standalone'`, encontrarás una carpeta llamada `standalone`.

## 3. Preparación del Paquete de Carga
Para que la app funcione en cPanel, necesitamos organizar los archivos antes de subirlos:
1. Entra a la carpeta `.next/standalone`.
2. **Copia** la carpeta `public` (de la raíz de tu proyecto) dentro de `.next/standalone/`.
3. **Copia** la carpeta `static` (que está en `.next/static`) dentro de `.next/standalone/.next/static`.
   - *Nota: Si la carpeta `.next/static` no existe dentro de standalone, créala manualmente.*
4. **Nota**: El archivo `server.js` que se encuentra dentro de `.next/standalone` es el motor de tu aplicación para producción. No lo sobrescribas con versiones locales.

## 4. Carga de Archivos al Servidor
1. Usa el **Administrador de Archivos** de cPanel o un cliente FTP (como FileZilla).
2. Crea una carpeta para tu app (ej: `/home/tu_usuario/klicus_app`).
3. Sube **todo el contenido** de la carpeta `.next/standalone` a esa carpeta en el servidor.
4. Asegúrate de que el archivo `server.js` (el generado por el build) esté en la raíz de esa carpeta.

## 5. Configuración de la App de Node.js en cPanel
1. Ve a **Setup Node.js App** en cPanel.
2. Haz clic en **Create Application**.
3. Configura los campos:
   - **Node.js version**: 18.x o superior.
   - **Application mode**: Production.
   - **Application root**: `klicus_app` (la carpeta que creaste).
   - **Application URL**: Tu dominio principal.
   - **Startup file**: `server.js`.
4. **Variables de Entorno**: En la misma pantalla, busca "Environment variables" y añade una por una las de tu archivo `.env.production.sample`:
   - `MYSQL_HOST`, `MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_DATABASE`
   - `NEXTAUTH_URL` (tu dominio real con https)
   - `NEXTAUTH_SECRET` (una clave larga y aleatoria)
5. Haz clic en **Save** y luego en **Restart**.

## 6. Actualizaciones Futuras
Cuando hagas cambios en el código:
1. Ejecuta `npm run build` en tu computadora.
2. Sube solo los archivos modificados o reemplaza el contenido de la carpeta en el servidor.
3. Haz clic en **Restart** en el "Setup Node.js App" de cPanel.

---
**¿Por qué lo hacemos así?**
Al no tener terminal, no puedes ejecutar `npm install` ni `build` en el servidor. Al construirlo localmente, subes la aplicación ya "lista para correr", lo que consume menos recursos del hosting y evita errores de permisos.
