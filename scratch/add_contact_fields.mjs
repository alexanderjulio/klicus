import { query, pool } from '../src/lib/db.js';

async function addContactFields() {
  console.log('🔄 [DB] Adding contact fields to advertisements table...');
  try {
    const columns = [
      'ALTER TABLE advertisements ADD COLUMN IF NOT EXISTS cellphone VARCHAR(50);',
      'ALTER TABLE advertisements ADD COLUMN IF NOT EXISTS phone VARCHAR(50);',
      'ALTER TABLE advertisements ADD COLUMN IF NOT EXISTS email VARCHAR(255);',
      'ALTER TABLE advertisements ADD COLUMN IF NOT EXISTS website_url VARCHAR(255);',
      'ALTER TABLE advertisements ADD COLUMN IF NOT EXISTS business_hours VARCHAR(255);'
    ];

    for (const sql of columns) {
      try {
        await query(sql);
        console.log(`✅ Executed: ${sql.substring(0, 40)}...`);
      } catch (err) {
        // Ignore "Duplicate column" if IF NOT EXISTS isn't supported or fails
        if (!err.message.includes('Duplicate column')) {
          console.error(`❌ Error executing ${sql}:`, err.message);
        }
      }
    }
    console.log('✨ Database schema updated successfully.');
  } catch (error) {
    console.error('🔥 DB Refactor failed:', error);
  } finally {
    await pool.end();
  }
}

addContactFields();
