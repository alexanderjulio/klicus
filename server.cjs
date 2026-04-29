// Startup file para cPanel CloudLinux NodeJS Selector
process.env.HOSTNAME = '0.0.0.0';

process.on('uncaughtException', (err) => {
  if (err.code === 'ERR_SERVER_NOT_RUNNING') return; // ignorar — Passenger restart artifact
  console.error('Uncaught exception:', err);
  process.exit(1);
});

import('./app/server.js').catch(err => {
  console.error('Startup failed:', err.message);
  console.error(err.stack);
  process.exit(1);
});
