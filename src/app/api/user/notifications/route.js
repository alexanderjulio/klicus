export const dynamic = 'force-dynamic';
import { query } from '@/lib/db';
import { NextResponse } from 'next/server';
import { getUniversalSession } from '@/lib/auth-helper';

/**
 * KLICUS User Notifications API
 * GET: Retrieve list of notifications
 * PATCH: Mark as read
 */
export async function GET(req) {
  try {
    const user = await getUniversalSession(req);
    if (!user) {
      return NextResponse.json({ error: 'No autorizado' }, { status: 401 });
    }

    const notifications = await query(`
      SELECT * FROM notifications 
      WHERE user_id = ? 
      ORDER BY created_at DESC 
      LIMIT 30
    `, [user.id]);

    return NextResponse.json({ success: true, notifications });
  } catch (error) {
    console.error('Fetch Notifications Error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}

export async function PATCH(req) {
  try {
    const user = await getUniversalSession(req);
    if (!user) {
      return NextResponse.json({ error: 'No autorizado' }, { status: 401 });
    }

    const { id, all } = await req.json();

    if (all) {
      await query('UPDATE notifications SET is_read = TRUE WHERE user_id = ?', [user.id]);
    } else {
      await query('UPDATE notifications SET is_read = TRUE WHERE id = ? AND user_id = ?', [id, user.id]);
    }

    return NextResponse.json({ success: true });
  } catch (error) {
    console.error('Update Notification Error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}

