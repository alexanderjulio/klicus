export const dynamic = 'force-dynamic';
import { query } from '@/lib/db';
import { NextResponse } from 'next/server';
import bcrypt from 'bcryptjs';
import { v4 as uuidv4 } from 'uuid';
import { PROFILE_PLANS } from '@/config/plans';

export async function POST(req) {
  if (process.env.BUILD_MODE) return new Response(JSON.stringify({ build: true }), { status: 200, headers: { 'Content-Type': 'application/json' } });
  try {
    const { name, email, password } = await req.json();

    if (!name || !email || !password) {
      return NextResponse.json({ error: 'Faltan campos obligatorios' }, { status: 400 });
    }

    // Check if user already exists
    const existing = await query('SELECT id FROM profiles WHERE email = ?', [email]);
    if (existing.length > 0) {
      return NextResponse.json({ error: 'El usuario ya existe con ese correo' }, { status: 409 });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 12);
    const userId = uuidv4();

    await query(`
      INSERT INTO profiles (id, email, full_name, role, password_hash, plan_type) 
      VALUES (?, ?, ?, 'cliente', ?, ?)
    `, [userId, email, name, hashedPassword, PROFILE_PLANS.FREE]);


    return NextResponse.json({ 
      success: true, 
      message: 'Usuario registrado con éxito. Ya puedes iniciar sesión.' 
    });

  } catch (error) {
    console.error('Registration API Error:', error);
    return NextResponse.json({ error: 'Error interno del servidor' }, { status: 500 });
  }
}

