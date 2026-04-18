import mysql from 'mysql2/promise';

async function checkImages() {
  try {
    const conn = await mysql.createConnection({
      host: '127.0.0.1',
      user: 'root',
      password: '',
      database: 'klicus_db'
    });

    const [rows] = await conn.execute('SELECT title, location, address FROM advertisements WHERE title LIKE "%Zaguan%"');
    console.log('--- RESULTS ---');
    console.log(JSON.stringify(rows[0], null, 2));
    
    const [bannerRows] = await conn.execute('SELECT title, image_url FROM banners LIMIT 5');
    console.log('\n--- BANNERS ---');
    console.log(JSON.stringify(bannerRows, null, 2));

    await conn.end();
  } catch (err) {
    console.error('Database Error:', err);
  }
}

checkImages();
