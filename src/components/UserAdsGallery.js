'use client';

/**
 * KLICUS User Ads Gallery
 * Displays a filtered grid of advertisements belonging to a specific profile.
 */

import AdCard from './AdCard';

export default function UserAdsGallery({ ads }) {
  return (
    <div className="container" style={{ paddingBottom: '5rem' }}>
      {/* Gallery Header with Counter */}
      <div style={{ 
        display: 'flex', 
        alignItems: 'center', 
        gap: '0.75rem', 
        marginBottom: '2rem',
        borderBottom: '1px solid var(--border)',
        paddingBottom: '1rem'
      }}>
        <h2 style={{ fontSize: '1.25rem' }}>Publicaciones</h2>
        <span style={{ 
          background: 'var(--muted)', 
          padding: '2px 8px', 
          borderRadius: 'var(--radius-full)', 
          fontSize: '0.875rem',
          fontWeight: '600'
        }}>
          {ads.length}
        </span>
      </div>

      {/* Grid of User's Ads */}
      {ads.length > 0 ? (
        <div style={{ 
          display: 'grid', 
          gridTemplateColumns: 'repeat(auto-fill, minmax(300px, 1fr))', 
          gap: '1.5rem' 
        }}>
          {ads.map((ad) => (
            <AdCard key={ad.id} ad={ad} />
          ))}
        </div>
      ) : (
        /* Empty State logic */
        <div style={{ 
          textAlign: 'center', 
          padding: '4rem', 
          background: 'var(--muted)', 
          borderRadius: 'var(--radius-lg)',
          color: 'var(--muted-foreground)'
        }}>
          Este usuario aún no tiene pautas activas.
        </div>
      )}
    </div>
  );
}
