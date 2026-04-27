export const dynamic = 'force-dynamic';
/**
 * KLICUS Public Marketplace API
 * Serves the active advertisements feed for Web and Flutter.
 * Supports filtering by category, search term, and city.
 */

import { query } from '@/lib/db';
import { apiResponse, ApiError } from '@/lib/api-utils';

export async function GET(req) {
  try {
    const { searchParams } = new URL(req.url);
    const category = searchParams.get('category') || 'all';
    const city = searchParams.get('city') || 'all';
    const search = searchParams.get('search') || '';

    // Build parts of the query dynamically
    let sql = `
      SELECT a.*, c.slug as category_slug, c.name as category_name 
      FROM advertisements a
      LEFT JOIN categories c ON a.category_id = c.id
      WHERE a.status = 'active'
    `;
    const params = [];

    if (category !== 'all') {
      sql += ` AND c.slug = ?`;
      params.push(category);
    }

    if (city !== 'all') {
      sql += ` AND a.location LIKE ?`;
      params.push(`${city}%`);
    }

    if (search) {
      sql += ` AND (a.title LIKE ? OR a.description LIKE ?)`;
      params.push(`%${search}%`, `%${search}%`);
    }

    // Default sorting: Priority first, then newest
    sql += ` ORDER BY 
      CASE 
        WHEN a.priority_level = 'diamond' THEN 1 
        WHEN a.priority_level = 'pro' THEN 2 
        ELSE 3 
      END ASC, 
      a.created_at DESC`;

    const ads = await query(sql, params);

    // Format results (ensure proper images parsing)
    const formattedAds = ads.map(ad => ({
      ...ad,
      image_urls: typeof ad.image_urls === 'string' ? JSON.parse(ad.image_urls) : (ad.image_urls || [])
    }));

    return apiResponse({ data: { ads: formattedAds } });

  } catch (error) {
    console.error('Marketplace API GET Error:', error);
    return ApiError.serverError();
  }
}

