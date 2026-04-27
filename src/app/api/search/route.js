import { query } from '@/lib/db';
import { NextResponse } from 'next/server';

export const dynamic = 'force-dynamic';

export async function GET(req) {
  if (process.env.BUILD_MODE) return new Response(JSON.stringify({ build: true }), { status: 200, headers: { 'Content-Type': 'application/json' } });
  try {
    const { searchParams } = new URL(req.url);
    const q = searchParams.get('q');
    const category = searchParams.get('category');
    const city = searchParams.get('city');
    const type = searchParams.get('type'); // 'full' or 'suggestions'
    const limit = parseInt(searchParams.get('limit')) || (type === 'suggestions' ? 8 : 40);

    let sql = `
      SELECT a.id, a.title, a.priority_level, a.status, a.category_id, a.owner_id,
             c.name as category_name, c.slug as category_slug
    `;

    if (type !== 'suggestions') {
      sql += `, a.description, a.image_urls, a.location, a.price_range, p.full_name as owner_name`;
    } else {
      sql += `, a.image_urls`; 
    }

    sql += `
      FROM advertisements a
      JOIN profiles p ON a.owner_id = p.id
      JOIN categories c ON a.category_id = c.id
      WHERE a.status = 'active'
    `;

    const params = [];

    if (q) {
      sql += ` AND (a.title LIKE ? OR a.description LIKE ?)`;
      params.push(`%${q}%`, `%${q}%`);
    }

    if (category) {
      sql += ` AND c.slug = ?`;
      params.push(category);
    }

    // New City Filter
    if (city && city !== 'Todas') {
      sql += ` AND (a.location LIKE ? OR a.title LIKE ?)`;
      params.push(`%${city}%`, `%${city}%`);
    }

    // Sort by priority (Diamond -> Pro -> Basic)
    sql += ` ORDER BY CASE 
      WHEN a.priority_level = 'diamond' THEN 1 
      WHEN a.priority_level = 'pro' THEN 2 
      ELSE 3 
    END ASC, a.created_at DESC LIMIT ?`;
    
    params.push(limit);

    const ads = await query(sql, params);
    
    return NextResponse.json({ ads });
  } catch (error) {
    console.error('Search API Error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}
