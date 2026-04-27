// Startup file para cPanel CloudLinux NodeJS Selector
// cPanel lo ejecuta con: node server.cjs
// next start lee el puerto de la variable PORT que cPanel inyecta automáticamente
const { spawn } = require('child_process');

const child = spawn(
  process.execPath,
  ['./node_modules/.bin/next', 'start'],
  { stdio: 'inherit', env: process.env }
);

child.on('exit', (code) => process.exit(code ?? 0));
