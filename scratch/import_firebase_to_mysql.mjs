import { query, pool } from '../src/lib/db.js';
import fs from 'fs/promises';
import path from 'path';

async function runMigration() {
  console.log('🚀 [MIGRATION] Starting Firebase to MySQL import...');

  try {
    // 1. Load JSON file
    const jsonPath = path.join(process.cwd(), 'config', 'klicus-4b8a7-export.json');
    const data = JSON.parse(await fs.readFile(jsonPath, 'utf8'));
    const ads = data.ADS;
    const adKeys = Object.keys(ads);
    
    console.log(`📦 Found ${adKeys.length} ads to process.`);

    const ownerId = 'import_system_user';
    const defaultCategoryId = 9; // 'Tecnología' or fallback

    // 2. Get existing categories for mapping
    const existingCategories = await query('SELECT id FROM categories');
    const validCategoryIds = new Set(existingCategories.map(c => c.id));

    let importedCount = 0;
    let skippedCount = 0;

    for (const key of adKeys) {
      const fbAd = ads[key];
      const adId = key; 
      
      const categoryId = validCategoryIds.has(Number(fbAd.ID_CATEGORY)) 
        ? Number(fbAd.ID_CATEGORY) 
        : defaultCategoryId;

      const images = [];
      if (fbAd.IMAGE_URL && typeof fbAd.IMAGE_URL === 'string') images.push(fbAd.IMAGE_URL);
      if (fbAd.GALLERY && typeof fbAd.GALLERY === 'object') {
        Object.values(fbAd.GALLERY).forEach(url => {
          if (url && typeof url === 'string' && !images.includes(url)) images.push(url);
        });
      }

      const title = fbAd.NAME || fbAd.PRO || 'Anuncio Importado';
      const desc = fbAd.DESCRIPTION || '';

      const cellphone = fbAd.CEL && fbAd.CEL !== 0 ? String(fbAd.CEL) : null;
      const phone = fbAd.TEL && fbAd.TEL !== 0 ? String(fbAd.TEL) : null;
      const email = fbAd.EMAIL && fbAd.EMAIL !== 0 ? String(fbAd.EMAIL) : null;
      const website_url = fbAd.WEB && fbAd.WEB !== 0 ? String(fbAd.WEB) : null;
      
      // LOGGING DEPURACIÓN PARA REDES SOCIALES
      const facebook_url = fbAd.FB && fbAd.FB !== 0 && fbAd.FB !== "0" ? String(fbAd.FB) : null;
      const instagram_url = fbAd.IG && fbAd.IG !== 0 && fbAd.IG !== "0" ? String(fbAd.IG) : null;
      
      if (key === 'ADS1') {
        console.log(`DEBUG [ADS1]: FB=${fbAd.FB}, Mapped=${facebook_url}`);
      }

      const business_hours = fbAd.TIME && fbAd.TIME !== 0 ? String(fbAd.TIME) : null;
      const delivery_info = fbAd.DOMICILIO && fbAd.DOMICILIO !== 0 ? String(fbAd.DOMICILIO) : null;

      try {
        await query(`
          INSERT INTO advertisements 
          (id, owner_id, category_id, title, description, image_urls, location, status, priority_level, 
           cellphone, phone, email, website_url, facebook_url, instagram_url, business_hours, delivery_info) 
          VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
          ON DUPLICATE KEY UPDATE 
          title = VALUES(title), 
          description = VALUES(description), 
          image_urls = VALUES(image_urls),
          cellphone = VALUES(cellphone),
          phone = VALUES(phone),
          email = VALUES(email),
          website_url = VALUES(website_url),
          facebook_url = VALUES(facebook_url),
          instagram_url = VALUES(instagram_url),
          business_hours = VALUES(business_hours),
          delivery_info = VALUES(delivery_info)
        `, [
          adId,
          ownerId,
          categoryId,
          title.substring(0, 255),
          desc,
          JSON.stringify(images),
          fbAd.DIRE === 0 || !fbAd.DIRE ? 'Sin especificar' : String(fbAd.DIRE).substring(0, 255),
          'active',
          'basic',
          cellphone,
          phone,
          email,
          website_url,
          facebook_url,
          instagram_url,
          business_hours,
          delivery_info
        ]);
        importedCount++;
      } catch (err) {
        console.error(`❌ Failed to import ${adId}:`, err.message);
        skippedCount++;
      }
    }

    console.log(`\n🎉 Migration Complete!`);
    console.log(`✅ Success: ${importedCount}`);
    console.log(`⚠️ Skipped/Errors: ${skippedCount}`);

  } catch (error) {
    console.error('🔥 CRITICAL ERROR during migration:', error);
  } finally {
    await pool.end();
  }
}

runMigration();
