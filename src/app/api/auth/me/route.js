import { query } from '@/lib/db';
import { NextResponse } from 'next/server';
import { getUniversalSession } from '@/lib/auth-helper';

/**
 * GET: Verify session and return full user profile
 * Supports both Web (Cookies) and Mobile (JWT Authorization Header)
 */
export async function GET(req) {
  try {
    // 1. Get session using the universal helper
    const sessionUser = await getUniversalSession(req);
    
    if (!sessionUser) {
      return NextResponse.json({ error: 'Sesión no válida o expirada' }, { status: 401 });
    }

    // 2. Fetch fresh full profile from database
    const profiles = await query(`
      SELECT 
        id, email, full_name, business_name, phone, avatar_url, bio, website, banner_url, social_links, role, plan_type, created_at
      FROM profiles 
      WHERE id = ?
    `, [sessionUser.id]);

    if (profiles.length === 0) {
      return NextResponse.json({ error: 'Usuario no encontrado' }, { status: 404 });
    }

    const userProfile = profiles[0];

    // 3. Return successfully
    return NextResponse.json({ 
      success: true, 
      user: {
        id: userProfile.id,
        name: userProfile.full_name,
        email: userProfile.email,
        business_name: userProfile.business_name,
        phone: userProfile.phone,
        avatar_url: userProfile.avatar_url,
        bio: userProfile.bio,
        website: userProfile.website,
        banner_url: userProfile.banner_url,
        social_links: typeof userProfile.social_links === 'string' 
          ? JSON.parse(userProfile.social_links) 
          : userProfile.social_links,
        role: userProfile.role,
        plan_type: userProfile.plan_type
      }
    });

  } catch (error) {
    console.error('Auth Me API Error:', error);
    return NextResponse.json({ error: 'Error interno del servidor' }, { status: 500 });
  }
}
