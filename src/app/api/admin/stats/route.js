import { query } from '@/lib/db';
import { NextResponse } from 'next/server';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/lib/auth';

export async function GET() {
  try {
    const session = await getServerSession(authOptions);
    let userRole = session?.user?.role?.toLowerCase();
    
    // Fallback if missing role in session
    if (!userRole && session?.user?.email) {
      const users = await query('SELECT role FROM profiles WHERE email = ? LIMIT 1', [session.user.email]);
      userRole = users[0]?.role?.toLowerCase();
    }

    // Security check: Only admins
    if (userRole !== 'admin') {
      return NextResponse.json({ error: 'No autorizado' }, { status: 401 });
    }

    // --- DYNAMIC VALIDITY MAINTENANCE ---
    // Automatically transition 'active' ads to 'expired' if their time is up
    await query(`
      UPDATE advertisements 
      SET status = 'expired' 
      WHERE status = 'active' AND expires_at < NOW()
    `);

    // 1-3. Data from advertisements table directly (counters are kept there in this schema)
    const statsData = await query(`
      SELECT 
        (SELECT COUNT(*) FROM profiles) as users,
        (SELECT COUNT(*) FROM advertisements WHERE status = 'active') as activeAds,
        (SELECT COUNT(*) FROM advertisements WHERE status = 'pending') as pendingAds,
        (SELECT SUM(amount) FROM billings WHERE status = 'paid' AND created_at >= DATE_FORMAT(NOW(), '%Y-%m-01')) as revenue
    `);

    // 5. Build real time-series data for the last 7 days
    const dailyUsers = await query(`
      SELECT DATE(created_at) as date, COUNT(*) as count 
      FROM profiles 
      WHERE created_at >= CURDATE() - INTERVAL 6 DAY 
      GROUP BY DATE(created_at)
    `);

    const dailyAds = await query(`
      SELECT DATE(created_at) as date, COUNT(*) as count 
      FROM advertisements 
      WHERE created_at >= CURDATE() - INTERVAL 6 DAY 
      GROUP BY DATE(created_at)
    `);

    const dailyTraffic = await query(`
      SELECT 
        DATE(created_at) as date,
        SUM(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END) as views,
        SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) as clicks,
        SUM(CASE WHEN event_type = 'contact' THEN 1 ELSE 0 END) as contacts
      FROM metrics
      WHERE created_at >= CURDATE() - INTERVAL 6 DAY
      GROUP BY DATE(created_at)
    `);

    // Helper to generate the last 7 days and map counts
    const chartData = [];
    for (let i = 6; i >= 0; i--) {
      const d = new Date();
      d.setDate(d.getDate() - i);
      const dateStr = d.toISOString().split('T')[0];
      const displayDate = `${d.getDate().toString().padStart(2, '0')}/${(d.getMonth() + 1).toString().padStart(2, '0')}`;
      
      const userCount = dailyUsers.find(u => u.date.toISOString().split('T')[0] === dateStr)?.count || 0;
      const adCount = dailyAds.find(a => a.date.toISOString().split('T')[0] === dateStr)?.count || 0;
      const traffic = dailyTraffic.find(t => t.date.toISOString().split('T')[0] === dateStr) || { views: 0, clicks: 0, contacts: 0 };
      
      chartData.push({
        date: displayDate,
        anuncios: adCount,
        usuarios: userCount,
        vistas: traffic.views || 0,
        click: traffic.clicks || 0,
        contactos: traffic.contacts || 0
      });
    }


    // 6. Get pending ads with their details and owner info for the queue
    // Use GROUP BY to avoid duplicates if an ad has multiple billing records
    const queueAds = await query(`
      SELECT 
        a.id, a.title, a.description, a.location, a.price_range, a.image_urls, a.created_at, 
        p.full_name as owner_name,
        MAX(b.status) as billing_status, MAX(b.plan_type) as plan_type
      FROM advertisements a
      LEFT JOIN billings b ON a.id = b.ad_id
      LEFT JOIN profiles p ON a.owner_id = p.id
      WHERE a.status = 'pending'
      GROUP BY a.id, a.title, a.description, a.location, a.price_range, a.image_urls, a.created_at, p.full_name
      ORDER BY a.created_at DESC
      LIMIT 10
    `);

    // 7. Parse image_urls if they are strings (JSON column in MySQL)
    const formattedQueue = queueAds.map(ad => ({
      ...ad,
      image_urls: typeof ad.image_urls === 'string' ? JSON.parse(ad.image_urls) : ad.image_urls
    }));

    return NextResponse.json({
      stats: {
        users: statsData[0].users || 0,
        activeAds: statsData[0].activeAds || 0,
        pendingAds: statsData[0].pendingAds || 0,
        revenue: statsData[0].revenue || 0,
      },
      chartData: chartData,
      queue: formattedQueue
    });

  } catch (error) {
    console.error('Admin Stats API Error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}
