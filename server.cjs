// Startup file para cPanel CloudLinux NodeJS Selector
// import() dinamico carga server.js en el mismo proceso que Passenger monitorea
import('./app/server.js').catch(err => {
  console.error('Startup failed:', err.message);
  process.exit(1);
});
