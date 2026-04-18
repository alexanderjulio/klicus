const db = require('../src/lib/db');

async function check() {
  try {
    const tables = await db.query("SHOW TABLES");
    console.log("TABLES:", tables);

    const adsSchema = await db.query("DESCRIBE advertisements");
    console.log("ADS SCHEMA:", adsSchema);

    const billingsSchema = await db.query("DESCRIBE billings");
    console.log("BILLINGS SCHEMA:", billingsSchema);
  } catch (err) {
    console.error("DEBUG ERROR:", err.message);
  }
  process.exit(0);
}

check();
