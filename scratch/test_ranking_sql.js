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
      SELECT 
        a.id, 
        a.title, 
        a.status,
        p.full_name as owner_name
      FROM advertisements a
      LEFT JOIN profiles p ON a.owner_id = p.id
      WHERE a.status = 'active'
    `);
    console.log('Active Ads with Profile:', rows.length);
    if (rows.length > 0) console.log('First Ad:', rows[0]);
  } catch (err) {
    console.error('Database Error:', err.message);
  } finally {
    await connection.end();
  }
}

test();
