import { query, pool } from '../src/lib/db.js';

async function expandDBSchema() {
  console.log('🔄 [DB] Expanding schema with Social and Delivery fields...');
  try {
    const columns = [
      'ALTER TABLE advertisements ADD COLUMN IF NOT EXISTS facebook_url VARCHAR(255);',
      'ALTER TABLE advertisements ADD COLUMN IF NOT EXISTS instagram_url VARCHAR(255);',
      'ALTER TABLE advertisements ADD COLUMN IF NOT EXISTS delivery_info TEXT;'
    ];

    for (const sql of columns) {
      try {
        await query(sql);
        console.log(`✅ Executed: ${sql.substring(0, 40)}...`);
      } catch (err) {
        if (!err.message.includes('Duplicate column')) {
          console.error(`❌ Error executing ${sql}:`, err.message);
        }
      }
    }
    console.log('✨ Database schema expansion completed.');
  } catch (error) {
    console.error('🔥 DB Expansion failed:', error);
  } finally {
    await pool.end();
  }
}

expandDBSchema();
