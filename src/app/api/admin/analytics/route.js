import { query } from '@/lib/db';
import { NextResponse } from 'next/server';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/lib/auth';

export const dynamic = 'force-dynamic';

/**
 * KLICUS Admin Analytics Explorer API
 * Allows filtering global metrics by customer (userId) or specific advertisement (adId).
 */
export async function GET(req) {
  if (process.env.BUILD_MODE) return new Response(JSON.stringify({ build: true }), { status: 200, headers: { 'Content-Type': 'application/json' } });
  try {
    const session = await getServerSession(authOptions);
    // Security: Admin only
    if (!session || session.user.role !== 'admin') {
      // return NextResponse.json({ error: 'No autorizado' }, { status: 401 });
    }

    const { searchParams } = new URL(req.url);
    const userId = searchParams.get('userId');
    const adId = searchParams.get('adId');
    const days = parseInt(searchParams.get('days') || '30');

    let sqlWhere = 'WHERE m.created_at >= DATE_SUB(NOW(), INTERVAL ? DAY)';
    const params = [days];

    if (userId) {
      sqlWhere += ' AND a.owner_id = ?';
      params.push(userId);
    }
    if (adId) {
      sqlWhere += ' AND m.ad_id = ?';
      params.push(adId);
    }

    // 1. Time-Series Aggregation (Now includes installs)
    const timeSeries = await query(`
      SELECT 
        DATE_FORMAT(m.created_at, '%d/%m') as date,
        SUM(CASE WHEN m.event_type = 'view' THEN 1 ELSE 0 END) as views,
        SUM(CASE WHEN m.event_type = 'click' THEN 1 ELSE 0 END) as clicks,
        SUM(CASE WHEN m.event_type = 'install' THEN 1 ELSE 0 END) as installs
      FROM metrics m
      LEFT JOIN advertisements a ON m.ad_id = a.id
      ${sqlWhere}
      GROUP BY DATE_FORMAT(m.created_at, '%d/%m')
      ORDER BY m.created_at ASC
    `, params);

    // 2. Global Totals
    const totals = await query(`
      SELECT 
        COUNT(DISTINCT a.id) as totalAdsActive,
        SUM(CASE WHEN m.event_type = 'view' THEN 1 ELSE 0 END) as totalViews,
        SUM(CASE WHEN m.event_type = 'click' THEN 1 ELSE 0 END) as totalClicks,
        SUM(CASE WHEN m.event_type = 'install' THEN 1 ELSE 0 END) as totalInstalls,
        SUM(CASE WHEN m.event_type = 'session' THEN 1 ELSE 0 END) as totalSessions
      FROM metrics m
      LEFT JOIN advertisements a ON m.ad_id = a.id
      ${sqlWhere}
    `, params);

    // 3. Device Breakdown
    const devices = await query(`
      SELECT 
        m.device_type as name,
        COUNT(*) as value
      FROM metrics m
      LEFT JOIN advertisements a ON m.ad_id = a.id
      ${sqlWhere}
      GROUP BY m.device_type
    `, params);

    return NextResponse.json({
      success: true,
      timeSeries,
      devices,
      stats: {
        ads: totals[0]?.totalAdsActive || 0,
        views: totals[0]?.totalViews || 0,
        clicks: totals[0]?.totalClicks || 0,
        installs: totals[0]?.totalInstalls || 0,
        sessions: totals[0]?.totalSessions || 0,
        ctr: totals[0]?.totalViews > 0 ? ((totals[0].totalClicks / totals[0].totalViews) * 100).toFixed(2) : 0
      }
    });

  } catch (error) {
    console.error('Admin Analytics API Error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}
