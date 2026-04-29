export const dynamic = 'force-dynamic';
/**
 * KLICUS Ad Creation API
 * Handles the submission of new advertisements, including multi-image processing to WebP.
 */

import { apiResponse, ApiError } from '@/lib/api-utils';
import { query } from '@/lib/db';
import { processAdImage } from '@/lib/image-service';
import { getUniversalSession } from '@/lib/auth-helper';
import { getPlanById } from '@/config/plans';
import crypto from 'crypto';

/**
 * Handles multipart/form-data POST requests to create a new advertisement.
 */
export async function POST(req) {
  if (process.env.BUILD_MODE) return new Response(JSON.stringify({ build: true }), { status: 200, headers: { 'Content-Type': 'application/json' } });
  try {
    // 1. Session Verification (Universal)
    const user = await getUniversalSession(req);
    if (!user) return ApiError.unauthorized();

    // 2. Data Extraction
    const formData = await req.formData();
    const title = formData.get('title');
    const description = formData.get('description');
    const categoryId = formData.get('categoryId');
    const requestedPriority = formData.get('priority') || 'basic';
    const location = formData.get('location');
    const address = formData.get('address');
    const businessHours = formData.get('businessHours');
    const phone = formData.get('phone');
    const cellphone = formData.get('cellphone');
    const email = formData.get('email');
    const websiteUrl = formData.get('websiteUrl');
    const facebookUrl = formData.get('facebookUrl');
    const instagramUrl = formData.get('instagramUrl');
    const deliveryInfo = formData.get('deliveryInfo');
    const priceRange = formData.get('priceRange') || '';
    const isOffer = formData.get('isOffer') === 'true';
    const files = formData.getAll('images'); // Multiple image files

    // 2.5 Dynamic Validation
    const LIMITS = { basic: 1, pro: 3, diamond: 5 };
    const maxAllowedImages = LIMITS[requestedPriority] || 1;

    if (files.length > maxAllowedImages) {
      return ApiError.badRequest(`El plan ${requestedPriority.toUpperCase()} solo permite ${maxAllowedImages} foto(s). Has enviado ${files.length}.`);
    }

    // 2.6 Expiration from plans config
    const plan = getPlanById(requestedPriority);
    const durationDays = plan.duration || 365;
    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + durationDays);

    const imageUrls = [];

    // 3. Image Processing
    for (const file of files.slice(0, maxAllowedImages)) {
      if (file.size > 0) {
        const buffer = Buffer.from(await file.arrayBuffer());
        const result = await processAdImage(buffer, file.name || 'image.webp');
        imageUrls.push(result.url);
      }
    }


    const adId = crypto.randomUUID();

    // 4. MySQL Persistence
    await query(`
      INSERT INTO advertisements (
        id, owner_id, category_id, title, description, image_urls, priority_level, 
        status, location, address, business_hours, phone, cellphone, email, 
        website_url, facebook_url, instagram_url, delivery_info, price_range, is_offer,
        expires_at
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `, [
      adId, 
      user.id, 
      categoryId, 
      title, 
      description, 
      JSON.stringify(imageUrls), 
      requestedPriority,
      'pending', 
      location,
      address,
      businessHours,
      phone,
      cellphone,
      email,
      websiteUrl,
      facebookUrl,
      instagramUrl,
      deliveryInfo,
      priceRange,
      isOffer,
      expiresAt
    ]);


    // Notify all admins about the new pending ad
    try {
      const { createNotification, NotificationTemplates } = await import('@/lib/notifications');
      const admins = await query('SELECT id FROM profiles WHERE role = "admin"');
      const adminTemplate = NotificationTemplates.ADMIN_NEW_AD(title, user.name || user.email || 'Usuario');
      for (const admin of admins) {
        await createNotification({ userId: admin.id, ...adminTemplate, link: '/admin' });
      }
    } catch (notifErr) {
      console.error('[NOTIF] Error notificando admin sobre nueva pauta:', notifErr.message);
    }

    return apiResponse({
      data: {
        success: true,
        adId,
        message: 'Anuncio creado. Pendiente de aprobación por el administrador.'
      }
    });

  } catch (error) {
    console.error('Error creando pauta:', error);
    return ApiError.serverError();
  }
}

