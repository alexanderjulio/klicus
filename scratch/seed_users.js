const mysql = require('mysql2/promise');
const bcrypt = require('bcryptjs');

async function seedUsers() {
  const connection = await mysql.createConnection({
    host: '127.0.0.1',
    user: 'root',
    password: '',
    database: 'klicus_db'
  });

  try {
    const adminPass = await bcrypt.hash('admin2026', 12);
    const proPass = await bcrypt.hash('pro2026', 12);

    console.log('Seeding users with Email column...');

    // 1. Clear existing test accounts
    await connection.execute('DELETE FROM profiles WHERE email IN ("admin@klicus.com", "pro@klicus.com") OR id IN ("admin@klicus.com", "pro@klicus.com")');

    // 2. Insert Admin
    await connection.execute(`
      INSERT INTO profiles (id, email, full_name, role, password_hash) 
      VALUES ("admin-uuid-1", "admin@klicus.com", "Admin KLICUS", "admin", ?)
    `, [adminPass]);

    // 3. Insert Professional
    await connection.execute(`
      INSERT INTO profiles (id, email, full_name, role, password_hash) 
      VALUES ("pro-uuid-1", "pro@klicus.com", "Juan Anunciante", "professional", ?)
    `, [proPass]);

    // 4. Assign an ad to 'pro-uuid-1'
    await connection.execute(`
      UPDATE advertisements 
      SET owner_id = "pro-uuid-1" 
      WHERE title = "Limpieza Dental Profunda"
    `);

    console.log('Users seeded successfully with dedicated Email column.');

  } catch (err) {
    console.error('Seed Error:', err);
  } finally {
    await connection.end();
  }
}

seedUsers();
