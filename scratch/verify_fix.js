const mysql = require('mysql2/promise');

async function test() {
  const pool = mysql.createPool({
    host: '127.0.0.1',
    user: 'root',
    password: '',
    database: 'klicus_db',
    connectionLimit: 1
  });

  try {
    console.log('Testing Single Connection...');
    const [rows] = await pool.execute('SELECT 1 as success');
    console.log('Success:', rows[0].success);
  } catch (err) {
    console.error('STILL BLOCKED:', err.message);
  } finally {
    await pool.end();
  }
}

test();
