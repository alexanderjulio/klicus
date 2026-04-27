export const dynamic = 'force-dynamic';
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

    if (userRole !== 'admin') {
      return NextResponse.json({ error: 'No autorizado' }, { status: 401 });
    }

    const plans = await query('SELECT * FROM plan_configs');
    return NextResponse.json({ plans });
  } catch (error) {
    console.error('Fetch plans error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}

export async function POST(req) {
  try {
    const session = await getServerSession(authOptions);
    let userRole = session?.user?.role?.toLowerCase();
    
    // Fallback if missing role in session
    if (!userRole && session?.user?.email) {
      const users = await query('SELECT role FROM profiles WHERE email = ? LIMIT 1', [session.user.email]);
      userRole = users[0]?.role?.toLowerCase();
    }

    if (userRole !== 'admin') {
      return NextResponse.json({ error: 'No autorizado' }, { status: 401 });
    }

    const { plan_name, max_images, duration_days, is_featured } = await req.json();

    if (!plan_name) {
      return NextResponse.json({ error: 'Nombre de plan requerido' }, { status: 400 });
    }

    await query(`
      UPDATE plan_configs 
      SET max_images = ?, duration_days = ?, is_featured = ?
      WHERE plan_name = ?
    `, [max_images, duration_days, is_featured ? 1 : 0, plan_name]);

    return NextResponse.json({ success: true, message: `Plan ${plan_name} actualizado.` });
  } catch (error) {
    console.error('Update plan error:', error);
    return NextResponse.json({ error: 'Error actualizando plan' }, { status: 500 });
  }
}

