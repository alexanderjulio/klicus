export const dynamic = 'force-dynamic';
import { query } from '@/lib/db';
import { getAuthenticatedUser } from '@/lib/auth-util';
import { NextResponse } from 'next/server';

/** Adds `type` column to banners — works on MySQL 5.7+ and 8.0+ */
async function ensureTypeColumn() {
  try {
    await query("ALTER TABLE banners ADD COLUMN type VARCHAR(20) NOT NULL DEFAULT 'carousel'");
  } catch (e) {
    if (e.errno !== 1060) throw e; // 1060 = Duplicate column name (already exists)
  }
}

/**
 * Admin API to manage promotional banners
 */
export async function GET(req) {
  if (process.env.BUILD_MODE) return new Response(JSON.stringify({ build: true }), { status: 200, headers: { 'Content-Type': 'application/json' } });
  try {
    const user = await getAuthenticatedUser(req);
    if (!user || user.role !== 'admin') {
      return NextResponse.json({ error: 'No autorizado' }, { status: 403 });
    }

    const banners = await query('SELECT * FROM banners ORDER BY position ASC, created_at DESC');
    return NextResponse.json({ success: true, data: banners });
  } catch (error) {
    return NextResponse.json({ error: 'Error al listar banners' }, { status: 500 });
  }
}

export async function POST(req) {
  if (process.env.BUILD_MODE) return new Response(JSON.stringify({ build: true }), { status: 200, headers: { 'Content-Type': 'application/json' } });
  try {
    const user = await getAuthenticatedUser(req);
    if (!user || user.role !== 'admin') {
      return NextResponse.json({ error: 'No autorizado' }, { status: 403 });
    }

    const { title, subtitle, image_url, cta_text, cta_link, is_active, type } = await req.json();
    const bannerType = type === 'interstitial' ? 'interstitial' : 'carousel';

    if (bannerType === 'carousel' && !title) {
      return NextResponse.json({ error: 'Título es requerido para banners de carrusel' }, { status: 400 });
    }
    if (!image_url) {
      return NextResponse.json({ error: 'Imagen es requerida' }, { status: 400 });
    }

    await ensureTypeColumn();

    const result = await query(
      'INSERT INTO banners (title, subtitle, image_url, cta_text, cta_link, is_active, type) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [title ?? '', subtitle ?? null, image_url, cta_text ?? null, cta_link ?? null, is_active ?? true, bannerType]
    );

    return NextResponse.json({ success: true, id: result.insertId });
  } catch (error) {
    return NextResponse.json({ error: 'Error al crear banner' }, { status: 500 });
  }
}

export async function PUT(req) {
  if (process.env.BUILD_MODE) return new Response(JSON.stringify({ build: true }), { status: 200, headers: { 'Content-Type': 'application/json' } });
  try {
    const user = await getAuthenticatedUser(req);
    if (!user || user.role !== 'admin') {
      return NextResponse.json({ error: 'No autorizado' }, { status: 403 });
    }

    const body = await req.json();
    const { id } = body;

    if (!id) return NextResponse.json({ error: 'ID requerido' }, { status: 400 });

    await ensureTypeColumn();

    // Build dynamic UPDATE — avoids COALESCE treating boolean false as NULL
    const updates = [];
    const params = [];

    if (body.title !== undefined)    { updates.push('title = ?');     params.push(body.title); }
    if (body.subtitle !== undefined) { updates.push('subtitle = ?');  params.push(body.subtitle); }
    if (body.image_url !== undefined){ updates.push('image_url = ?'); params.push(body.image_url); }
    if (body.cta_text !== undefined) { updates.push('cta_text = ?');  params.push(body.cta_text); }
    if (body.cta_link !== undefined) { updates.push('cta_link = ?');  params.push(body.cta_link); }
    if (body.is_active !== undefined && body.is_active !== null) {
      updates.push('is_active = ?');
      params.push(body.is_active ? 1 : 0);
    }
    if (body.position !== undefined) { updates.push('position = ?'); params.push(body.position); }

    if (updates.length === 0) return NextResponse.json({ error: 'Nada que actualizar' }, { status: 400 });

    params.push(id);
    await query(`UPDATE banners SET ${updates.join(', ')} WHERE id = ?`, params);

    return NextResponse.json({ success: true });
  } catch (error) {
    return NextResponse.json({ error: 'Error al actualizar banner' }, { status: 500 });
  }
}

export async function DELETE(req) {
  if (process.env.BUILD_MODE) return new Response(JSON.stringify({ build: true }), { status: 200, headers: { 'Content-Type': 'application/json' } });
  try {
    const user = await getAuthenticatedUser(req);
    if (!user || user.role !== 'admin') {
      return NextResponse.json({ error: 'No autorizado' }, { status: 403 });
    }

    const { searchParams } = new URL(req.url);
    const id = searchParams.get('id');

    if (!id) return NextResponse.json({ error: 'ID requerido' }, { status: 400 });

    await query('DELETE FROM banners WHERE id = ?', [id]);

    return NextResponse.json({ success: true });
  } catch (error) {
    return NextResponse.json({ error: 'Error al eliminar banner' }, { status: 500 });
  }
}

