import { query } from './db.js';

async function checkSchema() {
  try {
    const notifs = await query("DESCRIBE notifications", []);
    console.log("NOTIFICATIONS SCHEMA:");
    console.log(JSON.stringify(notifs, null, 2));

    process.exit(0);
  } catch (err) {
    console.error(err);
    process.exit(1);
  }
}

checkSchema();
