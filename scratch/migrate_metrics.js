import { query } from '../src/lib/db.js';

async function migrate() {
  try {
    console.log('🔄 Iniciando migración de métricas...');
    
    // 1. Update event_type
    await query(`
      ALTER TABLE metrics 
      MODIFY COLUMN event_type ENUM('view', 'click', 'contact', 'install', 'session') NOT NULL
    `);
    
    // 2. Update device_type
    await query(`
      ALTER TABLE metrics 
      MODIFY COLUMN device_type ENUM('mobile', 'desktop', 'pwa', 'mobile-app') DEFAULT 'desktop'
    `);
    
    console.log('✅ Base de Datos actualizada para Analítica Elite.');
    process.exit(0);
  } catch (err) {
    console.error('❌ Error en migración:', err);
    process.exit(1);
  }
}

migrate();
