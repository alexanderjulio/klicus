export const dynamic = 'force-dynamic';
import { query } from '@/lib/db';
import { NextResponse } from 'next/server';

/**
 * Public API to fetch active banners for the Home Screen
 */
export async function GET() {
  if (process.env.BUILD_MODE) return new Response(JSON.stringify({ build: true }), { status: 200, headers: { 'Content-Type': 'application/json' } });
  try {
    const banners = await query(
      "SELECT id, title, subtitle, image_url, cta_text, cta_link FROM banners WHERE is_active = 1 AND (type = 'carousel' OR type IS NULL) ORDER BY position ASC, created_at DESC"
    );
    
    return NextResponse.json({ success: true, data: banners });
  } catch (error) {
    console.error('Banners Fetch Error:', error);
    return NextResponse.json({ success: false, error: 'Error al cargar banners' }, { status: 500 });
  }
}

