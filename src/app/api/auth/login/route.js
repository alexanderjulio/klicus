export const dynamic = 'force-dynamic';
import { query } from '@/lib/db';
import { NextResponse } from 'next/server';
import bcrypt from 'bcryptjs';
import { SignJWT } from 'jose';

/**
 * Mobile Login API - Returns a JWT for mobile authentication
 */
export async function POST(req) {
  try {
    const { email, password } = await req.json();

    if (!email || !password) {
      return NextResponse.json({ error: 'Faltan campos obligatorios' }, { status: 400 });
    }

    // 1. Fetch user from database
    const users = await query('SELECT * FROM profiles WHERE email = ? LIMIT 1', [email]);
    const user = users[0];

    if (!user) {
      return NextResponse.json({ error: 'Credenciales inválidas' }, { status: 401 });
    }

    // 2. Compare password
    const isMatch = await bcrypt.compare(password, user.password_hash);
    if (!isMatch) {
      return NextResponse.json({ error: 'Credenciales inválidas' }, { status: 401 });
    }

    // 3. Generate JWT (Compatible with Next-Auth if possible, or isolated for Mobile)
    // We sign a token with basic user info
    const secret = new TextEncoder().encode(process.env.NEXTAUTH_SECRET);
    const token = await new SignJWT({
      id: user.id,
      name: user.full_name,
      email: user.email,
      role: user.role,
      plan_type: user.plan_type
    })
      .setProtectedHeader({ alg: 'HS256' })
      .setIssuedAt()
      .setExpirationTime('30d') // Long session for Mobile
      .sign(secret);

    return NextResponse.json({ 
      success: true, 
      token,
      user: {
        id: user.id,
        name: user.full_name,
        email: user.email,
        role: user.role
      }
    });

  } catch (error) {
    console.error('Mobile Login API Error:', error);
    return NextResponse.json({ error: 'Error interno del servidor' }, { status: 500 });
  }
}

