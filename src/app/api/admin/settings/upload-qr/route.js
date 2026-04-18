import { NextResponse } from 'next/server';
import { processQRImage } from '@/lib/image-service';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/lib/auth';

export async function POST(req) {
  try {
    const session = await getServerSession(authOptions);
    const isAdmin = session?.user?.role === 'admin';

    if (!isAdmin) {
      return NextResponse.json({ error: 'No autorizado' }, { status: 401 });
    }

    const formData = await req.formData();
    const file = formData.get('file');

    if (!file || file.size === 0) {
      return NextResponse.json({ error: 'No se envió ninguna imagen' }, { status: 400 });
    }

    const buffer = Buffer.from(await file.arrayBuffer());
    const imageUrl = await processQRImage(buffer, file.name);

    return NextResponse.json({ success: true, url: imageUrl });
  } catch (error) {
    console.error('QR Upload API Error:', error);
    return NextResponse.json({ error: 'Error al procesar la imagen' }, { status: 500 });
  }
}
