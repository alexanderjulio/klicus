const mysql = require('mysql2/promise');

async function seedMarketplace() {
  const connection = await mysql.createConnection({
    host: '127.0.0.1',
    user: 'root',
    password: '',
    database: 'klicus_db'
  });

  const adsData = [
    {
      title: 'Limpieza Dental Profunda',
      address: 'Calle 82 # 11-75, El Retiro',
      business_hours: 'Lunes a Sábado: 8:00 AM - 7:00 PM',
      phone: '601 345 6789',
      cellphone: '+573102345678',
      email: 'contacto@dentalklicus.com',
      website_url: 'https://dentalklicus.com',
      facebook_url: 'https://facebook.com/dentalklicus',
      instagram_url: 'https://instagram.com/dentalklicus',
      delivery_info: 'no',
      price_range: '$120.000 - $250.000'
    },
    {
      title: 'Diseño de Interiores Jardines',
      address: 'Carrera 7 # 72-41, Bogotá',
      business_hours: 'Lunes a Viernes: 9:00 AM - 6:00 PM',
      phone: '601 876 5432',
      cellphone: '+573214567890',
      email: 'info@jardinespremium.com',
      website_url: 'https://jardinespremium.com',
      facebook_url: 'https://facebook.com/jardinespremium',
      instagram_url: 'https://instagram.com/jardinespremium',
      delivery_info: 'si',
      price_range: 'Cotización previa'
    },
    {
      title: 'Personal Trainer 24/7',
      address: 'Gimnasio BodyTech, Chicó',
      business_hours: '24 Horas / 7 Días',
      phone: 'N/A',
      cellphone: '+573009876543',
      email: 'coach@fitnessklicus.com',
      website_url: 'https://fitnessklicus.com',
      facebook_url: 'https://facebook.com/coachfitness',
      instagram_url: 'https://instagram.com/coachfitness',
      delivery_info: 'si',
      price_range: '$80.000 / sesión'
    },
    {
      title: 'Implantes Dentales 2x1',
      address: 'Av. Cra 15 # 103-22',
      business_hours: 'Lunes a Sábado: 7:00 AM - 8:00 PM',
      phone: '601 222 3344',
      cellphone: '+573156667788',
      email: 'implantes@clinicapremium.com',
      website_url: 'https://clinicapremium.com',
      facebook_url: 'https://facebook.com/clinicapremium',
      instagram_url: 'https://instagram.com/clinicapremium',
      delivery_info: 'no',
      price_range: '$1.200.000'
    },
    {
      title: 'Sushi All You Can Eat',
      address: 'Calle 93 # 12-54, Bogotá',
      business_hours: 'Todos los días: 12:00 PM - 10:00 PM',
      phone: '601 999 0000',
      cellphone: '+573112223333',
      email: 'reservas@sushiklicus.com',
      website_url: 'https://sushiklicus.com',
      facebook_url: 'https://facebook.com/sushiklicus',
      instagram_url: 'https://instagram.com/sushiklicus',
      delivery_info: 'si',
      price_range: '$65.000 p/p'
    }
  ];

  try {
    for (const ad of adsData) {
      await connection.execute(`
        UPDATE advertisements 
        SET 
          address = ?,
          business_hours = ?,
          phone = ?,
          cellphone = ?,
          email = ?,
          website_url = ?,
          facebook_url = ?,
          instagram_url = ?,
          delivery_info = ?,
          price_range = ?
        WHERE title = ?
      `, [
        ad.address,
        ad.business_hours,
        ad.phone,
        ad.cellphone,
        ad.email,
        ad.website_url,
        ad.facebook_url,
        ad.instagram_url,
        ad.delivery_info,
        ad.price_range,
        ad.title
      ]);
    }
    console.log('Seed Marketplace completed successfully');
  } catch (err) {
    console.error(err);
  } finally {
    await connection.end();
  }
}

seedMarketplace();
