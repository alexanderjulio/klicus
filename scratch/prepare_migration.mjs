import { query, pool } from '../src/lib/db.js';

async function prepareMigration() {
  console.log('🔍 [PREPARING] Validating categories and users...');

  try {
    // 1. Create System Profile if not exists
    const systemId = 'import_system_user';
    const profiles = await query('SELECT id FROM profiles WHERE id = ?', [systemId]);
    
    if (profiles.length === 0) {
      console.log('➕ Creating SYSTEM_IMPORT profile...');
      await query(`
        INSERT INTO profiles (id, full_name, business_name, role, bio) 
        VALUES (?, ?, ?, ?, ?)
      `, [systemId, 'Sistema de Importación', 'KLICUS Corp', 'admin', 'Cuenta automática para la carga inicial de datos desde Firebase.']);
    } else {
      console.log('✅ SYSTEM_IMPORT profile already exists.');
    }

    // 2. Check categories
    const categories = await query('SELECT id, name FROM categories');
    console.log('📊 Available Categories:', categories);

    if (categories.length === 0) {
      console.warn('⚠️ No categories found! Migration might fail due to FK constraints.');
      console.log('🔧 Creating default category...');
      await query('INSERT INTO categories (name, slug, icon) VALUES (?, ?, ?)', ['General', 'general', 'Layers']);
    }

  } catch (error) {
    console.error('❌ Preparation failed:', error);
  } finally {
    await pool.end();
  }
}

prepareMigration();
