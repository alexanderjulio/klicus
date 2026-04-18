'use client';

/**
 * KLICUS Profile Header
 * High-fidelity social-media style header for professional and business accounts.
 * Features banner, avatar, verification status, and contact actions.
 */

import { Share2, MessageCircle, Globe, ShieldCheck } from 'lucide-react';
import Button from './ui/Button';

export default function ProfileHeader({ profile }) {
  return (
    <div className="relative mb-16">
      {/* Brand Banner with Gradient Placeholder */}
      <div 
        className="h-64 w-full rounded-b-2xl relative shadow-inner overflow-hidden"
        style={{
          background: profile.banner_url || 'linear-gradient(135deg, var(--color-primary) 0%, #00d2ff 100%)'
        }}
      >
        {/* Verification Status Badge */}
        <div className="absolute bottom-4 right-6 bg-white/90 backdrop-blur-md px-3 py-1.5 rounded-full flex items-center gap-1.5 text-xs font-bold text-primary shadow-sm border border-white/20">
          <ShieldCheck size={16} /> Verificado
        </div>
      </div>

      {/* Profile Avatar & Primary Identity */}
      <div className="container relative -mt-16">
        <div className="flex flex-col md:flex-row items-center md:items-end gap-6 mb-6">
          <div className="w-32 h-32 md:w-40 md:h-40 rounded-2xl border-4 border-background bg-muted overflow-hidden shadow-xl shrink-0">
            <img 
              src={profile.avatar_url || 'https://api.dicebear.com/7.x/avataaars/svg?seed=Klicus'} 
              alt={profile.full_name} 
              className="w-full h-full object-cover"
            />
          </div>
          
          <div className="flex-1 text-center md:text-left pb-2">
            <h1 className="text-3xl md:text-5xl font-black tracking-tight mb-2">{profile.business_name || profile.full_name}</h1>
            <p className="text-muted-foreground flex items-center justify-center md:justify-start gap-2 font-medium">
               @{profile.id.substring(0, 8)} • <span className="text-primary/80 uppercase text-xs tracking-widest font-black">{profile.role === 'professional' ? 'Profesional' : 'Comercio'}</span>
            </p>
          </div>

          {/* Social and Contact CTAs */}
          <div className="flex gap-3 pb-2 pt-4 md:pt-0">
            <Button variant="secondary" size="icon" className="rounded-xl shadow-sm">
              <Share2 size={20} />
            </Button>
            <Button className="rounded-xl shadow-md gap-2 px-8">
              Contactar <MessageCircle size={18} />
            </Button>
          </div>
        </div>

        {/* Professional Biography */}
        <div className="max-w-3xl mx-auto md:mx-0">
          <p className="text-lg md:text-xl leading-relaxed mb-8 text-foreground/80">
            {profile.bio || 'Bienvenido a mi perfil oficial en KLICUS. Aquí podrás encontrar todos mis servicios y pautas activas.'}
          </p>

          {/* External Social Links */}
          <div className="flex gap-6 flex-wrap justify-center md:justify-start">
            {profile.website && (
              <a href={profile.website} target="_blank" className="social-link" rel="noreferrer">
                <Globe size={18} /> Sitio Web
              </a>
            )}
            <a href="#" className="social-link group">
              <span className="group-hover:translate-x-1 transition-transform inline-block">Instagram</span>
            </a>
            <a href="#" className="social-link group">
              <span className="group-hover:translate-x-1 transition-transform inline-block">Facebook</span>
            </a>
          </div>
        </div>
      </div>

      <style jsx>{`
        .social-link {
          display: flex;
          align-items: center;
          gap: 0.5rem;
          color: var(--color-primary);
          font-weight: 700;
          font-size: 0.95rem;
          letter-spacing: -0.01em;
        }
      `}</style>
    </div>
  );
}
