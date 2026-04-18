const mysql = require('mysql2/promise');

async function testQuery() {
  const connection = await mysql.createConnection({
    host: '127.0.0.1',
    user: 'root',
    password: '',
    database: 'klicus_db'
  });

  const userId = 'demo-user-123'; // Sample ID

  try {
    console.log('Testing Advertiser Stats Query...');
    const [ads] = await connection.execute(`
      SELECT 
        a.*, 
        c.name as category_name,
        (SELECT COUNT(*) FROM metrics WHERE ad_id = a.id AND event_type = 'click') as real_clicks,
        (SELECT COUNT(*) FROM metrics WHERE ad_id = a.id AND event_type = 'view') as real_views
      FROM advertisements a
      LEFT JOIN categories c ON a.category_id = c.id
      WHERE a.owner_id = ?
      ORDER BY a.created_at DESC
    `, [userId]);
    
    console.log('Ads found:', ads.length);
    console.log('Success!');

  } catch (err) {
    console.error('SQL Error detected:', err.message);
  } finally {
    await connection.end();
  }
}

testQuery();
