/** @type {import('next').NextConfig} */
const nextConfig = {
  // Configuración de dominios autorizados para imágenes de Firebase Storage
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'firebasestorage.googleapis.com',
        port: '',
        pathname: '/v0/b/**',
      },
      {
        protocol: 'https',
        hostname: 'images.unsplash.com',
        port: '',
        pathname: '/**',
      }
    ],
    unoptimized: true, // Requerido para despliegues estáticos y Firebase URLs dinámicas
  },
  // Optimización para despliegues en servidores limitados (cPanel/Shared)
  output: 'standalone',
  // Habilitar CORS para permitir que aplicaciones externas (Flutter) se conecten
  async headers() {
    return [
      {
        source: "/api/:path*",
        headers: [
          { key: "Access-Control-Allow-Credentials", value: "true" },
          { key: "Access-Control-Allow-Origin", value: "*" }, // En producción, se recomienda especificar el dominio
          { key: "Access-Control-Allow-Methods", value: "GET,DELETE,PATCH,POST,PUT" },
          { key: "Access-Control-Allow-Headers", value: "X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version, Authorization, X-Guest-ID, X-Guest-Name" },
        ]
      }
    ]
  },
  /*
  turbopack: {
    rules: {
      '*.svg': {
        loaders: ['@svgr/webpack'],
        as: '*.js',
      },
    },
  },
  */
};

export default nextConfig;
