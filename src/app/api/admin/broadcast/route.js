export const dynamic = 'force-dynamic';
import { getAuthenticatedUser } from '@/lib/auth-util';
import { broadcastPush, sendPushToUser } from '@/lib/push-notifications';
import { NextResponse } from 'next/server';

/**
 * Admin Broadcast/Targeted Push Notification
 */
export async function POST(req) {
  if (process.env.BUILD_MODE) return new Response(JSON.stringify({ build: true }), { status: 200, headers: { 'Content-Type': 'application/json' } });
  try {
    const user = await getAuthenticatedUser(req);
    
    // Check if user is Admin
    if (!user || user.role !== 'admin') {
      return NextResponse.json({ error: 'No autorizado - Solo Administradores' }, { status: 403 });
    }

    const { title, message, image, targetUserId } = await req.json();

    if (!title || !message) {
      return NextResponse.json({ error: 'Título y Mensaje son requeridos' }, { status: 400 });
    }

    let success = false;
    let responseMsg = '';

    if (targetUserId) {
      // Send to specific user
      success = await sendPushToUser(targetUserId, {
        title,
        body: message,
        image: image || null
      });
      responseMsg = success ? 'Notificación enviada al usuario con éxito' : 'Aviso: El usuario no tiene dispositivos registrados (FCM) vinculados';
    } else {
      // Broadcast to all
      success = await broadcastPush({
        title,
        body: message,
        image: image || null
      });
      responseMsg = success ? 'Notificación enviada a todos los usuarios' : 'Error: No hay ningún dispositivo registrado en la red para recibir el envío';
    }

    return NextResponse.json({ success, message: responseMsg });

  } catch (error) {
    console.error('Broadcast API Error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}

