const mysql = require('mysql2/promise');

async function populateAd() {
  const connection = await mysql.createConnection({
    host: '127.0.0.1',
    user: 'root',
    password: '',
    database: 'klicus_db'
  });

  try {
    await connection.execute(`
      UPDATE advertisements 
      SET 
        address = 'Calle 82 # 11-75, El Retiro',
        business_hours = 'Lunes a Sábado: 8:00 AM - 7:00 PM',
        phone = '601 345 6789',
        cellphone = '+573201234567',
        email = 'contacto@clinicadental.com',
        website_url = 'https://clinicadental.com',
        facebook_url = 'https://facebook.com/clinicadental',
        instagram_url = 'https://instagram.com/clinicadental',
        delivery_info = 'si',
        price_range = '$150.000 - $300.000'
      WHERE title = 'Limpieza Dental Profunda'
    `);
    console.log('Ad populated successfully');
  } catch (err) {
    console.error(err);
  } finally {
    await connection.end();
  }
}

populateAd();
