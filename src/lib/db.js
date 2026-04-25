/**
 * Conector de Base de Datos KLICUS - ESTABILIDAD V17-ULTRA-RESILIENT
 * Implementa un pool con gestión de errores global para evitar que Next.js se detenga.
 * Aumenta re-intentos y mejora el log de depuración para producción/dev.
 */
import mysql from 'mysql2/promise';

const poolConfig = {
  host: process.env.MYSQL_HOST || '127.0.0.1',
  port: parseInt(process.env.MYSQL_PORT || '3306'),
  user: process.env.MYSQL_USER || 'root',
  password: process.env.MYSQL_PASSWORD || '',
  database: process.env.MYSQL_DATABASE || 'klicus_db',
  waitForConnections: true,
  connectionLimit: 5,
  queueLimit: 0,
  enableKeepAlive: true,
  keepAliveInitialDelay: 10000
};

// Singleton persistente con marca de agua V17
let pool;
const globalKey = Symbol.for('klicus.db.pool.v17');

if (!global[globalKey]) {
  console.log(`🚀 [DB] Initializing Global Pool (V17-ULTRA-RESILIENT) at ${new Date().toISOString()}`);
  global[globalKey] = mysql.createPool(poolConfig);

  // Manejador de errores global para el pool para evitar caídas del proceso
  global[globalKey].on('error', (err) => {
    console.error('⚠️ [DB-POOL] Error inesperado:', err.message);
    if (err.code === 'PROTOCOL_CONNECTION_LOST') {
      console.warn('🔄 [DB-POOL] Reestableciendo conexión perdida...');
    }
  });
}
pool = global[globalKey];

export async function query(sql, params) {
  let attempts = 0;
  const maxAttempts = 5;

  while (attempts < maxAttempts) {
    try {
      const [results] = await pool.execute(sql, params);
      return results;
    } catch (error) {
      attempts++;
      const isSaturation = error.code === 'ER_CON_COUNT_ERROR' || error.message.includes('Saturated');

      if (isSaturation && attempts < maxAttempts) {
        console.warn(`🕒 [DB-V17] Saturación detectada. Re-intento ${attempts}/${maxAttempts}...`);
        await new Promise(resolve => setTimeout(resolve, 1000 * attempts));
        continue;
      }

      if (error.code === 'PROTOCOL_CONNECTION_LOST' && attempts < maxAttempts) {
        continue;
      }

      console.error('❌ [DB-V17] Error en consulta:', error.message);
      throw error;
    }
  }
}
