import { query } from '@/lib/db';
import { NextResponse } from 'next/server';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/lib/auth';

export const dynamic = 'force-dynamic';

/**
 * KLICUS Admin Analytics API
 * Returns detailed metrics for ANY advertisement. Regular users cannot access this.
 */
export async function GET(req, { params }) {
  try {
    const session = await getServerSession(authOptions);
    const isAdmin = session?.user?.role === 'admin';

    if (!isAdmin) {
      return NextResponse.json({ error: 'No autorizado' }, { status: 401 });
    }

    const { adId } = await params;
    const { searchParams } = new URL(req.url);
    const startDate = searchParams.get('startDate') || '';
    const endDate = searchParams.get('endDate') || '';

    // A. Fetch Ad Metadata (Title & Business Name)
    const adInfo = await query(`
        SELECT a.title, p.business_name, p.full_name 
        FROM advertisements a 
        JOIN profiles p ON a.owner_id = p.id 
        WHERE a.id = ?
    `, [adId]);
    
    const adData = adInfo[0] || {};
    const adTitle = adData.title || 'Pauta Desconocida';
    const businessName = adData.business_name || adData.full_name || 'Comercio';
    const combinedTitle = `${adTitle} | ${businessName}`;

    // B. Build dynamic Date Clause
    let dateFilter = 'AND created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)';
    const params_list = [adId];

    if (startDate && endDate) {
      dateFilter = 'AND created_at BETWEEN ? AND ?';
      params_list.push(startDate + ' 00:00:00', endDate + ' 23:59:59');
    }

    const rawTimeSeries = await query(`
      SELECT 
        DATE_FORMAT(created_at, '%d/%m') as date,
        SUM(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END) as views,
        SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) as clicks,
        SUM(CASE WHEN event_type = 'contact' THEN 1 ELSE 0 END) as contacts
      FROM metrics
      WHERE ad_id = ? ${dateFilter}
      GROUP BY date
      ORDER BY MIN(created_at) ASC
    `, params_list);

    // Final Time Series with zero-fill for better Charting
    let timeSeries = rawTimeSeries;
    
    // If it's the default 30-day view, we fill the gaps (ALWAYS, even if rawTimeSeries is empty)
    if (!startDate && !endDate) {
        const fullSeries = [];
        const now = new Date();
        const dataMap = new Map(rawTimeSeries.map(item => [item.date, item]));
        
        for (let i = 29; i >= 0; i--) {
            const d = new Date(now);
            d.setDate(d.getDate() - i);
            const dateStr = `${String(d.getDate()).padStart(2, '0')}/${String(d.getMonth() + 1).padStart(2, '0')}`;
            
            if (dataMap.has(dateStr)) {
                fullSeries.push(dataMap.get(dateStr));
            } else {
                fullSeries.push({ date: dateStr, views: 0, clicks: 0, contacts: 0 });
            }
        }
        timeSeries = fullSeries;
    }

    const devices = await query(`
      SELECT 
        device_type as name,
        COUNT(*) as value
      FROM metrics
      WHERE ad_id = ? ${dateFilter}
      GROUP BY device_type
    `, params_list);

    const totalsResult = await query(`
      SELECT 
        SUM(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END) as totalViews,
        SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) as totalClicks,
        SUM(CASE WHEN event_type = 'contact' THEN 1 ELSE 0 END) as totalContacts
      FROM metrics
      WHERE ad_id = ? ${dateFilter}
    `, params_list);

    const totals = totalsResult[0] || { totalViews: 0, totalClicks: 0, totalContacts: 0 };
    
    const v = Number(totals.totalViews || 0);
    const c = Number(totals.totalClicks || 0);
    const co = Number(totals.totalContacts || 0);

    return NextResponse.json({
      success: true,
      adTitle: combinedTitle,
      adId: adId,
      timeSeries: timeSeries,
      devices,
      totals: {
        views: v,
        clicks: c,
        contacts: co,
        ctr: v > 0 ? ((c / v) * 100).toFixed(2) : 0,
        conversionRate: c > 0 ? ((co / c) * 100).toFixed(2) : 0
      }
    });

  } catch (error) {
    console.error('Admin Analytics API Error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}
