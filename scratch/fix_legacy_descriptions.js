require('dotenv').config({ path: '.env.local' });
const { query } = require('../src/lib/db');

/**
 * KLICUS LEGACY DATA MIGRATOR
 * Extracts contact info from plain-text descriptions and populates dedicated SQL columns.
 */

async function migrate() {
  console.log('🚀 Iniciando migración de datos de contacto...');
  
  const ads = await query('SELECT id, title, description FROM advertisements WHERE status = "active"');
  console.log(`🔍 Analizando ${ads.length} anuncios...`);

  let updatedCount = 0;

  for (const ad of ads) {
    const desc = ad.description;
    if (!desc) continue;

    const updates = {};

    // 1. Extract WhatsApp / Cellphone
    const waMatch = desc.match(/WhatsApp:\s*(\+?\d+)/i) || desc.match(/📲 WhatsApp:\s*(\+?\d+)/i);
    if (waMatch) updates.cellphone = waMatch[1].trim();

    // 2. Extract Phone
    const phoneMatch = desc.match(/Teléfono:\s*(\+?\d+)/i) || desc.match(/📞 Teléfono:\s*(\+?\d+)/i);
    if (phoneMatch) updates.phone = phoneMatch[1].trim();

    // 3. Extract Facebook
    const fbMatch = desc.match(/Facebook:\s*(https?:\/\/[^\s\n]+)/i) || desc.match(/📘 Facebook:\s*(https?:\/\/[^\s\n]+)/i);
    if (fbMatch) updates.facebook_url = fbMatch[1].trim();

    // 4. Extract Web
    const webMatch = desc.match(/Web:\s*(https?:\/\/[^\s\n]+)/i) || desc.match(/🌐 Web:\s*(https?:\/\/[^\s\n]+)/i);
    if (webMatch) updates.website_url = webMatch[1].trim();

    // 5. Detect Delivery (Domicilios)
    if (desc.includes('Domicilios') || desc.includes('domicilios') || desc.includes('🛵')) {
        updates.delivery_info = 'Disponible';
    }

    // Apply updates if any matches found
    const fields = Object.keys(updates);
    if (fields.length > 0) {
      const setClause = fields.map(f => `${f} = ?`).join(', ');
      const values = [...Object.values(updates), ad.id];
      
      await query(`UPDATE advertisements SET ${setClause} WHERE id = ?`, values);
      updatedCount++;
      console.log(`✅ [${ad.title}] Datos extraídos: ${fields.join(', ')}`);
    }
  }

  console.log(`\n✨ Migración finalizada. Se actualizaron ${updatedCount} anuncios.`);
  process.exit(0);
}

migrate().catch(err => {
  console.error('❌ Error en la migración:', err);
  process.exit(1);
});
