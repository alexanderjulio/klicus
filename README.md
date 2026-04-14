# KLICUS Marketplace

KLICUS es una plataforma de pautas publicitarias premium diseñada para conectar profesionales, comercios y empresas con su audiencia local. El sistema ofrece una experiencia multi-plataforma (Web, PWA e instalable en móviles) con un diseño minimalista y de alta gama.

## 🚀 Tecnologías Principales

- **Frontend**: [Next.js 15](https://nextjs.org/) (App Router).
- **Base de Datos**: [MySQL](https://www.mysql.com/) local.
- **Autenticación**: [NextAuth.js](https://next-auth.js.org/).
- **Pagos**: [Mercado Pago SDK](https://www.mercadopago.com.co/developers/es/docs/sdks-library/server-side/nodejs).
- **Procesamiento de Imágenes**: [Sharp](https://sharp.pixelplumbing.com/) (Optimización automática a WebP).
- **Mobile Support**: [Capacitor](https://capacitorjs.com/) para despliegue en Android e iOS.
- **Aesthetics**: Vanilla CSS con un sistema de tokens HSL dinámicos.

## 🛠️ Estructura del Proyecto

```text
/src
  /app           # Rutas y lógica de servidor (Next.js App Router)
  /components    # Módulos de UI reutilizables (AdCard, Navigation, etc.)
  /lib           # Clientes y servicios core (DB, Mercado Pago, Imágenes)
  /styles        # Sistema de diseño con variables HSL
/public          # Assets estáticos y carga de imágenes
/scratch         # Scripts de configuración y ayuda
schema.sql       # Definición de la base de datos MySQL
```

## ⚙️ Configuración Inicial

### 1. Base de Datos
1. Asegúrate de tener **XAMPP** o un servidor MySQL local funcionando.
2. Crea una base de datos llamada `klicus_db`.
3. Ejecuta el archivo `schema.sql` en tu gestor de base de datos o corre el script:
   ```bash
   node scratch/setup_db.js
   ```

### 2. Variables de Entorno
Crea un archivo `.env.local` en la raíz con lo siguiente:
```env
# Database
MYSQL_HOST=localhost
MYSQL_USER=root
MYSQL_PASSWORD=tu_password
MYSQL_DATABASE=klicus_db

# NextAuth
NEXTAUTH_URL=http://localhost:3000
NEXTAUTH_SECRET=tu_secreto_aleatorio

# Mercado Pago
MP_ACCESS_TOKEN=tu_access_token
```

### 3. Desarrollo
```bash
npm install
npm run dev
```

## 💎 Características Premium

- **Jerarquía Ad-Priority**: Los anuncios "Diamante" tienen visibilidad expandida y estilo destacado.
- **Smart WebP Image Engine**: Todas las fotos subidas se procesan en el servidor para reducir el peso hasta un 80%, mejorando la velocidad de carga en móviles.
- **Panel Administrativo**: Los anuncios requieren aprobación explícita antes de publicarse para garantizar calidad de contenido.

---
Desarrollado con ❤️ para KLICUS Marketplace.
