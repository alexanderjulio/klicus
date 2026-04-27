import { query } from '@/lib/db';
import { NextResponse } from 'next/server';
import { getUniversalSession } from '@/lib/auth-helper';
import { processAdImage } from '@/lib/image-service';

export const dynamic = 'force-dynamic';

/**
 * GET: Fetch ad detail
 */
export async function GET(request, { params }) {
  if (process.env.BUILD_MODE) return new Response(JSON.stringify({ build: true }), { status: 200, headers: { 'Content-Type': 'application/json' } });
  const { id } = await params;

  try {
    const results = await query(`
      SELECT 
        a.*, 
        c.name as category_name, 
        c.slug as category_slug,
        p.business_name,
        p.full_name as owner_name,
        p.avatar_url,
        p.phone as owner_phone
      FROM advertisements a
      LEFT JOIN categories c ON a.category_id = c.id
      LEFT JOIN profiles p ON a.owner_id = p.id
      WHERE a.id = ?
    `, [id]);

    if (results.length === 0) {
      return NextResponse.json({ error: 'Anuncio no encontrado' }, { status: 404 });
    }

    // Process JSON fields
    const ad = {
      ...results[0],
      image_urls: results[0].image_urls ? (typeof results[0].image_urls === 'string' ? JSON.parse(results[0].image_urls) : results[0].image_urls) : [],
    };

    return NextResponse.json(ad);
  } catch (error) {
    console.error('Error fetching ad detail:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}

/**
 * PUT: Update ad detail (Socio Dashboard / Mobile Edit)
 */
export async function PUT(request, { params }) {
  if (process.env.BUILD_MODE) return new Response(JSON.stringify({ build: true }), { status: 200, headers: { 'Content-Type': 'application/json' } });
  const { id } = await params;

  try {
    const user = await getUniversalSession(request);
    if (!user) {
      return NextResponse.json({ error: 'No autorizado' }, { status: 401 });
    }

    // 1. Check Ownership
    const existing = await query('SELECT owner_id, image_urls FROM advertisements WHERE id = ?', [id]);
    if (existing.length === 0) {
      return NextResponse.json({ error: 'Anuncio no encontrado' }, { status: 404 });
    }

    if (existing[0].owner_id !== user.id && user.role !== 'admin') {
      return NextResponse.json({ error: 'No tienes permiso para editar este anuncio' }, { status: 403 });
    }

    // 2. Parse Multipart Data
    const formData = await request.formData();
    const title = formData.get('title');
    const description = formData.get('description');
    const categoryId = formData.get('categoryId');
    const location = formData.get('location');
    const status = formData.get('status'); // Permite pausar/activar
    const keptImages = formData.getAll('kept_images'); // URLs of images to keep
    const newFiles = formData.getAll('images'); // New file uploads

    // 3. Image Processing
    let finalImageUrls = [...keptImages];

    for (const file of newFiles) {
      if (file.size > 0) {
        const buffer = Buffer.from(await file.arrayBuffer());
        const result = await processAdImage(buffer, file.name || 'edit.webp');
        finalImageUrls.push(result.url);
      }
    }

    // 4. Update Database
    await query(`
      UPDATE advertisements 
      SET 
        title = COALESCE(?, title),
        description = COALESCE(?, description),
        category_id = COALESCE(?, category_id),
        location = COALESCE(?, location),
        status = COALESCE(?, status),
        image_urls = ?
      WHERE id = ?
    `, [
      title, 
      description, 
      categoryId, 
      location, 
      status, 
      JSON.stringify(finalImageUrls), 
      id
    ]);

    return NextResponse.json({ 
      success: true, 
      message: 'Anuncio actualizado correctamente',
      image_urls: finalImageUrls
    });

  } catch (error) {
    console.error('Error updating ad:', error);
    return NextResponse.json({ error: 'Error interno al actualizar' }, { status: 500 });
  }
}
