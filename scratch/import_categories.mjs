import fs from 'fs';
import { query } from '../src/lib/db.js';
import path from 'path';

/**
 * Script de Migración de Categorías - KLICUS
 * Este script purga la tabla de categorías actual e importa las categorías oficiales
 * desde el archivo JSON de Firebase, manteniendo los IDs originales.
 */

const JSON_PATH = './config/klicus-4b8a7-export.json';

// Mapeo inteligente de iconos (Lucide-react)
const ICON_MAP = {
  'COMERCIO': 'Store',
  'RESTAURANTE-BAR': 'Utensils',
  'ENTRETENIMIENTO': 'Gamepad2',
  'SALUD': 'HeartPulse',
  'BELLEZA': 'Sparkles',
  'SERVICIO': 'Wrench',
  'TRANSPORTE': 'Truck',
  'PROFESIONAL': 'Briefcase',
  'CONSTRUCCION': 'HardHat',
  'TURISMO': 'Map',
  'TECNOLOGIA': 'Cpu',
  'SUPERMERCADOS': 'ShoppingBasket',
  'DEPORTE': 'Trophy'
};

/**
 * Genera un slug amigable para URL
 */
function createSlug(text) {
  return text
    .toString()
    .toLowerCase()
    .replace(/\s+/g, '-')           // Reemplaza espacios con -
    .replace(/[^\w\-]+/g, '')       // Elimina caracteres no alfanuméricos (excepto -)
    .replace(/\-\-+/g, '-')         // Reemplaza múltiples - con uno solo
    .replace(/^-+/, '')             // Elimina - al inicio
    .replace(/-+$/, '');            // Elimina - al final
}

async function runMigration() {
  console.log('📂 Leyendo archivo Firebase JSON...');
  const rawData = fs.readFileSync(JSON_PATH, 'utf8');
  const data = JSON.parse(rawData);
  const firebaseCategories = data.CATEGORY_ADS;

  if (!firebaseCategories) {
    console.error('❌ No se encontró la colección CATEGORY_ADS en el JSON.');
    process.exit(1);
  }

  console.log('🧹 Purgando categorías actuales para sincronización total...');
  // Primero deshabilitamos checks de FK temporalmente si hay registros vinculados
  await query('SET FOREIGN_KEY_CHECKS = 0');
  await query('TRUNCATE categories');
  
  console.log('🚀 Iniciando importación de categorías...');
  
  const categoryKeys = Object.keys(firebaseCategories);
  let count = 0;

  for (const key of categoryKeys) {
    const cat = firebaseCategories[key];
    const name = cat.NAME;
    const id = cat.ID;
    const slug = createSlug(name);
    const icon = ICON_MAP[name] || 'Tag';
    const description = `Categoría de ${name.toLowerCase()} en KLICUS.`;

    try {
      await query(
        'INSERT INTO categories (id, name, slug, icon, description, active) VALUES (?, ?, ?, ?, ?, ?)',
        [id, name, slug, icon, description, 1]
      );
      console.log(`✅ Importada: ${name} (ID: ${id})`);
      count++;
    } catch (err) {
      console.error(`❌ Error importando ${name}:`, err.message);
    }
  }

  await query('SET FOREIGN_KEY_CHECKS = 1');
  console.log(`\n✨ Migración completada. ${count} categorías sincronizadas.`);
  process.exit(0);
}

runMigration().catch(err => {
  console.error('💥 Error fatal en la migración:', err);
  process.exit(1);
});
