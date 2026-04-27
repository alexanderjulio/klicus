export const dynamic = 'force-dynamic';
import { getAuthenticatedUser } from '@/lib/auth-util';
import { processMarketingImage, processAdImage } from '@/lib/image-service';
import { NextResponse } from 'next/server';

/**
 * Admin API to upload and process images (Banners or Ads)
 */
export async function POST(req) {
  try {
    const user = await getAuthenticatedUser(req);
    if (!user || user.role !== 'admin') {
      return NextResponse.json({ error: 'No autorizado' }, { status: 403 });
    }

    const formData = await req.formData();
    const file = formData.get('image');
    const type = formData.get('type') || 'marketing'; // 'marketing' or 'ad'

    if (!file) {
      return NextResponse.json({ error: 'Archivo no encontrado' }, { status: 400 });
    }

    const buffer = Buffer.from(await file.arrayBuffer());
    let result;

    if (type === 'ad') {
      result = await processAdImage(buffer, file.name || 'image.webp');
    } else {
      result = await processMarketingImage(buffer, file.name || 'banner.webp');
    }

    return NextResponse.json({ 
      success: true, 
      ...result // url, width, height, size
    });

  } catch (error) {
    console.error('Upload API Error:', error);
    return NextResponse.json({ error: 'Error procesando la subida' }, { status: 500 });
  }
}

