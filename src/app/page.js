/**
 * KLICUS Home Page
 * Server Component that fetches live ads and categories from MySQL 
 * and passes them to the interactive Marketplace orchestrator.
 */

import { query } from '@/lib/db';
import Marketplace from '@/components/Marketplace';

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

      {/* Global Footer */}
      <footer className="py-20 bg-secondary text-white mt-20">
        <div className="container grid grid-cols-1 md:grid-cols-3 gap-12">
          <div className="text-center md:text-left">
            <h2 className="text-primary text-3xl font-black mb-4 tracking-tighter italic">KLICUS</h2>
            <p className="text-white/70 max-w-sm leading-relaxed text-sm">
              Conectando lo mejor de tu región con un diseño premium y tecnología de vanguardia.
            </p>
          </div>
          
          <div className="text-center">
            <h4 className="font-bold mb-4 uppercase text-xs tracking-widest text-primary">Navegación</h4>
            <ul className="space-y-2 text-sm text-white/60">
              <li><a href="#" className="hover:text-white transition-colors">Acerca de nosotros</a></li>
              <li><a href="#" className="hover:text-white transition-colors">Cómo publicar</a></li>
              <li><a href="#" className="hover:text-white transition-colors">Términos y condiciones</a></li>
            </ul>
          </div>

          <div className="text-center md:text-right text-sm text-white/40">
            <p>© 2026 KLICUS Marketplace.</p>
            <p>Todos los derechos reservados.</p>
          </div>
        </div>
      </footer>
    </>
  );
}
