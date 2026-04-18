require('dotenv').config({ path: '.env.local' });
const mysql = require('mysql2/promise');

async function run() {
  const poolConfig = {
    host: process.env.MYSQL_HOST || '127.0.0.1',
    port: parseInt(process.env.MYSQL_PORT || '3306'),
    user: process.env.MYSQL_USER || 'root',
    password: process.env.MYSQL_PASSWORD || '',
    database: process.env.MYSQL_DATABASE || 'klicus_db',
  };

  try {
    const connection = await mysql.createConnection(poolConfig);
    const [rows] = await connection.execute('SELECT id, full_name, email, role, plan_type FROM profiles ORDER BY full_name ASC LIMIT 50');
    console.table(rows);
    await connection.end();
  } catch (error) {
    console.error('Error querying profiles:', error.message);
  }
}

run();
