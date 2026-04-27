/**
 * KLICUS Home Page
 * Server Component that fetches live ads and categories from MySQL 
 * and passes them to the interactive Marketplace orchestrator.
 */

import { query } from '@/lib/db';
import Marketplace from '@/components/Marketplace';

export const dynamic = "force-dynamic";

export default async function HomePage({ searchParams }) {
  const params = await searchParams;
  const initialCategory = params.category || 'all';

  let ads = [];
  let categories = [];

  try {
    [ads, categories] = await Promise.all([
      query(`
        SELECT a.*, c.slug as category_slug, c.name as category_name
        FROM advertisements a
        LEFT JOIN categories c ON a.category_id = c.id
        WHERE a.status = 'active'
        ORDER BY
          CASE
            WHEN a.priority_level = 'diamond' THEN 1
            WHEN a.priority_level = 'pro' THEN 2
            ELSE 3
          END ASC,
          a.created_at DESC
        LIMIT 200
      `),
      query('SELECT * FROM categories WHERE active = TRUE'),
    ]);
  } catch (err) {
    console.error('[HomePage] DB fetch failed, rendering empty marketplace:', err.code || err.message);
  }

  return (
    <>
      <main className="min-h-screen">
        <Marketplace initialAds={ads} categories={categories} initialCategory={initialCategory} />
      </main>
    </>
  );
}
