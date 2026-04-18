const { query } = require('../src/lib/db');

async function checkTables() {
  try {
    const tables = await query('SHOW TABLES', []);
    console.log('Tables:', tables);
  } catch (err) {
    console.error('Error listing tables:', err.message);
  } finally {
    process.exit(0);
  }
}

checkTables();
