export const dynamic = 'force-dynamic';
import { query } from '@/lib/db';
import { NextResponse } from 'next/server';
import { getUniversalSession } from '@/lib/auth-helper';
import crypto from 'crypto';
import { sendPushToUser } from '@/lib/push-notifications';

/**
 * Chat Conversations API
 * GET: List active conversations
 * POST: Start new conversation from an ad
 */

export async function GET(req) {
  try {
    const user = await getUniversalSession(req);
    if (!user) return NextResponse.json({ error: 'No autorizado' }, { status: 401 });

    // List conversations where user is buyer or seller
    const conversations = await query(`
      SELECT 
        c.*, 
        a.title as ad_title, 
        a.image_urls as ad_images,
        p_seller.full_name as seller_name,
        p_seller.avatar_url as seller_avatar,
        COALESCE(p_buyer.full_name, gi_buyer.name, 'Invitado Klicus') as buyer_name,
        p_buyer.avatar_url as buyer_avatar,
        (SELECT COUNT(*) FROM chat_messages m 
         WHERE m.conversation_id = c.id 
         AND m.is_read = 0 
         AND m.sender_id != ?) as unread_count
      FROM chat_conversations c
      JOIN advertisements a ON c.ad_id = a.id
      JOIN profiles p_seller ON c.seller_id = p_seller.id
      LEFT JOIN profiles p_buyer ON c.buyer_id = p_buyer.id
      LEFT JOIN guest_identities gi_buyer ON c.buyer_id = gi_buyer.id
      WHERE (c.buyer_id = ? OR c.seller_id = ?)
      ORDER BY c.last_message_at DESC
    `, [user.id, user.id, user.id]);

    return NextResponse.json({ success: true, conversations });
  } catch (error) {
    console.error('Chat List API Error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}

export async function POST(req) {
  try {
    const user = await getUniversalSession(req);
    if (!user) return NextResponse.json({ error: 'No autorizado' }, { status: 401 });

    const { adId } = await req.json();
    if (!adId) return NextResponse.json({ error: 'Faltan parámetros' }, { status: 400 });

    // 1. Verify ad exists and is active
    const ads = await query('SELECT owner_id, status FROM advertisements WHERE id = ?', [adId]);
    if (ads.length === 0) return NextResponse.json({ error: 'Anuncio no encontrado' }, { status: 404 });
    
    // As per user request: deactivate if ad expired/inactive
    // However, to START one, it must be active (or pending)
    if (ads[0].status === 'expired' || ads[0].status === 'rejected') {
      return NextResponse.json({ error: 'Este anuncio ya no acepta consultas' }, { status: 400 });
    }

    const sellerId = ads[0].owner_id;
    if (sellerId === user.id) {
      return NextResponse.json({ error: 'No puedes iniciar un chat contigo mismo' }, { status: 400 });
    }

    const buyerId = user.id;

    // 2. Check if conversation already exists
    const existing = await query(`
      SELECT id FROM chat_conversations 
      WHERE ad_id = ? AND buyer_id = ? AND seller_id = ?
    `, [adId, buyerId, sellerId]);

    if (existing.length > 0) {
      return NextResponse.json({ success: true, conversationId: existing[0].id });
    }

    // 3. Create new conversation
    const conversationId = crypto.randomUUID();
    await query(`
      INSERT INTO chat_conversations (id, ad_id, buyer_id, seller_id, last_message)
      VALUES (?, ?, ?, ?, 'Iniciando conversación...')
    `, [conversationId, adId, buyerId, sellerId]);

    // 4. Send Push Notification to Seller
    try {
      await sendPushToUser(sellerId, {
        title: '¡Nuevo mensaje en Klicus! 💎',
        body: `${user.name} está interesado en tu anuncio: ${ads[0].title || 'Producto'}`,
        data: {
          type: 'chat_start',
          conversationId: conversationId,
          adId: adId
        }
      });
    } catch (pushError) {
      console.error('FCM Notification Error (Start):', pushError);
    }

    return NextResponse.json({ success: true, conversationId });

  } catch (error) {
    console.error('Chat Start API Error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}

