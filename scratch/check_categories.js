const { query } = require('../src/lib/db');

async function checkCategories() {
  try {
    const categories = await query('SELECT name, slug FROM categories');
    console.log(JSON.stringify(categories, null, 2));
    process.exit(0);
  } catch (err) {
    console.error(err);
    process.exit(1);
  }
}

checkCategories();
