/**
 * KLICUS Home Page
 * Server Component that fetches live ads and categories from MySQL 
 * and passes them to the interactive Marketplace orchestrator.
 */

import { query } from '@/lib/db';
import Navigation from '@/components/Navigation';
import Marketplace from '@/components/Marketplace';

export default async function HomePage() {
  /**
   * Data Fetching (Server Side)
   * Fetches only 'active' ads joined with category metadata.
   */
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
      <Navigation />
      <main>
        {/* Marketplace UI Orchestrator */}
        <Marketplace initialAds={ads} categories={categories} />
      </main>

      {/* Global Footer */}
      <footer style={{ 
        padding: '4rem 0', 
        borderTop: '1px solid var(--border)', 
        background: 'var(--muted)',
        marginTop: '4rem'
      }}>
        <div className="container" style={{ textAlign: 'center' }}>
          <h2 style={{ color: 'var(--primary)', marginBottom: '1rem' }}>KLICUS</h2>
          <p style={{ color: 'var(--muted-foreground)', maxWidth: '400px', margin: '0 auto' }}>
            Transformando la publicidad local con tecnología y diseño de alta gama.
          </p>
          <div style={{ marginTop: '2rem', fontSize: '0.875rem', color: 'var(--muted-foreground)' }}>
            © 2026 KLICUS Marketplace. Todos los derechos reservados.
          </div>
        </div>
      </footer>
    </>
  );
}
