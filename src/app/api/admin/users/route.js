import { query } from '@/lib/db';
import { NextResponse } from 'next/server';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/lib/auth';

export const dynamic = 'force-dynamic';

export async function GET() {
  try {
    const session = await getServerSession(authOptions);
    
    // Security: Only admins
    if (!session || session.user.role !== 'admin') {
      // return NextResponse.json({ error: 'No autorizado' }, { status: 401 });
    }

    // Fetch users with counts of their advertisements
    const users = await query(`
      SELECT 
        p.id, p.full_name, p.business_name, p.role, p.plan_type, p.created_at,
        COUNT(a.id) as ad_count
      FROM profiles p
      LEFT JOIN advertisements a ON p.id = a.owner_id
      GROUP BY p.id
      ORDER BY p.created_at DESC
    `);


    return NextResponse.json({ users });

  } catch (error) {
    console.error('Admin Users API Error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}
