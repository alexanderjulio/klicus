import * as db from './src/lib/db.js';
import bcrypt from 'bcryptjs';
import { v4 as uuidv4 } from 'uuid';

/**
 * KLICUS ADMIN MASTER TOOL
 * -----------------------
 * Manual de uso:
 * 1. Listar usuarios: node admin-setup.js list
 * 2. Promover admin: node admin-setup.js promote "Nombre de Negocio"
 * 3. Crear usuario Admin: node admin-setup.js create "Nombre" "email@ejemplo.com" "password123"
 */

const mode = process.argv[2];
const name = process.argv[3];
const email = process.argv[4];
const pass = process.argv[5];

async function main() {
  try {
    if (mode === 'list') {
      console.log('--- LISTA DE USUARIOS REGISTRADOS ---');
      const users = await db.query('SELECT full_name, business_name, role FROM profiles LIMIT 50');
      console.table(users);
      process.exit(0);
    }

    if (mode === 'promote') {
      if (!name) {
        console.error('❌ Error: Debes proporcionar el NOMBRE DE NEGOCIO o NOMBRE COMPLETO exacto.');
        console.log('Uso: node admin-setup.js promote "Mi Negocio"');
        process.exit(1);
      }

      console.log(`🚀 Elevando privilegios para: "${name}"...`);
      const result = await db.query(
        'UPDATE profiles SET role = "admin" WHERE business_name = ? OR full_name = ?',
        [name, name]
      );

      if (result.affectedRows > 0) {
        console.log(`✅ ¡ÉXITO! El usuario "${name}" ahora es ADMINISTRADOR.`);
        console.log('Ya puedes acceder a http://localhost:4000/dashboard/admin');
      } else {
        console.log('⚠️ ADVERTENCIA: No se encontró ningún usuario con ese nombre exacto.');
      }
      process.exit(0);
    }

    if (mode === 'create') {
      if (!name || !email || !pass) {
        console.error('❌ Error: Faltan datos (nombre, email, password)');
        console.log('Uso: node admin-setup.js create "Nombre" "email@ejemplo.com" "password123"');
        process.exit(1);
      }

      console.log(`🛠️  Creando usuario administrador: ${name}...`);
      const hashedPassword = await bcrypt.hash(pass, 12);
      const userId = uuidv4();

      await db.query(`
        INSERT INTO profiles (id, email, full_name, role, password_hash) 
        VALUES (?, ?, ?, 'admin', ?)
      `, [userId, email, name, hashedPassword]);

      console.log('✅ ¡ÉXITO! Usuario Administrador creado.');
      console.log(`Email: ${email}`);
      console.log('Ya puedes iniciar sesión y entrar a /dashboard/admin');
      process.exit(0);
    }

    // Default: Help
    console.log('🛠️  KLICUS ADMIN MASTER TOOL');
    console.log('---------------------------');
    console.log('Uso:');
    console.log('  node admin-setup.js list             - Lista todos los usuarios');
    console.log('  node admin-setup.js promote "Nombre"  - Convierte a un usuario en admin');
    console.log('  node admin-setup.js create "Nom" "mail" "pass" - Crea admin desde cero');
    process.exit(0);

  } catch (err) {
    console.error('❌ Error fatal:', err);
    process.exit(1);
  }
}

main();

