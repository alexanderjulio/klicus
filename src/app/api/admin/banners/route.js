export const dynamic = 'force-dynamic';
import { query } from '@/lib/db';
import { getAuthenticatedUser } from '@/lib/auth-util';
import { NextResponse } from 'next/server';

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

    const { title, subtitle, image_url, cta_text, cta_link, is_active } = await req.json();

    if (!title || !image_url) {
      return NextResponse.json({ error: 'Título e imagen son requeridos' }, { status: 400 });
    }

    const result = await query(
      'INSERT INTO banners (title, subtitle, image_url, cta_text, cta_link, is_active) VALUES (?, ?, ?, ?, ?, ?)',
      [title, subtitle, image_url, cta_text, cta_link, is_active ?? true]
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

    const { id, title, subtitle, image_url, cta_text, cta_link, is_active, position } = await req.json();

    if (!id) return NextResponse.json({ error: 'ID requerido' }, { status: 400 });

    await query(
      `UPDATE banners SET 
        title = COALESCE(?, title),
        subtitle = COALESCE(?, subtitle),
        image_url = COALESCE(?, image_url),
        cta_text = COALESCE(?, cta_text),
        cta_link = COALESCE(?, cta_link),
        is_active = COALESCE(?, is_active),
        position = COALESCE(?, position)
      WHERE id = ?`,
      [title, subtitle, image_url, cta_text, cta_link, is_active, position, id]
    );

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

