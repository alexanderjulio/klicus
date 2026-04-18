import { query } from './src/lib/db.js';

async function migrate() {
  console.log('🚀 Iniciando migración de roles dinámicos...');
  
  try {
    // 1. Create roles table
    await query(`
      CREATE TABLE IF NOT EXISTS roles (
        id VARCHAR(50) PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        color VARCHAR(50) DEFAULT 'gray',
        description TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);

    // 2. Insert default roles
    await query(`
      INSERT INTO roles (id, name, color, description) VALUES 
      ('admin', 'Administrador', '#FFD700', 'Poder total sobre la plataforma'),
      ('anunciante', 'Anunciante', '#F59E0B', 'Usuarios profesionales con capacidad de publicar'),
      ('cliente', 'Cliente', '#94A3B8', 'Usuario estándar de la red')
      ON DUPLICATE KEY UPDATE name=VALUES(name)
    `);

    console.log('✅ Tabla de ROLES creada y poblada.');

    // 3. Ensure profiles.role is compatible (it's already VARCHAR/Enum, we'll keep it as is for now)
    
    console.log('🎉 Migración completada con éxito.');
    process.exit(0);
  } catch (error) {
    console.error('❌ Error en la migración:', error);
    process.exit(1);
  }
}

migrate();
