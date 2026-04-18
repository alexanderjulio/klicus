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
    console.log('--- Final Connectivity Test ---');
    const [rows] = await pool.execute('SELECT 1 as success');
    console.log('Status: UNBLOCKED');
    console.log('Result:', rows[0].success);
  } catch (err) {
    console.error('Status: STILL BLOCKED');
    console.error('Error:', err.message);
  } finally {
    await pool.end();
  }
}

test();
