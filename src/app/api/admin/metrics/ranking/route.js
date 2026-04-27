export const dynamic = 'force-dynamic';
import { query } from '@/lib/db';
import { NextResponse } from 'next/server';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/lib/auth';

export async function GET() {
  if (process.env.BUILD_MODE) return new Response(JSON.stringify({ build: true }), { status: 200, headers: { 'Content-Type': 'application/json' } });
  try {
    const session = await getServerSession(authOptions);
    let userRole = session?.user?.role?.toLowerCase();
    
    // Fallback: If role is missing from session (stale JWT), fetch from DB
    if (!userRole && session?.user?.email) {
      const users = await query('SELECT role FROM profiles WHERE email = ?', [session.user.email]);
      userRole = users[0]?.role?.toLowerCase();
    }

    if (userRole !== 'admin') {
      console.warn('Unauthorized ranking access attempt:', session?.user?.email);
      return NextResponse.json({ error: 'No autorizado', rankings: [] }, { status: 401 });
    }

    // Fetch active ads with their aggregated metrics
    const rankings = await query(`
      SELECT 
        a.id, 
        a.title, 
        a.status,
        a.created_at,
        p.full_name as owner_name,
        (SELECT COUNT(*) FROM metrics WHERE ad_id = a.id AND event_type = 'view') as views,
        (SELECT COUNT(*) FROM metrics WHERE ad_id = a.id AND event_type = 'click') as clicks,
        (SELECT COUNT(*) FROM metrics WHERE ad_id = a.id AND event_type = 'contact') as contacts
      FROM advertisements a
      LEFT JOIN profiles p ON a.owner_id = p.id
      WHERE LOWER(a.status) = 'active'
      ORDER BY views DESC
      LIMIT 200
    `);

    console.log(`Rankings API: Found ${rankings.length} active ads.`);

    return NextResponse.json({ rankings });

  } catch (error) {
    console.error('Admin Metrics Ranking Error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}

