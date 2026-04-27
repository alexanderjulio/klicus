export const dynamic = 'force-dynamic';
import { query } from '@/lib/db';
import { NextResponse } from 'next/server';
import { getAuthenticatedUser } from '@/lib/auth-util';

/**
 * Admin User Search - Search users by name for push notifications
 */
export async function GET(req) {
  if (process.env.BUILD_MODE) return new Response(JSON.stringify({ build: true }), { status: 200, headers: { 'Content-Type': 'application/json' } });
  try {
    const adminUser = await getAuthenticatedUser(req);
    
    // Security: Only admins can search users
    if (!adminUser || adminUser.role !== 'admin') {
      return NextResponse.json({ error: 'No autorizado' }, { status: 403 });
    }

    const { searchParams } = new URL(req.url);
    const q = searchParams.get('q');

    if (!q || q.length < 2) {
      return NextResponse.json({ users: [] });
    }

    // Search in profiles table
    const users = await query(`
      SELECT id, full_name as name, email, role 
      FROM profiles 
      WHERE full_name LIKE ? OR email LIKE ?
      LIMIT 10
    `, [`%${q}%`, `%${q}%`]);

    return NextResponse.json({ success: true, users });

  } catch (error) {
    console.error('Admin User Search Error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}

