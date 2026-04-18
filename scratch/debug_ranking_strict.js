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
        a.created_at,
        p.full_name as owner_name,
        COALESCE(SUM(CASE WHEN m.event_type = 'view' THEN 1 ELSE 0 END), 0) as views,
        COALESCE(SUM(CASE WHEN m.event_type = 'click' THEN 1 ELSE 0 END), 0) as clicks,
        COALESCE(SUM(CASE WHEN m.event_type = 'contact' THEN 1 ELSE 0 END), 0) as contacts
      FROM advertisements a
      LEFT JOIN profiles p ON a.owner_id = p.id
      LEFT JOIN metrics m ON a.id = m.ad_id
      WHERE a.status = 'active'
      GROUP BY a.id, a.title, a.status, a.created_at, p.full_name
      ORDER BY views DESC
      LIMIT 200
    `);
    console.log('API SQL Result Count:', rows.length);
    if (rows.length > 0) {
        console.log('Sample Row:', rows[0]);
    }
  } catch (err) {
    console.error('SQL Error:', err.message);
  } finally {
    await connection.end();
  }
}

test();
