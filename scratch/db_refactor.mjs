import mysql from 'mysql2/promise';

async function setup() {
  const c = await mysql.createConnection({
    host: '127.0.0.1',
    user: 'root',
    password: '',
    database: 'klicus_db'
  });

  console.log('--- Database Refactor Initiation ---');

  // 1. Notifications Table
  await c.execute(`
    CREATE TABLE IF NOT EXISTS notifications (
      id INT AUTO_INCREMENT PRIMARY KEY,
      user_id VARCHAR(255) NOT NULL,
      title VARCHAR(255) NOT NULL,
      message TEXT NOT NULL,
      type ENUM('info', 'success', 'warning', 'error') DEFAULT 'info',
      is_read BOOLEAN DEFAULT FALSE,
      link VARCHAR(255),
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      INDEX idx_user_read (user_id, is_read)
    )
  `);
  console.log('✓ Notifications table created.');

  // 2. Metrics Table (Event Log Style)
  await c.execute("DROP TABLE IF EXISTS metrics");
  await c.execute(`
    CREATE TABLE metrics (
      id INT AUTO_INCREMENT PRIMARY KEY,
      ad_id VARCHAR(255) NOT NULL,
      event_type ENUM('view', 'click') NOT NULL,
      device_type ENUM('mobile', 'desktop', 'pwa') DEFAULT 'desktop',
      ip_hash VARCHAR(64),
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      INDEX idx_ad_event_date (ad_id, event_type, created_at)
    )
  `);
  console.log('✓ Metrics table refactored to Event Log.');

  console.log('--- Database Refactor Successfully Completed ---');
  await c.end();
}

setup().catch(console.error);
