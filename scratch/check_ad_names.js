import mysql from 'mysql2/promise';

async function test() {
  const connection = await mysql.createConnection({
    host: '127.0.0.1',
    user: 'root',
    password: '',
    database: 'klicus_db'
  });

  try {
    const [rows] = await connection.execute(`
      SELECT a.title, p.business_name, p.full_name 
      FROM advertisements a 
      JOIN profiles p ON a.owner_id = p.id 
      LIMIT 1
    `);
    console.log('Sample Ad Info:', rows[0]);
  } catch (err) {
    console.error('Database Error:', err.message);
  } finally {
    await connection.end();
  }
}

test();
