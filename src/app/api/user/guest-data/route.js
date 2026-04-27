export const dynamic = 'force-dynamic';
import { query } from '@/lib/db';
import { NextResponse } from 'next/server';

/**
 * Guest Identity Persistence API
 * POST: Save guest name linked to guestId
 */
export async function POST(req) {
  if (process.env.BUILD_MODE) return new Response(JSON.stringify({ build: true }), { status: 200, headers: { 'Content-Type': 'application/json' } });
  try {
    const { guestId, name } = await req.json();
    
    if (!guestId || !name) {
      return NextResponse.json({ error: 'Faltan parámetros' }, { status: 400 });
    }

    // Insert or update guest identity
    await query(`
      INSERT INTO guest_identities (id, name)
      VALUES (?, ?)
      ON DUPLICATE KEY UPDATE name = VALUES(name)
    `, [guestId, name]);

    return NextResponse.json({ success: true, message: 'Identidad registrada' });
  } catch (error) {
    console.error('Guest Identity API Error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}

