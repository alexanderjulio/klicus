export const dynamic = 'force-dynamic';
import { query } from '@/lib/db';
import { NextResponse } from 'next/server';

async function ensureTypeColumn() {
  try {
    await query("ALTER TABLE banners ADD COLUMN type VARCHAR(20) NOT NULL DEFAULT 'carousel'");
  } catch (e) {
    if (e.errno !== 1060) throw e;
  }
}

/**
 * Public API — returns the active interstitial (if any).
 * Ensures the `type` column exists before querying.
 */
export async function GET() {
  if (process.env.BUILD_MODE) return new Response(JSON.stringify({ build: true }), { status: 200, headers: { 'Content-Type': 'application/json' } });
  try {
    // Ensure column exists (idempotent migration)
    await ensureTypeColumn();

    const rows = await query(
      "SELECT id, image_url, cta_link FROM banners WHERE type = 'interstitial' AND is_active = 1 ORDER BY created_at DESC LIMIT 1"
    );

    if (!rows.length) return NextResponse.json({ success: true, data: null });
    return NextResponse.json({ success: true, data: rows[0] });
  } catch (error) {
    return NextResponse.json({ success: false, error: 'Error al cargar intersticial' }, { status: 500 });
  }
}
