import { query } from '@/lib/db';
import { NextResponse } from 'next/server';
import { getUniversalSession } from '@/lib/auth-helper';
import { processAdImage } from '@/lib/image-service';
import { sendPushToUser } from '@/lib/push-notifications';

export const dynamic = 'force-dynamic';

/**
 * Chat Messages API
 * GET: Fetch history for a conversation
 * POST: Send a message
 */

export async function GET(req, { params }) {
  if (process.env.BUILD_MODE) return new Response(JSON.stringify({ build: true }), { status: 200, headers: { 'Content-Type': 'application/json' } });
  const { conversationId } = await params;
  try {
    const user = await getUniversalSession(req);
    if (!user) return NextResponse.json({ error: 'No autorizado' }, { status: 401 });

    // 1. Verify user is part of this conversation
    const conv = await query(`
      SELECT id, buyer_id, seller_id FROM chat_conversations WHERE id = ?
    `, [conversationId]);

    if (conv.length === 0) return NextResponse.json({ error: 'Chat no encontrado' }, { status: 404 });
    if (conv[0].buyer_id !== user.id && conv[0].seller_id !== user.id) {
      return NextResponse.json({ error: 'No tienes acceso a este chat' }, { status: 403 });
    }

    // 2. Fetch messages
    const messages = await query(`
      SELECT * FROM chat_messages 
      WHERE conversation_id = ? 
      ORDER BY created_at ASC
    `, [conversationId]);

    // 3. Mark as read for the receiver
    await query(`
      UPDATE chat_messages 
      SET is_read = TRUE 
      WHERE conversation_id = ? AND sender_id != ?
    `, [conversationId, user.id]);

    return NextResponse.json({ success: true, messages });

  } catch (error) {
    console.error('Chat Messages GET Error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}

export async function POST(req, { params }) {
  if (process.env.BUILD_MODE) return new Response(JSON.stringify({ build: true }), { status: 200, headers: { 'Content-Type': 'application/json' } });
  const { conversationId } = await params;
  try {
    const user = await getUniversalSession(req);
    if (!user) return NextResponse.json({ error: 'No autorizado' }, { status: 401 });

    // Support both JSON (text) and Multipart (images)
    const contentType = req.headers.get('content-type') || '';
    let textContent = '';
    let imageUrl = '';
    let messageType = 'text';

    if (contentType.includes('multipart/form-data')) {
      const formData = await req.formData();
      textContent = formData.get('text') || '';
      const imageFile = formData.get('image');
      
      if (imageFile && imageFile.size > 0) {
        const buffer = Buffer.from(await imageFile.arrayBuffer());
        imageUrl = await processAdImage(buffer, imageFile.name || 'chat_image.webp');
        messageType = 'image';
      }
    } else {
      const body = await req.json();
      textContent = body.text;
    }

    if (!textContent && !imageUrl) {
      return NextResponse.json({ error: 'Mensaje vacío' }, { status: 400 });
    }

    // 1. Verify conversation access
    const conv = await query(`
      SELECT buyer_id, seller_id FROM chat_conversations WHERE id = ?
    `, [conversationId]);

    if (conv.length === 0) return NextResponse.json({ error: 'Chat no encontrado' }, { status: 404 });
    if (conv[0].buyer_id !== user.id && conv[0].seller_id !== user.id) {
      return NextResponse.json({ error: 'No tienes acceso a este chat' }, { status: 403 });
    }

    const content = messageType === 'image' ? (imageUrl || '') : textContent;

    // 2. Insert message
    await query(`
      INSERT INTO chat_messages (conversation_id, sender_id, message_type, content)
      VALUES (?, ?, ?, ?)
    `, [conversationId, user.id, messageType, content]);

    // 3. Update conversation last message preview
    const preview = messageType === 'image' ? '📸 Foto' : (content.length > 50 ? content.substring(0, 50) + '...' : content);
    await query(`
      UPDATE chat_conversations 
      SET last_message = ?, last_message_at = CURRENT_TIMESTAMP 
      WHERE id = ?
    `, [preview, conversationId]);

    // 4. Send Push Notification to Recipient
    const recipientId = user.id === conv[0].buyer_id ? conv[0].seller_id : conv[0].buyer_id;
    
    // Fetch guest name if sender is a guest
    let senderName = user.name;
    if (user.is_guest) {
      const guests = await query('SELECT name FROM guest_identities WHERE id = ?', [user.id]);
      if (guests.length > 0) senderName = guests[0].name;
    }

    try {
      await sendPushToUser(recipientId, {
        title: `Nuevo mensaje de ${senderName}`,
        body: messageType === 'image' ? '📸 Te ha enviado una foto' : textContent,
        data: {
          type: 'chat_message',
          conversationId: conversationId,
          senderName: senderName
        }
      });
    } catch (pushError) {
      console.error('FCM Notification Error (Message):', pushError);
    }

    // 5. Insert persistent notification into DB for in-app bell/badges
    try {
      await query(`
        INSERT INTO notifications (user_id, title, message, type, related_id)
        VALUES (?, ?, ?, ?, ?)
      `, [
        recipientId,
        `Nuevo mensaje de ${senderName}`,
        messageType === 'image' ? '📸 Te ha enviado una foto' : textContent,
        'chat_message',
        conversationId
      ]);
    } catch (dbNotifError) {
      console.error('DB Notification Error (Message):', dbNotifError);
    }

    return NextResponse.json({ success: true, message: { content, messageType, sender_id: user.id } });

  } catch (error) {
    console.error('Chat Messages POST Error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}
