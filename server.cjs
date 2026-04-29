// Startup file para cPanel CloudLinux NodeJS Selector
process.env.HOSTNAME = '0.0.0.0';

import('./app/server.js').catch(err => {
  console.error('Startup failed:', err.message);
  console.error(err.stack);
  process.exit(1);
});
