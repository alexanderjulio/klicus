export const dynamic = 'force-dynamic';
import { query } from '@/lib/db';
import { NextResponse } from 'next/server';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/lib/auth';
import bcrypt from 'bcryptjs';
import { v4 as uuidv4 } from 'uuid';
import { PROFILE_PLANS } from '@/config/plans';

export async function POST(req) {
  if (process.env.BUILD_MODE) return new Response(JSON.stringify({ build: true }), { status: 200, headers: { 'Content-Type': 'application/json' } });
  try {
    const session = await getServerSession(authOptions);
    if (!session || session.user.role !== 'admin') {
      return NextResponse.json({ error: 'No autorizado' }, { status: 401 });
    }

    const { full_name, email, password, role } = await req.json();

    if (!full_name || !email || !password || !role) {
      return NextResponse.json({ error: 'Faltan campos obligatorios' }, { status: 400 });
    }

    // Check if user exists
    const existing = await query('SELECT id FROM profiles WHERE email = ?', [email]);
    if (existing.length > 0) {
      return NextResponse.json({ error: 'El correo electrónico ya está registrado' }, { status: 400 });
    }

    const userId = uuidv4();
    const hashedPassword = await bcrypt.hash(password, 12);

    await query(`
      INSERT INTO profiles (id, email, full_name, role, password_hash, plan_type)
      VALUES (?, ?, ?, ?, ?, ?)
    `, [userId, email, full_name, role, hashedPassword, PROFILE_PLANS.FREE]);

    return NextResponse.json({ success: true, message: 'Usuario creado exitosamente' });
  } catch (error) {
    console.error('Create User API Error:', error);
    return NextResponse.json({ error: 'Error al crear el usuario' }, { status: 500 });
  }
}

