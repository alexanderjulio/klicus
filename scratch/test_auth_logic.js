const mysql = require('mysql2/promise');
const bcrypt = require('bcryptjs');

async function testAuth() {
  const connection = await mysql.createConnection({
    host: '127.0.0.1',
    user: 'root',
    password: '',
    database: 'klicus_db'
  });

  const email = 'pro@klicus.com';
  const password = 'pro2026';

  try {
    const [users] = await connection.execute('SELECT * FROM profiles WHERE id = ? LIMIT 1', [email]);
    const user = users[0];

    if (user) {
      console.log('User found:', user.full_name);
      console.log('Comparing password...');
      const match = await bcrypt.compare(password, user.password_hash);
      console.log('Match result:', match);
      
      if (!match) {
        console.log('Stored Hash:', user.password_hash);
        const newHash = await bcrypt.hash(password, 12);
        console.log('Generated test Hash:', newHash);
      }
    } else {
      console.log('User NOT found');
    }

  } catch (err) {
    console.error(err);
  } finally {
    await connection.end();
  }
}

testAuth();
