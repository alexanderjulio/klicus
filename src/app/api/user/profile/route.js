import { query } from '@/lib/db';
import { NextResponse } from 'next/server';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/lib/auth';

/**
 * KLICUS User Profile API
 * GET: Fetch current user profile
 * PUT: Update user profile fields
 */

export async function GET() {
  try {
    const session = await getServerSession(authOptions);
    if (!session) {
      return NextResponse.json({ error: 'No autorizado' }, { status: 401 });
    }

    const userId = session.user.id;
    const profiles = await query('SELECT id, email, full_name, business_name, role, plan_type, created_at FROM profiles WHERE id = ?', [userId]);

    if (profiles.length === 0) {
      return NextResponse.json({ error: 'Perfil no encontrado' }, { status: 404 });
    }

    return NextResponse.json({ profile: profiles[0] });

  } catch (error) {
    console.error('Profile API GET Error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}

export async function PUT(req) {
  try {
    const session = await getServerSession(authOptions);
    if (!session) {
      return NextResponse.json({ error: 'No autorizado' }, { status: 401 });
    }

    const userId = session.user.id;
    const { fullName, businessName } = await req.json();

    if (!fullName) {
      return NextResponse.json({ error: 'El nombre completo es obligatorio' }, { status: 400 });
    }

    await query(`
      UPDATE profiles 
      SET full_name = ?, business_name = ?
      WHERE id = ?
    `, [fullName, businessName, userId]);

    return NextResponse.json({ success: true, message: 'Perfil actualizado correctamente' });

  } catch (error) {
    console.error('Profile API PUT Error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}
