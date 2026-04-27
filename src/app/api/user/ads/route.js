import { query } from '@/lib/db';
import { NextResponse } from 'next/server';
import { getUniversalSession } from '@/lib/auth-helper';

export const dynamic = 'force-dynamic';

/**
 * GET: Fetch ads owned by the authenticated user
 */
export async function GET(req) {
  try {
    const user = await getUniversalSession(req);
    
    if (!user) {
      return NextResponse.json({ error: 'No autorizado' }, { status: 401 });
    }

    const ads = await query(`
      SELECT a.*, c.name as category_name
      FROM advertisements a
      LEFT JOIN categories c ON a.category_id = c.id
      WHERE a.owner_id = ?
      ORDER BY a.created_at DESC
    `, [user.id]);

    const formattedAds = ads.map(ad => ({
      ...ad,
      image_urls: typeof ad.image_urls === 'string' ? JSON.parse(ad.image_urls) : (ad.image_urls || [])
    }));

    return NextResponse.json({ 
      success: true, 
      count: formattedAds.length,
      ads: formattedAds 
    });

  } catch (error) {
    console.error('User Ads API Error:', error);
    return NextResponse.json({ error: 'Error interno del servidor' }, { status: 500 });
  }
}
