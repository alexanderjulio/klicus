import { query } from './db.js';
import { sendPushToUser } from './push-notifications.js';

/**
 * KLICUS Internal Notification Service
 * Helper function to create persistent notifications for users.
 */
export async function createNotification({ userId, title, message, type = 'info', link = null }) {
  try {
    if (!userId || !title || !message) {
      console.error('Missing required fields for notification');
      return false;
    }

    // 1. Save to Database (Internal History)
    await query(`
      INSERT INTO notifications (user_id, title, message, type, link)
      VALUES (?, ?, ?, ?, ?)
    `, [userId, title, message, type, link]);

    // 2. Trigger Real-Time Push Notification
    // We do this in the background (no await) to not block the main flow
    sendPushToUser(userId, {
      title: title,
      body: message,
      data: { type, link }
    }).catch(err => console.error('[FCM-SILENT-ERROR]', err));

    return true;
  } catch (error) {
    console.error('Error creating notification:', error);
    return false;
  }
}

/**
 * Common notification templates
 */
export const NotificationTemplates = {
  AD_APPROVED: (adTitle) => ({
    title: '🌟 ¡Pauta Aprobada!',
    message: `Tu anuncio "${adTitle}" ha pasado la revisión y ya es visible en KLICUS.`,
    type: 'success'
  }),
  AD_PAUSED: (adTitle) => ({
    title: '⚠️ Pauta Pausada',
    message: `Tu anuncio "${adTitle}" ha sido pausado. Revisa tus correos para más detalles.`,
    type: 'warning'
  }),
  AD_REJECTED: (adTitle, reason) => ({
    title: '❌ Pauta Rechazada',
    message: `Tu anuncio "${adTitle}" requiere correcciones: ${reason}`,
    type: 'error'
  }),
  PAYMENT_SUCCESS: (adTitle) => ({
    title: '💎 ¡Pago Confirmado!',
    message: `Hemos recibido el pago para "${adTitle}". Tu pauta ya está en la cola de revisión prioritaria.`,
    type: 'success'
  }),
  ADMIN_PAYMENT_SUCCESS: (adTitle, amount) => ({
    title: '💰 ¡Nuevo Pago Recibido!',
    message: `El comercio "${adTitle}" ha completado un pago de $${amount.toLocaleString()}.`,
    type: 'success'
  })
};
