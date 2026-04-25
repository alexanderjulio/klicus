/**
 * KLICUS Public Profile Page
 * Dynamic route that renders a specific professional or business profile.
 * Fetches profile metadata and all associated advertisements.
 */

import { query } from '@/lib/db';
import Navigation from '@/components/Navigation';
import ProfileHeader from '@/components/ProfileHeader';
import UserAdsGallery from '@/components/UserAdsGallery';
import { notFound } from 'next/navigation';

export const dynamic = "force-dynamic";

/**
 * Generates dynamic SEO metadata for each professional profile.
 */
export async function generateMetadata({ params }) {
  const { id } = await params;
  const profiles = await query('SELECT business_name, full_name FROM profiles WHERE id = ?', [id]);
  const profile = profiles[0];
  
  if (!profile) return { title: 'Perfil no encontrado' };

  return {
    title: `${profile.business_name || profile.full_name} | KLICUS`,
    description: `Descubre los servicios y pautas de ${profile.business_name || profile.full_name} en KLICUS.`
  };
}

export default async function ProfilePage({ params }) {
  const { id } = await params;
  
  /**
   * Data Fetching (Server Side)
   */
  // 1. Fetch main profile identity
  const profiles = await query('SELECT * FROM profiles WHERE id = ?', [id]);
  const profile = profiles[0];

  if (!profile) {
    notFound();
  }

  // 2. Fetch all active advertisements for this specific owner
  const ads = await query(`
    SELECT a.*, c.name as category_name 
    FROM advertisements a
    LEFT JOIN categories c ON a.category_id = c.id
    WHERE a.owner_id = ? AND a.status = 'active'
  `, [id]);

  return (
    <>
      <Navigation />
      <main className="fade-in" style={{ paddingTop: '64px' }}>
        {/* Profile Identity Component */}
        <ProfileHeader profile={profile} />
        {/* Filtered Ads Gallery component */}
        <UserAdsGallery ads={ads} />
      </main>

      {/* Profile Footer */}
      <footer style={{ 
        padding: '3rem 0', 
        borderTop: '1px solid var(--border)', 
        background: 'var(--muted)',
        marginTop: '2rem'
      }}>
        <div className="container" style={{ textAlign: 'center', fontSize: '0.875rem', color: 'var(--muted-foreground)' }}>
          KLICUS Marketplace • Conectando profesionales
        </div>
      </footer>
    </>
  );
}
