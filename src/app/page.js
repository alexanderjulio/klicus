/**
 * KLICUS Home Page
 * Server Component that fetches live ads and categories from MySQL 
 * and passes them to the interactive Marketplace orchestrator.
 */

import { query } from '@/lib/db';
import Marketplace from '@/components/Marketplace';

export const dynamic = "force-dynamic";

export default async function HomePage({ searchParams }) {
  /**
   * Data Fetching (Server Side)
   * Captures the initial category from URL if present.
   */
  const params = await searchParams;
  const initialCategory = params.category || 'all';

  const ads = await query(`
    SELECT a.*, c.slug as category_slug, c.name as category_name 
    FROM advertisements a
    LEFT JOIN categories c ON a.category_id = c.id
    WHERE a.status = 'active'
  `);

  // Fetch only active categories for the filter bar
  const categories = await query('SELECT * FROM categories WHERE active = TRUE');

  return (
    <>
      <main className="min-h-screen">
        {/* Marketplace UI Orchestrator */}
        <Marketplace initialAds={ads} categories={categories} initialCategory={initialCategory} />
      </main>
    </>
  );
}
