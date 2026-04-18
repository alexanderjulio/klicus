import { query } from '../src/lib/db.js';

async function mockRegister() {
  try {
    // 1. Find an admin user to link the mock token to
    const users = await query('SELECT id, email FROM profiles WHERE role = "admin" LIMIT 1');
    if (users.length === 0) {
      console.log('❌ No admin users found in DB.');
      return;
    }

    const adminUser = users[0];
    const mockToken = 'mock_fcm_token_for_testing_' + Math.random().toString(36).substring(7);

    // 2. Insert mock token
    await query(`
      INSERT INTO user_fcm_tokens (user_id, token, device_type)
      VALUES (?, ?, 'web_mock')
      ON DUPLICATE KEY UPDATE last_used = CURRENT_TIMESTAMP
    `, [adminUser.id, mockToken]);

    console.log(`✅ EXITO: Registrado Token Mock para ${adminUser.email}`);
    console.log('Ahora puedes intentar enviar el Broadcast desde el panel de Administración.');
    
    process.exit(0);
  } catch (err) {
    console.error('❌ Error in mock registration:', err);
    process.exit(1);
  }
}

mockRegister();
