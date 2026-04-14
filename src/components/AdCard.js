'use client';

/**
 * KLICUS Ad Card Component
 * Displays individual advertisement details with dynamic styling based on priority tiers.
 */

import { MapPin, Tag, ExternalLink } from 'lucide-react';

export default function AdCard({ ad }) {
  // Logic to determine priority status for styling
  const isDiamond = ad.priority_level === 'diamond';
  const isPro = ad.priority_level === 'pro';

  return (
    <div className={`ad-card ${isDiamond ? 'diamond' : ''} ${isPro ? 'pro' : ''}`} style={{
      background: 'var(--card)',
      borderRadius: 'var(--radius-lg)',
      // Priority diamond ads get a gold border and larger shadow
      border: isDiamond ? '2px solid var(--accent)' : '1px solid var(--border)',
      padding: isDiamond ? '2rem' : '1.25rem',
      position: 'relative',
      transition: 'transform var(--duration-fast), box-shadow var(--duration-fast)',
      boxShadow: isDiamond ? 'var(--shadow-xl)' : 'var(--shadow)',
      // Layout: Diamond ads span 2 columns on desktop
      gridColumn: isDiamond ? 'span 2' : 'span 1',
      display: 'flex',
      flexDirection: 'column',
      gap: '1rem',
      overflow: 'hidden'
    }}>
      {/* Priority Badge */}
      {isDiamond && (
        <span style={{
          position: 'absolute',
          top: '1rem',
          right: '1rem',
          background: 'var(--accent)',
          color: 'white',
          padding: '4px 12px',
          borderRadius: 'var(--radius-full)',
          fontSize: '0.75rem',
          fontWeight: '800',
          letterSpacing: '0.05em'
        }}>
          💎 DIAMANTE
        </span>
      )}

      {/* Main Ad Image Placeholder */}
      <div style={{
        height: isDiamond ? '280px' : '180px',
        background: 'var(--muted)',
        borderRadius: 'var(--radius)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        fontSize: '3rem'
      }}>
        🏢
      </div>

      <div style={{ flex: 1 }}>
        <h3 style={{ 
          fontSize: isDiamond ? '1.75rem' : '1.25rem', 
          marginBottom: '0.5rem',
          color: isDiamond ? 'var(--primary)' : 'inherit'
        }}>
          {ad.title}
        </h3>
        <p style={{ 
          color: 'var(--muted-foreground)', 
          fontSize: isDiamond ? '1.1rem' : '0.9rem',
          lineHeight: '1.4',
          marginBottom: '1rem'
        }}>
          {ad.description}
        </p>

        {/* Location & Pricing Info */}
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: '0.75rem', fontSize: '0.875rem' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '0.25rem', color: 'var(--muted-foreground)' }}>
            <MapPin size={14} /> {ad.location}
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: '0.25rem', color: 'var(--primary)', fontWeight: '600' }}>
            <Tag size={14} /> {ad.price_range}
          </div>
        </div>
      </div>

      {/* Action Footer */}
      <div style={{ 
        marginTop: 'auto', 
        paddingTop: '1rem', 
        borderTop: '1px solid var(--border)',
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center'
      }}>
        <button style={{ color: 'var(--muted-foreground)', fontWeight: '600', fontSize: '0.875rem' }}>
          Ver detalles
        </button>
        <button className="btn-primary" style={{ padding: '0.5rem 1rem', fontSize: '0.875rem' }}>
          Contactar <ExternalLink size={14} />
        </button>
      </div>

      <style jsx>{`
        .ad-card:hover {
          transform: translateY(-4px);
          box-shadow: var(--shadow-lg);
        }
        @media (max-width: 768px) {
          .ad-card.diamond {
            grid-column: span 1;
            padding: 1.25rem;
          }
        }
      `}</style>
    </div>
  );
}
