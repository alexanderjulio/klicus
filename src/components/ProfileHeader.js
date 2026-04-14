'use client';

/**
 * KLICUS Profile Header
 * High-fidelity social-media style header for professional and business accounts.
 * Features banner, avatar, verification status, and contact actions.
 */

import { Share2, MessageCircle, Globe, Instagram, Facebook, ShieldCheck } from 'lucide-react';

export default function ProfileHeader({ profile }) {
  return (
    <div style={{ position: 'relative', marginBottom: '4rem' }}>
      {/* Brand Banner with Gradient Placeholder */}
      <div style={{
        height: '250px',
        width: '100%',
        background: profile.banner_url || 'linear-gradient(135deg, var(--primary) 0%, #00d2ff 100%)',
        borderRadius: '0 0 var(--radius-lg) var(--radius-lg)',
        position: 'relative'
      }}>
        {/* Verification Status Badge */}
        <div style={{
          position: 'absolute',
          bottom: '1rem',
          right: '1.5rem',
          background: 'rgba(255,255,255,0.9)',
          padding: '6px 12px',
          borderRadius: 'var(--radius-full)',
          display: 'flex',
          alignItems: 'center',
          gap: '0.4rem',
          fontSize: '0.8rem',
          fontWeight: '700',
          color: 'var(--primary)',
          backdropFilter: 'blur(4px)'
        }}>
          <ShieldCheck size={16} /> Verificado
        </div>
      </div>

      {/* Profile Avatar & Primary Identity */}
      <div className="container" style={{ position: 'relative', marginTop: '-60px' }}>
        <div style={{ display: 'flex', alignItems: 'flex-end', gap: '1.5rem', marginBottom: '1.5rem' }}>
          <div style={{
            width: '120px',
            height: '120px',
            borderRadius: 'var(--radius-lg)',
            border: '4px solid var(--background)',
            background: 'var(--muted)',
            overflow: 'hidden',
            boxShadow: 'var(--shadow-lg)'
          }}>
            <img 
              src={profile.avatar_url || 'https://api.dicebear.com/7.x/avataaars/svg?seed=Klicus'} 
              alt={profile.full_name} 
              style={{ width: '100%', height: '100%', objectFit: 'cover' }}
            />
          </div>
          
          <div style={{ paddingBottom: '10px', flex: 1 }}>
            <h1 style={{ fontSize: '2rem', marginBottom: '0.25rem' }}>{profile.business_name || profile.full_name}</h1>
            <p style={{ color: 'var(--muted-foreground)', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
               @{profile.id.substring(0, 8)} • {profile.role === 'professional' ? 'Profesional' : 'Comercio'}
            </p>
          </div>

          {/* Social and Contact CTAs */}
          <div style={{ display: 'flex', gap: '0.75rem', paddingBottom: '10px' }}>
            <button className="btn-secondary" style={{ 
              padding: '0.6rem', 
              borderRadius: 'var(--radius)', 
              border: '1px solid var(--border)' 
            }}>
              <Share2 size={20} />
            </button>
            <button className="btn-primary">
              Contactar <MessageCircle size={18} />
            </button>
          </div>
        </div>

        {/* Professional Biography */}
        <div style={{ maxWidth: '700px' }}>
          <p style={{ fontSize: '1.1rem', lineHeight: '1.5',  marginBottom: '1.5rem' }}>
            {profile.bio || 'Bienvenido a mi perfil oficial en KLICUS. Aquí podrás encontrar todos mis servicios y pautas activas.'}
          </p>

          {/* External Social Links */}
          <div style={{ display: 'flex', gap: '1.5rem', flexWrap: 'wrap' }}>
            {profile.website && (
              <a href={profile.website} target="_blank" className="social-link" rel="noreferrer">
                <Globe size={18} /> Sitio Web
              </a>
            )}
            <a href="#" className="social-link"><Instagram size={18} /> Instagram</a>
            <a href="#" className="social-link"><Facebook size={18} /> Facebook</a>
          </div>
        </div>
      </div>

      <style jsx>{`
        .social-link {
          display: flex;
          align-items: center;
          gap: 0.5rem;
          color: var(--primary);
          font-weight: 600;
          font-size: 0.9rem;
        }
      `}</style>
    </div>
  );
}
