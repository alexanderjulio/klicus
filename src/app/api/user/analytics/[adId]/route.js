import { query } from '@/lib/db';
import { NextResponse } from 'next/server';
import { getUniversalSession } from '@/lib/auth-helper';

export const dynamic = 'force-dynamic';

export async function GET(req, { params }) {
  if (process.env.BUILD_MODE) return new Response(JSON.stringify({ build: true }), { status: 200, headers: { 'Content-Type': 'application/json' } });
  const { adId } = await params;
  const { searchParams } = new URL(req.url);
  const range = searchParams.get('range') || '30';
  const startDate = searchParams.get('startDate');
  const endDate = searchParams.get('endDate');

  try {
    const user = await getUniversalSession(req);
    if (!user) return NextResponse.json({ error: 'No autorizado' }, { status: 401 });

    const adOwner = await query(
      'SELECT owner_id, title, created_at FROM advertisements WHERE id = ?',
      [adId]
    );
    if (adOwner.length === 0) return NextResponse.json({ error: 'Anuncio no encontrado' }, { status: 404 });
    if (adOwner[0].owner_id !== user.id && user.role !== 'admin') {
      return NextResponse.json({ error: 'No tienes permiso para ver estas métricas' }, { status: 403 });
    }

    let timeFilter = '';
    let timeParams = [];
    if (startDate && endDate) {
      timeFilter = 'AND DATE(created_at) BETWEEN ? AND ?';
      timeParams = [startDate, endDate];
    } else if (range === '7') {
      timeFilter = 'AND created_at > DATE_SUB(NOW(), INTERVAL 7 DAY)';
    } else if (range === '90') {
      timeFilter = 'AND created_at > DATE_SUB(NOW(), INTERVAL 90 DAY)';
    } else if (range === '30') {
      timeFilter = 'AND created_at > DATE_SUB(NOW(), INTERVAL 30 DAY)';
    }

    const [timeSeries, totalsRows, deviceRows] = await Promise.all([
      query(`
        SELECT
          DATE(created_at) as date,
          COUNT(CASE WHEN event_type = 'view'    THEN 1 END) as views,
          COUNT(CASE WHEN event_type = 'click'   THEN 1 END) as clicks,
          COUNT(CASE WHEN event_type = 'contact' THEN 1 END) as contacts,
          COUNT(CASE WHEN event_type = 'chat'    THEN 1 END) as chats
        FROM metrics
        WHERE ad_id = ? ${timeFilter}
        GROUP BY DATE(created_at)
        ORDER BY date ASC
      `, [adId, ...timeParams]),

      query(`
        SELECT
          COUNT(CASE WHEN event_type = 'view'    THEN 1 END) as total_views,
          COUNT(CASE WHEN event_type = 'click'   THEN 1 END) as total_clicks,
          COUNT(CASE WHEN event_type = 'contact' THEN 1 END) as total_contacts,
          COUNT(CASE WHEN event_type = 'chat'    THEN 1 END) as total_chats
        FROM metrics
        WHERE ad_id = ? ${timeFilter}
      `, [adId, ...timeParams]),

      query(`
        SELECT device_type as name, COUNT(*) as value
        FROM metrics
        WHERE ad_id = ? ${timeFilter}
        GROUP BY device_type
      `, [adId, ...timeParams]),
    ]);

    const t = totalsRows[0];
    const views    = Number(t.total_views)    || 0;
    const clicks   = Number(t.total_clicks)   || 0;
    const contacts = Number(t.total_contacts) || 0;
    const chats    = Number(t.total_chats)    || 0;

    return NextResponse.json({
      success: true,
      adTitle:   adOwner[0].title,
      createdAt: adOwner[0].created_at,
      timeSeries,
      devices: deviceRows.length > 0 ? deviceRows : [],
      stats: {
        views,
        clicks,
        contacts,
        chats,
        installs: 0,
        sessions: 0,
        ctr:            views > 0 ? ((clicks   / views) * 100).toFixed(1) : 0,
        conversionRate: views > 0 ? ((contacts / views) * 100).toFixed(1) : 0,
      },
    });

  } catch (error) {
    console.error('Analytics API Error:', error);
    return NextResponse.json({ error: 'Error interno del servidor' }, { status: 500 });
  }
}
