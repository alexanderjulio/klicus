export const dynamic = 'force-dynamic';
import { query } from '@/lib/db';
import { NextResponse } from 'next/server';

export async function GET() {
  if (process.env.BUILD_MODE) return new Response(JSON.stringify({ build: true }), { status: 200, headers: { 'Content-Type': 'application/json' } });
  try {
    const categories = await query('SELECT id, name, slug FROM categories WHERE active = TRUE ORDER BY name ASC');
    return NextResponse.json({ success: true, categories });
  } catch (error) {
    console.error('Categories API Error:', error);
    return NextResponse.json({ success: false, categories: [] }, { status: 500 });
  }
}
