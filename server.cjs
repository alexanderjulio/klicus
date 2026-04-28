// Startup file para cPanel CloudLinux NodeJS Selector
// El standalone de Next.js vive en ./app/ para evitar conflicto con el symlink
// node_modules que maneja CloudLinux en la raiz de la app
const { spawn } = require('child_process');
const { join } = require('path');

const appDir = join(__dirname, 'app');

const child = spawn(
  process.execPath,
  [join(appDir, 'server.js')],
  {
    stdio: 'inherit',
    env: process.env,
    cwd: appDir
  }
);

child.on('exit', (code) => process.exit(code ?? 0));
