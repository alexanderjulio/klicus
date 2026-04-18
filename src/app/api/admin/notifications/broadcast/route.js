import { query } from '@/lib/db';
import { NextResponse } from 'next/server';
import { getUniversalSession } from '@/lib/auth-helper';
import admin from '@/lib/firebase-admin';

/**
 * POST: Admin Broadcast Notification
 * Body: { title, body, targetRole, adId }
 */
export async function POST(req) {
  try {
    const adminUser = await getUniversalSession(req);
    if (!adminUser || adminUser.role !== 'admin') {
      return NextResponse.json({ error: 'No autorizado' }, { status: 403 });
    }

    const { title, body, targetRole, adId } = await req.json();

    if (!title || !body) {
      return NextResponse.json({ error: 'Título y Mensaje requeridos' }, { status: 400 });
    }

    // 1. Fetch Tokens with Filter
    let sql = 'SELECT token FROM user_tokens ut ';
    const params = [];

    if (targetRole && targetRole !== 'all') {
      sql += 'INNER JOIN profiles p ON ut.user_id = p.id WHERE p.role = ?';
      params.push(targetRole);
    }

    const tokenRows = await query(sql, params);
    const tokens = tokenRows.map(r => r.token);

    if (tokens.length === 0) {
      return NextResponse.json({ success: true, message: 'No hay dispositivos registrados para este grupo' });
    }

    // 2. Prepare Payload
    const message = {
      notification: {
        title: title,
        body: body,
      },
      data: {
        adId: adId || '',
        click_action: 'FLUTTER_NOTIFICATION_CLICK', // Legacy but sometimes useful
      },
      tokens: tokens, // Multicast
    };

    // 3. Send via Firebase Admin
    if (admin.apps.length > 0) {
      const response = await admin.messaging().sendEachForMulticast(message);
      
      return NextResponse.json({ 
        success: true, 
        message: `Enviado con éxito a ${response.successCount} dispositivos`,
        failureCount: response.failureCount
      });
    } else {
      return NextResponse.json({ 
        error: 'El servicio de notificaciones no está configurado (SDK no inicializado)' 
      }, { status: 503 });
    }

  } catch (error) {
    console.error('Broadcast API Error:', error);
    return NextResponse.json({ error: 'Error al enviar notificaciones' }, { status: 500 });
  }
}
