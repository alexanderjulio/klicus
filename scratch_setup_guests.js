import { query } from './src/lib/db.js';

async function setup() {
  console.log('🚀 [DB-SETUP] Creando tabla de identidades de invitados...');
  try {
    await query(`
      CREATE TABLE IF NOT EXISTS guest_identities (
        id VARCHAR(255) PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);
    console.log('✅ [DB-SETUP] Tabla guest_identities lista.');
    process.exit(0);
  } catch (err) {
    console.error('❌ [DB-SETUP] Error:', err.message);
    process.exit(1);
  }
}

setup();
