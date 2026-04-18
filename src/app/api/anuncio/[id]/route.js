import { query } from '@/lib/db';
import { NextResponse } from 'next/server';

export async function GET(request, { params }) {
  const { id } = await params;

  try {
    const results = await query(`
      SELECT 
        a.*, 
        c.name as category_name, 
        c.slug as category_slug,
        p.business_name,
        p.full_name as owner_name,
        p.avatar_url,
        p.social_links
      FROM advertisements a
      LEFT JOIN categories c ON a.category_id = c.id
      LEFT JOIN profiles p ON a.owner_id = p.id
      WHERE a.id = ?
    `, [id]);

    if (results.length === 0) {
      return NextResponse.json({ error: 'Anuncio no encontrado' }, { status: 404 });
    }

    // Process JSON fields
    const ad = {
      ...results[0],
      image_urls: results[0].image_urls ? JSON.parse(results[0].image_urls) : [],
      social_links: results[0].social_links ? JSON.parse(results[0].social_links) : {},
    };

    return NextResponse.json(ad);
  } catch (error) {
    console.error('Error fetching ad detail:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}
