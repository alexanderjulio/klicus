export const dynamic = 'force-dynamic';
/**
 * KLICUS Public Marketplace API
 * Serves the active advertisements feed for Web and Flutter.
 * Supports filtering by category, search term, and city.
 */

import { query } from '@/lib/db';
import { apiResponse, ApiError } from '@/lib/api-utils';

const MAX_LIMIT = 50;

export async function GET(req) {
  if (process.env.BUILD_MODE) return new Response(JSON.stringify({ build: true }), { status: 200, headers: { 'Content-Type': 'application/json' } });
  try {
    const { searchParams } = new URL(req.url);
    const category = searchParams.get('category') || 'all';
    const city = searchParams.get('city') || 'all';
    const search = searchParams.get('search') || '';
    const page = Math.max(1, parseInt(searchParams.get('page') || '1'));
    const limit = Math.min(MAX_LIMIT, Math.max(1, parseInt(searchParams.get('limit') || '20')));
    const offset = (page - 1) * limit;

    // Build WHERE clause shared by data query and count query
    let where = `WHERE a.status = 'active'`;
    const params = [];

    if (category !== 'all') {
      where += ` AND c.slug = ?`;
      params.push(category);
    }

    if (city !== 'all') {
      where += ` AND a.location LIKE ?`;
      params.push(`${city}%`);
    }

    if (search) {
      where += ` AND (a.title LIKE ? OR a.description LIKE ?)`;
      params.push(`%${search}%`, `%${search}%`);
    }

    const ORDER = `ORDER BY
      CASE
        WHEN a.priority_level = 'diamond' THEN 1
        WHEN a.priority_level = 'pro' THEN 2
        ELSE 3
      END ASC,
      a.created_at DESC`;

    const [ads, [countRow]] = await Promise.all([
      query(
        `SELECT a.*, c.slug as category_slug, c.name as category_name
         FROM advertisements a
         LEFT JOIN categories c ON a.category_id = c.id
         ${where} ${ORDER} LIMIT ? OFFSET ?`,
        [...params, limit, offset]
      ),
      query(
        `SELECT COUNT(*) as total
         FROM advertisements a
         LEFT JOIN categories c ON a.category_id = c.id
         ${where}`,
        params
      ),
    ]);

    const total = countRow?.total ?? 0;
    const formattedAds = ads.map(ad => ({
      ...ad,
      image_urls: typeof ad.image_urls === 'string' ? JSON.parse(ad.image_urls) : (ad.image_urls || [])
    }));

    return apiResponse({
      data: {
        ads: formattedAds,
        pagination: { total, page, limit, totalPages: Math.ceil(total / limit), hasMore: offset + ads.length < total },
      }
    });

  } catch (error) {
    console.error('Marketplace API GET Error:', error);
    return ApiError.serverError();
  }
}

