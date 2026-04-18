const { query } = require('../src/lib/db');

async function testAnalytics() {
  const adId = 1; // Assuming there is an ad with ID 1
  try {
    console.log('Testing Time Series...');
    const timeSeries = await query(`
      SELECT 
        DATE_FORMAT(created_at, '%d/%m') as date,
        SUM(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END) as views,
        SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) as clicks,
        SUM(CASE WHEN event_type = 'contact' THEN 1 ELSE 0 END) as contacts
      FROM metrics
      WHERE ad_id = ? AND created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
      GROUP BY DATE_FORMAT(created_at, '%d/%m')
      ORDER BY MIN(created_at) ASC
    `, [adId]);
    console.log('Time Series Result:', timeSeries.length);

    console.log('Testing Devices...');
    const devices = await query(`
      SELECT 
        device_type as name,
        COUNT(*) as value
      FROM metrics
      WHERE ad_id = ?
      GROUP BY device_type
    `, [adId]);
    console.log('Devices Result:', devices.length);

    console.log('Testing Totals...');
    const totals = await query(`
      SELECT 
        SUM(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END) as totalViews,
        SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) as totalClicks,
        SUM(CASE WHEN event_type = 'contact' THEN 1 ELSE 0 END) as totalContacts
      FROM metrics
      WHERE ad_id = ?
    `, [adId]);
    console.log('Totals Result:', totals[0]);

    console.log('TEST SUCCESSFUL');
  } catch (err) {
    console.error('TEST FAILED:', err.message);
  }
}

testAnalytics();
