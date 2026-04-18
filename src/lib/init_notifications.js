import { query } from './db.js';

async function init() {
  try {
    console.log('📦 [DB] Inicializando infraestructura de Notificaciones Push...');
    
    await query(`
      CREATE TABLE IF NOT EXISTS user_fcm_tokens (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_id VARCHAR(100) NOT NULL,
        token TEXT NOT NULL,
        device_type VARCHAR(20) DEFAULT 'mobile',
        last_used TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        UNIQUE KEY unique_token (token(255))
      )
    `, []);
    
    console.log('✅ [DB] Tabla `user_fcm_tokens` lista.');
    process.exit(0);
  } catch (error) {
    console.error('❌ [DB] Error inicializando tablas:', error);
    process.exit(1);
  }
}

init();
