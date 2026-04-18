import { query } from '@/lib/db';
import { NextResponse } from 'next/server';
import bcrypt from 'bcryptjs';
import { v4 as uuidv4 } from 'uuid';

export async function POST(req) {
  try {
    const { name, email, password } = await req.json();

    if (!name || !email || !password) {
      return NextResponse.json({ error: 'Faltan campos obligatorios' }, { status: 400 });
    }

    // Check if user already exists
    const existing = await query('SELECT id FROM profiles WHERE id = ? OR full_name = ?', [email, email]);
    if (existing.length > 0) {
      return NextResponse.json({ error: 'El usuario ya existe' }, { status: 409 });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 12);
    const userId = uuidv4();

    await query(`
      INSERT INTO profiles (id, email, full_name, role, password_hash, plan_type) 
      VALUES (?, ?, ?, 'cliente', ?, 'Gratis')
    `, [userId, email, name, hashedPassword]);


    return NextResponse.json({ 
      success: true, 
      message: 'Usuario registrado con éxito. Ya puedes iniciar sesión.' 
    });

  } catch (error) {
    console.error('Registration API Error:', error);
    return NextResponse.json({ error: 'Error interno del servidor' }, { status: 500 });
  }
}
