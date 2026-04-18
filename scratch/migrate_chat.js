import { query } from '../src/lib/db.js';

async function migrate() {
  try {
    console.log('🔄 Iniciando migración de Chat (Luxury Link)...');
    
    // 1. Tabla de Conversaciones
    await query(`
      CREATE TABLE IF NOT EXISTS chat_conversations (
        id CHAR(36) PRIMARY KEY,
        ad_id CHAR(36) NOT NULL,
        buyer_id CHAR(36) NOT NULL,
        seller_id CHAR(36) NOT NULL,
        last_message TEXT,
        last_message_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        UNIQUE KEY unique_chat (ad_id, buyer_id, seller_id)
      )
    `);
    
    // 2. Tabla de Mensajes
    await query(`
      CREATE TABLE IF NOT EXISTS chat_messages (
        id INT AUTO_INCREMENT PRIMARY KEY,
        conversation_id CHAR(36) NOT NULL,
        sender_id CHAR(36) NOT NULL,
        message_type ENUM('text', 'image') DEFAULT 'text',
        content TEXT NOT NULL,
        is_read BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        INDEX idx_conv (conversation_id)
      )
    `);
    
    console.log('✅ Base de Datos actualizada para Luxury Link (Chat).');
    process.exit(0);
  } catch (err) {
    console.error('❌ Error en migración de chat:', err);
    process.exit(1);
  }
}

migrate();
