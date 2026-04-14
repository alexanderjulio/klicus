/**
 * KLICUS Ad Creation API
 * Handles the submission of new advertisements, including multi-image processing to WebP.
 */

import { NextResponse } from 'next/server';
import { query } from '@/lib/db';
import { processAdImage } from '@/lib/image-service';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/app/api/auth/[...nextauth]/route';
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
    const priority = formData.get('priority') || 'basic';
    const location = formData.get('location');
    const priceRange = formData.get('priceRange');
    const files = formData.getAll('images'); // Multiple image files

    const imageUrls = [];

    // 3. Image Processing (Sharp + WebP)
    // Process up to 5 images sequentially to optimize performance and battery on local servers
    for (const file of files.slice(0, 5)) {
      if (file.size > 0) {
        const buffer = Buffer.from(await file.arrayBuffer());
        const url = await processAdImage(buffer, file.name);
        imageUrls.push(url);
      }
    }

    const adId = crypto.randomUUID();

    // 4. MySQL Persistence
    // Initial status is 'pending' -> Requires admin approval
    await query(`
      INSERT INTO advertisements (id, owner_id, category_id, title, description, image_urls, priority_level, status, location, price_range)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `, [
      adId, 
      session.user.id, 
      categoryId, 
      title, 
      description, 
      JSON.stringify(imageUrls), 
      priority, 
      'pending', 
      location, 
      priceRange
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
