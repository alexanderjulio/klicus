import { query } from '@/lib/db';
import { NextResponse } from 'next/server';
import { getUniversalSession } from '@/lib/auth-helper';

/**
 * GET: Fetch the complete profile of the authenticated user
 */
export async function GET(req) {
  try {
    const user = await getUniversalSession(req);
    
    if (!user) {
      return NextResponse.json({ error: 'No autorizado' }, { status: 401 });
    }

    const profiles = await query(`
      SELECT 
        id, email, full_name, business_name, phone, avatar_url, bio, website, banner_url, social_links, role, plan_type, created_at
      FROM profiles 
      WHERE id = ?
    `, [user.id]);

    if (profiles.length === 0) {
      return NextResponse.json({ error: 'Perfil no encontrado' }, { status: 404 });
    }

    return NextResponse.json({ 
      success: true, 
      profile: profiles[0]
    });

  } catch (error) {
    console.error('Profile API GET Error:', error);
    return NextResponse.json({ error: 'Error interno del servidor' }, { status: 500 });
  }
}

/**
 * PUT: Update profile information
 */
export async function PUT(req) {
  try {
    const user = await getUniversalSession(req);
    
    if (!user) {
      return NextResponse.json({ error: 'No autorizado' }, { status: 401 });
    }

    const body = await req.json();
    const { full_name, business_name, phone, bio, website, banner_url, social_links } = body;

    await query(`
      UPDATE profiles 
      SET 
        full_name = COALESCE(?, full_name),
        business_name = COALESCE(?, business_name),
        phone = COALESCE(?, phone),
        bio = COALESCE(?, bio),
        website = COALESCE(?, website),
        banner_url = COALESCE(?, banner_url),
        social_links = COALESCE(?, social_links)
      WHERE id = ?
    `, [full_name, business_name, phone, bio, website, banner_url, social_links, user.id]);

    return NextResponse.json({ 
      success: true, 
      message: 'Perfil actualizado correctamente'
    });

  } catch (error) {
    console.error('Profile API PUT Error:', error);
    return NextResponse.json({ error: 'Error al actualizar el perfil' }, { status: 500 });
  }
}
