import { query } from '@/lib/db';
import { NextResponse } from 'next/server';
import { getUniversalSession } from '@/lib/auth-helper';

export const dynamic = 'force-dynamic';

/**
 * GET: Fetch aggregated metrics for a specific ad
 * Query Params: ?range=7|30|total
 */
export async function GET(req, { params }) {
  const { adId } = await params;
  const { searchParams } = new URL(req.url);
  const range = searchParams.get('range') || '30';

  try {
    const user = await getUniversalSession(req);
    if (!user) return NextResponse.json({ error: 'No autorizado' }, { status: 401 });

    // 1. Verify Ownership
    const adOwner = await query('SELECT owner_id, title FROM advertisements WHERE id = ?', [adId]);
    if (adOwner.length === 0) return NextResponse.json({ error: 'Anuncio no encontrado' }, { status: 404 });
    if (adOwner[0].owner_id !== user.id && user.role !== 'admin') {
      return NextResponse.json({ error: 'No tienes permiso para ver estas métricas' }, { status: 403 });
    }

    // 2. Build Query based on range
    let timeFilter = '';
    if (range === '7') timeFilter = 'AND created_at > DATE_SUB(NOW(), INTERVAL 7 DAY)';
    else if (range === '30') timeFilter = 'AND created_at > DATE_SUB(NOW(), INTERVAL 30 DAY)';
    // if 'total', no filter

    const stats = await query(`
      SELECT 
        DATE(created_at) as date,
        COUNT(CASE WHEN event_type = 'view' THEN 1 END) as views,
        COUNT(CASE WHEN event_type = 'click' THEN 1 END) as clicks,
        COUNT(CASE WHEN event_type = 'contact' THEN 1 END) as contacts,
        COUNT(CASE WHEN event_type = 'chat' THEN 1 END) as chats
      FROM metrics
      WHERE ad_id = ? ${timeFilter}
      GROUP BY DATE(created_at)
      ORDER BY date ASC
    `, [adId]);

    const totals = await query(`
       SELECT 
        COUNT(CASE WHEN event_type = 'view' THEN 1 END) as total_views,
        COUNT(CASE WHEN event_type = 'click' THEN 1 END) as total_clicks,
        COUNT(CASE WHEN event_type = 'contact' THEN 1 END) as total_contacts,
        COUNT(CASE WHEN event_type = 'chat' THEN 1 END) as total_chats
      FROM metrics
      WHERE ad_id = ? ${timeFilter}
    `, [adId]);

    return NextResponse.json({
      success: true,
      ad_title: adOwner[0].title,
      range,
      totals: totals[0],
      daily: stats
    });

  } catch (error) {
    console.error('Analytics API Error:', error);
    return NextResponse.json({ error: 'Error interno del servidor' }, { status: 500 });
  }
}
