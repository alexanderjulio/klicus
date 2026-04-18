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
    
    console.log('--- CHAT_CONVERSATIONS TABLE ---');
    const [convs] = await connection.execute('DESCRIBE chat_conversations');
    console.table(convs);

    console.log('\n--- CHAT_MESSAGES TABLE ---');
    const [msgs] = await connection.execute('DESCRIBE chat_messages');
    console.table(msgs);

    console.log('\n--- CHECKING TABLES ---');
    const [tables] = await connection.execute('SHOW TABLES');
    console.table(tables);

    await connection.end();
  } catch (error) {
    console.error('Error describing tables:', error.message);
  }
}

run();
