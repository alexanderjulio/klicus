import { query } from './src/lib/db.js';
import fs from 'fs';
import path from 'path';
import { v4 as uuidv4 } from 'uuid';

const ALEX_ID = '44bcac40-5c86-44d6-8cfd-44ae50574580';

async function importAds() {
  console.log('📦 Cargando datos de Firebase...');
  const dataPath = path.join(process.cwd(), 'config', 'klicus-4b8a7-export.json');
  const rawData = fs.readFileSync(dataPath, 'utf8');
  const firebaseData = JSON.parse(rawData);

  const ads = firebaseData.ADS;
  const keys = Object.keys(ads);
  console.log(`🔍 Encontrados ${keys.length} anunciantes.`);

  let importedCount = 0;

  for (const key of keys) {
    const ad = ads[key];
    
    // 1. Prepare Images
    const galleryItems = ad.GALLERY ? Object.values(ad.GALLERY) : [];
    const images = [ad.IMAGE_URL, ...galleryItems]
      .filter(img => img && typeof img === 'string' && img !== '0')
      .slice(0, 5);

    // 2. Prepare Description with Contact Info (Validated)
    let contactBlock = '\n\n--- 🌟 CONTACTO PREMIUM ---';
    if (ad.CEL && ad.CEL !== '0') contactBlock += `\n📲 WhatsApp: ${ad.CEL}`;
    if (ad.TEL && ad.TEL !== '0') contactBlock += `\n📞 Teléfono: ${ad.TEL}`;
    if (ad.FB && ad.FB !== '0') contactBlock += `\n📘 Facebook: ${ad.FB}`;
    if (ad.IG && ad.IG !== '0') contactBlock += `\n📸 Instagram: ${ad.IG}`;
    if (ad.WEB && ad.WEB !== '0') contactBlock += `\n🌐 Web: ${ad.WEB}`;
    
    const finalDescription = (ad.DESCRIPTION || 'Sin descripción.') + contactBlock;

    // 3. Mapping Category (Fallback to 1: Comercio)
    const categoryId = parseInt(ad.ID_CATEGORY) || 1;

    try {
      const adId = uuidv4();
      await query(`
        INSERT INTO advertisements 
        (id, owner_id, category_id, title, description, image_urls, priority_level, status, location)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
      `, [
        adId, 
        ALEX_ID, 
        categoryId, 
        ad.NAME || 'Anuncio sin nombre', 
        finalDescription, 
        JSON.stringify(images), 
        'diamond', 
        'active',
        ad.DIRE && ad.DIRE !== '0' ? ad.DIRE : 'Ocaña, Norte de Santander'
      ]);
      importedCount++;
      if (importedCount % 10 === 0) console.log(`🚀 Importados ${importedCount}/${keys.length}...`);
    } catch (error) {
      console.error(`❌ Error importando ${ad.NAME}:`, error.message);
    }
  }

  console.log(`\n🎉 ¡MIGRACIÓN COMPLETADA!`);
  console.log(`✅ ${importedCount} anuncios reales de Firebase cargados con éxito.`);
  console.log(`💎 Todos asignados a Alexander con Plan Premium.`);
  process.exit(0);
}

importAds().catch(err => {
  console.error('❌ Error fatal:', err);
  process.exit(1);
});
