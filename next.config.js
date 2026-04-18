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
  // Soporte para Turbopack en desarrollo
  turbopack: {
    rules: {
      '*.svg': {
        loaders: ['@svgr/webpack'],
        as: '*.js',
      },
    },
  },
};

export default nextConfig;
