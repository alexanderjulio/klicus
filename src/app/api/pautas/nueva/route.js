/**
 * KLICUS Ad Creation API
 * Handles the submission of new advertisements, including multi-image processing to WebP.
 */

import { NextResponse } from 'next/server';
import { query } from '@/lib/db';
import { processAdImage } from '@/lib/image-service';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/lib/auth';
import crypto from 'crypto';

/**
 * Handles multipart/form-data POST requests to create a new advertisement.
 */
export async function POST(req) {
  try {
    // 1. Session Verification
    const session = await getServerSession(authOptions);
    if (!session) return NextResponse.json({ error: 'No autorizado' }, { status: 401 });

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

    // 2.5 Dynamic Validation: Use the requested priority limits
    // Limits mapping derived from plans.js
    const LIMITS = {
      basic: 1,
      pro: 3,
      diamond: 5
    };
    const maxAllowedImages = LIMITS[requestedPriority] || 1;

    if (files.length > maxAllowedImages) {
      return NextResponse.json({ 
        error: `El plan ${requestedPriority.toUpperCase()} solo permite ${maxAllowedImages} foto(s). Has enviado ${files.length}.` 
      }, { status: 400 });
    }

    // 2.6 Dynamic Expiration Logic from DB
    const planData = await query('SELECT duration_days FROM plans WHERE plan_name = ?', [requestedPriority]);
    const durationDays = planData[0]?.duration_days || 30; // Fallback to 30

    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + durationDays);

    const imageUrls = [];

    // 3. Image Processing (Sharp + WebP)
    for (const file of files.slice(0, maxAllowedImages)) {
      if (file.size > 0) {
        const buffer = Buffer.from(await file.arrayBuffer());
        const url = await processAdImage(buffer, file.name);
        imageUrls.push(url);
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
      session.user.id, 
      categoryId, 
      title, 
      description, 
      JSON.stringify(imageUrls), 
      requestedPriority, // Correctly save the requested priority!
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


    return NextResponse.json({ 
      success: true, 
      adId,
      message: 'Anuncio creado. Pendiente de aprobación por el administrador.' 
    });

  } catch (error) {
    console.error('Error creando pauta:', error);
    return NextResponse.json({ error: 'Error interno del servidor' }, { status: 500 });
  }
}
