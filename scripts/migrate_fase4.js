import mysql from 'mysql2/promise';
import dotenv from 'dotenv';
dotenv.config({ path: '.env.local' });

async function migrate() {
  const connection = await mysql.createConnection({
    host: process.env.MYSQL_HOST || '127.0.0.1',
    user: process.env.MYSQL_USER || 'root',
    password: process.env.MYSQL_PASSWORD || '',
    database: process.env.MYSQL_DATABASE || 'klicus_db',
  });

  console.log('--- Migración Fase 4: Refuerzo de Perfiles ---');

  try {
    // 1. Add phone column to profiles
    const [columns] = await connection.query('SHOW COLUMNS FROM profiles LIKE "phone"');
    if (columns.length === 0) {
      console.log('Añadiendo columna "phone" a la tabla profiles...');
      await connection.query('ALTER TABLE profiles ADD COLUMN phone VARCHAR(20) AFTER business_name');
    } else {
      console.log('La columna "phone" ya existe.');
    }

    console.log('✅ Migración completada con éxito.');
  } catch (error) {
    console.error('❌ Error en la migración:', error);
  } finally {
    await connection.end();
  }
}

migrate();
