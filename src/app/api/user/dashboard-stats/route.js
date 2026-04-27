export const dynamic = 'force-dynamic';
import { query } from '@/lib/db';
import { NextResponse } from 'next/server';
import { getAuthenticatedUser } from '@/lib/auth-util';

export async function GET(req) {
  try {
    const user = await getAuthenticatedUser(req);
    const userId = user?.id || 'demo-user-123';

    // 1. Get user ads with their stats using subqueries for metrics counts
    const ads = await query(`
      SELECT 
        a.*, 
        c.name as category_name,
        (SELECT COUNT(*) FROM metrics WHERE ad_id = a.id AND event_type = 'click') as real_clicks,
        (SELECT COUNT(*) FROM metrics WHERE ad_id = a.id AND event_type = 'view') as real_views
      FROM advertisements a
      LEFT JOIN categories c ON a.category_id = c.id
      WHERE a.owner_id = ?
      ORDER BY a.created_at DESC
    `, [userId]);

    // 2. Aggregate stats
    const stats = {
      totalAds: ads.length,
      activeAds: ads.filter(a => a.status === 'active').length,
      pendingAds: ads.filter(a => a.status === 'pending').length,
      totalClicks: ads.reduce((acc, curr) => acc + (curr.real_clicks || 0), 0),
      totalViews: ads.reduce((acc, curr) => acc + (curr.real_views || 0), 0),
    };

    // 3. Billing history (simplified)
    const bills = await query(`
      SELECT b.*, a.title as ad_title 
      FROM billings b
      JOIN advertisements a ON b.ad_id = a.id
      WHERE a.owner_id = ?
      ORDER BY b.created_at DESC
      LIMIT 5
    `, [userId]);

    return NextResponse.json({
      success: true,
      stats,
      ads: ads.map(ad => ({
        ...ad,
        image_urls: typeof ad.image_urls === 'string' ? JSON.parse(ad.image_urls) : (ad.image_urls || [])
      })),
      recentBills: bills
    });

  } catch (error) {
    console.error('User Dashboard Stats API Error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}

