import { query } from './src/lib/db.js';

async function fix() {
  console.log('🛠️ [DB-FIX] Reparando tabla notifications...');
  try {
    await query('ALTER TABLE notifications ADD COLUMN IF NOT EXISTS related_id VARCHAR(255) AFTER type');
    console.log('✅ [DB-FIX] Columna related_id añadida con éxito.');
    process.exit(0);
  } catch (err) {
    console.error('❌ Error en reparación:', err.message);
    process.exit(1);
  }
}

fix();
