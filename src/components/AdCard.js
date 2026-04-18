/**
 * KLICUS Ad Card Component
 * Displays individual advertisement details with dynamic styling based on priority tiers.
 * Enhanced with premium Diamante effects and navigation links.
 * @version 1.1.0-revalidate
 */

'use client';

import { MapPin, Tag, ExternalLink, Crown, Sparkles, BadgeCheck } from 'lucide-react';
import Link from 'next/link';
import { Card } from './ui/Card';
import Button from './ui/Button';
import Image from 'next/image';
import { cn } from '@/lib/utils';
import { motion } from 'framer-motion';
import { AdTracker, trackClick } from './AdTracker';

export default function AdCard({ ad }) {
  const isDiamond = ad.priority_level === 'diamond';
  const isPro = ad.priority_level === 'pro';

  // High-fidelity image mapping based on category
  const categoryImages = {
    'gastronomia': 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&q=80&w=800',
    'salud': 'https://images.unsplash.com/photo-1505751172157-c728583b71fb?auto=format&fit=crop&q=80&w=800',
    'tecnologia': 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&q=80&w=800',
    'moda': 'https://images.unsplash.com/photo-1445205170230-053b830c6050?auto=format&fit=crop&q=80&w=800',
    'servicios': 'https://images.unsplash.com/photo-1454165833767-02a9eb41a773?auto=format&fit=crop&q=80&w=800',
  };

  const adBaseImage = ad.image_urls ? JSON.parse(ad.image_urls)[0] : null;
  const adImage = adBaseImage || categoryImages[ad.category_slug] || 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&q=80&w=800';

  return (
    <Link 
      href={`/anuncio/${ad.id}`} 
      onClick={() => trackClick(ad.id)}
      className="block h-full"
    >
      <motion.div
        layout
        initial={{ opacity: 0, y: 10 }}
        animate={{ opacity: 1, y: 0 }}
        whileHover={{ y: -8, transition: { duration: 0.3, ease: "easeOut" } }}
        className={cn(
          "relative h-full bg-[#FBFBFC] rounded-[2.5rem] transition-all duration-500 group overflow-hidden flex flex-col",
          "border border-slate-200/60 shadow-sm hover:shadow-2xl hover:shadow-slate-400/20",
          isDiamond && "border-white/40 shadow-xl shadow-slate-200/50 backdrop-blur-sm"
        )}
      >
        {/* Diamond Shine Animation */}
        {isDiamond && (
          <motion.div
            initial={{ left: '-100%' }}
            animate={{ left: '200%' }}
            transition={{ duration: 3, repeat: Infinity, repeatDelay: 4, ease: "linear" }}
            className="absolute top-0 w-1/2 h-full bg-gradient-to-r from-transparent via-white/20 to-transparent skew-x-[-20deg] z-10 pointer-events-none"
          />
        )}

        {/* Ad Image Container */}
        <div className="relative h-56 overflow-hidden bg-gray-100 group">
          <Image 
            src={adImage} 
            alt={ad.title}
            fill
            className="object-cover transition-transform duration-700 group-hover:scale-110"
            unoptimized={true}
          />
          
          {/* Status Badges */}
          <div className="absolute top-4 left-4 flex flex-col gap-2 z-20">
            {isDiamond && (
              <motion.div 
                initial={{ x: -20, opacity: 0 }} animate={{ x: 0, opacity: 1 }}
                className="bg-secondary/90 text-primary px-4 py-2 rounded-2xl text-[10px] font-black uppercase tracking-widest flex items-center gap-2 shadow-2xl backdrop-blur-xl border border-primary/20"
              >
                <Crown size={12} fill="currentColor" />
                Premium Diamante
              </motion.div>
            )}
            {isPro && (
              <div className="bg-blue-600/90 text-white px-4 py-2 rounded-2xl text-[10px] font-black uppercase tracking-widest flex items-center gap-2 shadow-xl backdrop-blur-lg border border-white/10">
                <Sparkles size={12} fill="currentColor" />
                Anuncio Pro
              </div>
            )}
          </div>

          <div className="absolute top-4 right-4 z-20">
             <button onClick={(e) => { e.preventDefault(); }} className="w-10 h-10 rounded-full bg-slate-100/60 backdrop-blur-md flex items-center justify-center text-secondary/40 hover:text-red-500 transition-all hover:scale-110 border border-white/50 shadow-lg">
               <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" /></svg>
             </button>
          </div>
        </div>

        {/* Ad Content */}
        <div className="p-7 flex-1 flex flex-col relative z-20">
          <div className="flex items-center gap-2 mb-3">
             <span className="text-[10px] font-black uppercase tracking-widest text-muted-foreground/60">{ad.category_name || 'Servicio'}</span>
             {isDiamond && <span className="w-1.5 h-1.5 rounded-full bg-primary shadow-[0_0_8px_rgba(255,235,59,0.5)]" />}
             {isDiamond && <span className="text-[10px] font-black uppercase tracking-widest text-primary">Destacado</span>}
          </div>

          <h3 className="text-xl font-black text-secondary line-clamp-2 leading-[1.1] mb-2 group-hover:text-primary transition-colors tracking-tight">
            {ad.title}
          </h3>

          <div className="mt-2 text-3xl font-black text-secondary tracking-tighter">
             {ad.price_range}
          </div>

          <div className="mt-4 flex items-center gap-1.5 text-[11px] text-green-600 font-extrabold uppercase tracking-widest">
            {ad.priority_level === 'diamond' ? <BadgeCheck className="w-3.5 h-3.5" /> : null}
            Llega gratis hoy <span className="text-[10px] font-bold lowercase text-gray-400 italic ml-1 opacity-60">en {ad.location.split(',')[0]}</span>
          </div>

          <p className="mt-5 text-[13px] text-muted-foreground/80 line-clamp-3 leading-relaxed font-medium">
            {ad.description}
          </p>

          <div className="mt-auto pt-6 flex items-center justify-between">
            <div className="flex items-center gap-2.5 text-xs font-bold text-secondary/60">
              <div className="w-9 h-9 rounded-full bg-slate-100 flex items-center justify-center border border-slate-200">
                <MapPin size={14} className="text-primary" />
              </div>
              <span className="line-clamp-1">{ad.location.split(',')[0]}</span>
            </div>
            
            <div className="w-11 h-11 rounded-[1.25rem] bg-secondary text-white flex items-center justify-center transition-all group-hover:bg-primary group-hover:text-secondary shadow-lg">
              <ExternalLink size={18} />
            </div>
          </div>
        </div>
        
        {/* Diamond Glow Base */}
        {isDiamond && (
          <div className="absolute bottom-0 left-0 w-full h-[2px] bg-gradient-to-r from-transparent via-primary to-transparent opacity-60" />
        )}
      </motion.div>
    </Link>
  );
}
