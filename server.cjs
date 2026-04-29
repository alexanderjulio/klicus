// Startup file para cPanel CloudLinux / Phusion Passenger
// Usa http.createServer nativo en vez de startServer de Next.js
// para evitar conflictos con las señales que envía Passenger al proceso

'use strict';

const http = require('http');
const path = require('path');

process.env.NODE_ENV = 'production';
process.env.HOSTNAME = '0.0.0.0';

const PORT = parseInt(process.env.PORT, 10) || 3000;
const DIR  = path.join(__dirname, 'app');

async function main() {
  // Cargar Next.js desde el standalone bundle
  const { default: next } = await import(path.join(DIR, 'node_modules', 'next', 'dist', 'server', 'next.js'));

  const app    = next({ dev: false, dir: DIR, hostname: '0.0.0.0', port: PORT });
  const handle = app.getRequestHandler();

  await app.prepare();

  const server = http.createServer((req, res) => {
    handle(req, res);
  });

  server.listen(PORT, '0.0.0.0', () => {
    console.log(`KLICUS ready on http://0.0.0.0:${PORT}`);
  });

  server.on('error', (err) => {
    console.error('Server error:', err);
    process.exit(1);
  });
}

main().catch(err => {
  console.error('Fatal startup error:', err);
  process.exit(1);
});
