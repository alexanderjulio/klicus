/**
 * KLICUS Admin Pending Ads Review
 * Server Component for administrators to manage new advertisement submissions.
 * Fetches all ads with 'pending' status for review and approval.
 */

import { query } from '@/lib/db';
import { Check, X, Eye, Clock } from 'lucide-react';
import Navigation from '@/components/Navigation';

export default async function AdminPendingAds() {
  /**
   * Fetches pending ads joined with owner and category details for full context.
   */
  const pendingAds = await query(`
    SELECT a.*, p.business_name, p.full_name, c.name as category_name 
    FROM advertisements a
    JOIN profiles p ON a.owner_id = p.id
    LEFT JOIN categories c ON a.category_id = c.id
    WHERE a.status = 'pending'
    ORDER BY a.created_at DESC
  `);

  return (
    <>
      <Navigation />
      <div className="container" style={{ paddingTop: '100px', paddingBottom: '4rem' }}>
        <header style={{ marginBottom: '2.5rem' }}>
          <h1 style={{ fontSize: '2rem' }}>Pautas Pendientes de Aprobación</h1>
          <p style={{ color: 'var(--muted-foreground)' }}>Revisa y activa los anuncios nuevos en la plataforma.</p>
        </header>

        {pendingAds.length > 0 ? (
          <div style={{ display: 'grid', gap: '1.5rem' }}>
            {pendingAds.map((ad) => (
              /* Individual Review Row */
              <div key={ad.id} className="glass" style={{
                padding: '1.5rem',
                borderRadius: 'var(--radius-lg)',
                display: 'flex',
                alignItems: 'center',
                gap: '2rem',
                flexWrap: 'wrap'
              }}>
                {/* Visual Preview */}
                <div style={{ width: '120px', height: '80px', background: 'var(--muted)', borderRadius: 'var(--radius)', overflow: 'hidden' }}>
                  {ad.image_urls && JSON.parse(ad.image_urls)[0] ? (
                     <img src={JSON.parse(ad.image_urls)[0]} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
                  ) : 'No image'}
                </div>

                {/* Ad Content Summary */}
                <div style={{ flex: 1 }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem', marginBottom: '0.25rem' }}>
                    <h3 style={{ margin: 0 }}>{ad.title}</h3>
                    <span style={{ 
                      fontSize: '0.7rem', 
                      background: 'var(--primary)', 
                      color: 'white', 
                      padding: '2px 8px', 
                      borderRadius: 'var(--radius-full)' 
                    }}>
                      {ad.priority_level.toUpperCase()}
                    </span>
                  </div>
                  <p style={{ fontSize: '0.875rem', color: 'var(--muted-foreground)', marginBottom: '0.5rem' }}>
                    Por: <strong>{ad.business_name || ad.full_name}</strong> • Cat: {ad.category_name}
                  </p>
                  <div style={{ display: 'flex', gap: '1rem', fontSize: '0.75rem', color: 'var(--muted-foreground)' }}>
                    <span>📍 {ad.location}</span>
                    <span>💰 {ad.price_range}</span>
                    <span><Clock size={12} /> {new Date(ad.created_at).toLocaleDateString()}</span>
                  </div>
                </div>

                {/* Administrative Actions */}
                <div style={{ display: 'flex', gap: '1rem' }}>
                   <button 
                    style={{ 
                      padding: '0.5rem 1rem', 
                      borderRadius: 'var(--radius)', 
                      border: '1px solid var(--border)',
                      display: 'flex',
                      alignItems: 'center',
                      gap: '0.5rem',
                      fontWeight: '600'
                    }}
                  >
                    <Eye size={18} /> Ver
                  </button>
                  <button 
                    style={{ 
                      padding: '0.5rem 1rem', 
                      borderRadius: 'var(--radius)', 
                      background: '#10b981', 
                      color: 'white',
                      display: 'flex',
                      alignItems: 'center',
                      gap: '0.5rem',
                      fontWeight: '600'
                    }}
                  >
                    <Check size={18} /> Aprobar
                  </button>
                  <button 
                    style={{ 
                      padding: '0.5rem 1rem', 
                      borderRadius: 'var(--radius)', 
                      background: '#ef4444', 
                      color: 'white',
                      display: 'flex',
                      alignItems: 'center',
                      gap: '0.5rem',
                      fontWeight: '600'
                    }}
                  >
                    <X size={18} /> Rechazar
                  </button>
                </div>
              </div>
            ))}
          </div>
        ) : (
          <div style={{ textAlign: 'center', padding: '5rem', background: 'var(--muted)', borderRadius: 'var(--radius-lg)' }}>
            <p style={{ color: 'var(--muted-foreground)' }}>No hay pautas pendientes por ahora.</p>
          </div>
        )}
      </div>
    </>
  );
}
