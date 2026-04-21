import { query } from './src/lib/db.js';

async function audit() {
  console.log('🔍 [DB-AUDIT] Consultando estructura de la tabla notifications...');
  try {
    const columns = await query('SHOW COLUMNS FROM notifications');
    console.log('📊 Columnas encontradas:', columns.map(c => c.Field).join(', '));
    process.exit(0);
  } catch (err) {
    console.error('❌ Error en auditoría:', err.message);
    process.exit(1);
  }
}

audit();
