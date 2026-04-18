const mysql = require('mysql2/promise');

async function checkAds() {
  const connection = await mysql.createConnection({
    host: '127.0.0.1',
    user: 'root',
    password: '',
    database: 'klicus_db'
  });

  try {
    const [rows] = await connection.execute('SELECT title, address, business_hours, phone, cellphone, email FROM advertisements LIMIT 5');
    console.log(JSON.stringify(rows, null, 2));
  } catch (err) {
    console.error(err);
  } finally {
    await connection.end();
  }
}

checkAds();
