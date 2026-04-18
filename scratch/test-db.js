import mysql from 'mysql2/promise';

async function test() {
  const connection = await mysql.createConnection({
    host: '127.0.0.1',
    user: 'root',
    password: '',
    database: 'klicus_db'
  });

  try {
    const [rows] = await connection.execute('SELECT COUNT(*) as count FROM profiles');
    console.log('Database Connection Successful. Profiles count:', rows[0].count);
  } catch (err) {
    console.error('Database Error:', err.message);
  } finally {
    await connection.end();
  }
}

test();
