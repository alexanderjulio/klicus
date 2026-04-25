const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');
require('dotenv').config({ path: '.env.local' });

async function setup() {
  const connection = await mysql.createConnection({
    host: process.env.MYSQL_HOST || 'localhost',
    user: process.env.MYSQL_USER || 'root',
    password: process.env.MYSQL_PASSWORD || '',
    multipleStatements: true
  });

  console.log('Conectado a MySQL...');

  const schemaPath = path.join(process.cwd(), 'schema.sql');
  const schema = fs.readFileSync(schemaPath, 'utf8');

  try {
    console.log('Creando base de datos si no existe...');
    await connection.query('CREATE DATABASE IF NOT EXISTS klicus_db');
    await connection.query('USE klicus_db');
    console.log('Ejecutando schema.sql...');
    await connection.query(schema);
    console.log('Base de datos Klicus inicializada con éxito.');
  } catch (err) {
    console.error('Error inicializando base de datos:', err.message);
  } finally {
    await connection.end();
  }
}

setup();
