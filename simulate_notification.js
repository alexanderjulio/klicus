import { query } from './src/lib/db.js';

async function simulate() {
  console.log('📡 [SIMULACIÓN] Iniciando prueba de notificación...');
  try {
    // 1. Encontrar la conversación más reciente
    const convs = await query('SELECT id, seller_id, buyer_id, ad_id FROM chat_conversations ORDER BY last_message_at DESC LIMIT 1');
    
    if (convs.length === 0) {
      console.error('❌ No se encontró ninguna conversación para probar.');
      process.exit(1);
    }

    const conv = convs[0];
    console.log(`📂 Probando en Conversación: ${conv.id}`);
    console.log(`👤 Destinatario (Comprador/Invitado): ${conv.buyer_id}`);

    // 2. Insertar mensaje simulado del Vendedor al Invitado
    await query(`
      INSERT INTO chat_messages (conversation_id, sender_id, message_type, content)
      VALUES (?, ?, 'text', '🔔 ¡HOLA! Esta es una prueba de notificación automática de KLICUS.')
    `, [conv.id, conv.seller_id]);

    // 3. Crear la notificación persistente para el Badge
    await query(`
      INSERT INTO notifications (user_id, title, message, type, related_id)
      VALUES (?, 'Nuevo mensaje de prueba', '🔔 Tienes una nueva oportunidad de negocio.', 'chat_message', ?)
    `, [conv.buyer_id, conv.id]);

    console.log('✅ [SIMULACIÓN] Mensaje y Notificación inyectados con éxito.');
    console.log('📡 El punto amarillo debería aparecer en la App en los próximos 10 segundos.');
    process.exit(0);
  } catch (err) {
    console.error('❌ Error en simulación:', err.message);
    process.exit(1);
  }
}

simulate();
