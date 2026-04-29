export const dynamic = 'force-dynamic';
import { query } from '@/lib/db';
import { NextResponse } from 'next/server';
import { getUniversalSession } from '@/lib/auth-helper';

/**
 * GET: Fetch the complete profile of the authenticated user
 */
export async function GET(req) {
  if (process.env.BUILD_MODE) return new Response(JSON.stringify({ build: true }), { status: 200, headers: { 'Content-Type': 'application/json' } });
  try {
    const user = await getUniversalSession(req);
    
    if (!user) {
      return NextResponse.json({ error: 'No autorizado' }, { status: 401 });
    }

    const profiles = await query(`
      SELECT 
        id, email, full_name, business_name, phone, avatar_url, bio, website, banner_url, social_links, role, plan_type, created_at
      FROM profiles 
      WHERE id = ?
    `, [user.id]);

    if (profiles.length === 0) {
      return NextResponse.json({ error: 'Perfil no encontrado' }, { status: 404 });
    }

    return NextResponse.json({ 
      success: true, 
      profile: profiles[0]
    });

  } catch (error) {
    console.error('Profile API GET Error:', error);
    return NextResponse.json({ error: 'Error interno del servidor' }, { status: 500 });
  }
}

/**
 * DELETE: Request account deletion — logs the request and permanently deletes the account.
 */
export async function DELETE(req) {
  if (process.env.BUILD_MODE) return new Response(JSON.stringify({ build: true }), { status: 200, headers: { 'Content-Type': 'application/json' } });
  try {
    const user = await getUniversalSession(req);
    if (!user) {
      return NextResponse.json({ error: 'No autorizado' }, { status: 401 });
    }

    // Admins cannot self-delete via this endpoint
    if (user.role === 'admin') {
      return NextResponse.json({ error: 'Los administradores no pueden eliminar su cuenta desde el perfil.' }, { status: 403 });
    }

    const body = await req.json().catch(() => ({}));
    const reason = body.reason?.trim() || null;

    // Ensure the audit table exists
    await query(`
      CREATE TABLE IF NOT EXISTS account_deletion_requests (
        id            INT AUTO_INCREMENT PRIMARY KEY,
        user_id       VARCHAR(255) NOT NULL,
        email         VARCHAR(255) NOT NULL,
        full_name     VARCHAR(255),
        reason        TEXT,
        ads_deleted   INT DEFAULT 0,
        requested_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    `);

    // Snapshot data before deletion
    const profiles = await query('SELECT email, full_name FROM profiles WHERE id = ?', [user.id]);
    if (profiles.length === 0) {
      return NextResponse.json({ error: 'Cuenta no encontrada' }, { status: 404 });
    }
    const { email, full_name } = profiles[0];

    const adsResult = await query('SELECT COUNT(*) as total FROM advertisements WHERE owner_id = ?', [user.id]);
    const adsDeleted = adsResult[0]?.total || 0;

    // Register deletion in audit log BEFORE deleting
    await query(`
      INSERT INTO account_deletion_requests (user_id, email, full_name, reason, ads_deleted)
      VALUES (?, ?, ?, ?, ?)
    `, [user.id, email, full_name, reason, adsDeleted]);

    // Hard delete — cascade removes ads, billings, metrics, notifications, fcm_tokens
    await query('DELETE FROM profiles WHERE id = ?', [user.id]);

    return NextResponse.json({ success: true, message: 'Cuenta eliminada correctamente.' });

  } catch (error) {
    console.error('Profile DELETE Error:', error);
    return NextResponse.json({ error: 'Error al eliminar la cuenta' }, { status: 500 });
  }
}

/**
 * PUT: Update profile information
 */
export async function PUT(req) {
  if (process.env.BUILD_MODE) return new Response(JSON.stringify({ build: true }), { status: 200, headers: { 'Content-Type': 'application/json' } });
  try {
    const user = await getUniversalSession(req);
    
    if (!user) {
      return NextResponse.json({ error: 'No autorizado' }, { status: 401 });
    }

    const body = await req.json();
    const { full_name, business_name, phone, bio, website, banner_url, social_links } = body;

    await query(`
      UPDATE profiles 
      SET 
        full_name = COALESCE(?, full_name),
        business_name = COALESCE(?, business_name),
        phone = COALESCE(?, phone),
        bio = COALESCE(?, bio),
        website = COALESCE(?, website),
        banner_url = COALESCE(?, banner_url),
        social_links = COALESCE(?, social_links)
      WHERE id = ?
    `, [full_name, business_name, phone, bio, website, banner_url, social_links, user.id]);

    return NextResponse.json({ 
      success: true, 
      message: 'Perfil actualizado correctamente'
    });

  } catch (error) {
    console.error('Profile API PUT Error:', error);
    return NextResponse.json({ error: 'Error al actualizar el perfil' }, { status: 500 });
  }
}

