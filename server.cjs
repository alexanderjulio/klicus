// Startup file para cPanel CloudLinux NodeJS Selector
// cPanel lo ejecuta con: node server.cjs
// node_modules/next/dist/bin/next es el JS real — .bin/next es un shell script
const { spawn } = require('child_process');

const child = spawn(
  process.execPath,
  ['./node_modules/next/dist/bin/next', 'start'],
  { stdio: 'inherit', env: process.env }
);

child.on('exit', (code) => process.exit(code ?? 0));
