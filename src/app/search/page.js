'use client';

import { useState, useEffect, Suspense } from 'react';
import { useSearchParams } from 'next/navigation';
import { Search, Filter, Loader2, MapPin, Tag, MapPinOff, Sparkles, ChevronRight, SlidersHorizontal } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import { cn } from '@/lib/utils';
import { useLocation } from '@/context/LocationContext';
import Link from 'next/link';
import AdCard from '@/components/AdCard';

/**
 * KLICUS Search Results - Elite Upgrade
 * Immersive, high-end search experience with premium card integration.
 */

function SearchResultsContent() {
  const searchParams = useSearchParams();
  const q = searchParams.get('q');
  const { selectedCity } = useLocation();
  
  const [ads, setAds] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function fetchResults() {
      setLoading(true);
      try {
        const cityQuery = selectedCity !== 'Todas' ? `&city=${encodeURIComponent(selectedCity)}` : '';
        const res = await fetch(`/api/search?q=${encodeURIComponent(q || '')}${cityQuery}`);
        const data = await res.json();
        setAds(data.ads || []);
      } catch (error) {
        console.error('Failed to search:', error);
      } finally {
        setLoading(false);
      }
    }
    fetchResults();
  }, [q, selectedCity]);

  return (
    <div className="min-h-screen bg-[#F5F5F7] text-secondary selection:bg-primary/30 pb-32">
      {/* Elite Background Atmosphere */}
      <div className="fixed top-0 left-0 right-0 h-[60vh] bg-gradient-to-b from-primary/10 via-white/50 to-transparent pointer-events-none -z-10" />
      <div className="fixed top-[10vh] right-[-10vw] w-[40vw] h-[40vw] bg-primary/5 rounded-full blur-[120px] pointer-events-none -z-10" />

      <main className="max-w-7xl mx-auto pt-32 md:pt-44 px-6">
        
        {/* Breadcrumbs - Minimalist */}
        <div className="flex items-center gap-2 text-[10px] font-black uppercase tracking-[0.2em] text-secondary/30 mb-10">
          <Link href="/" className="hover:text-secondary transition-colors">Inicio</Link>
          <ChevronRight size={10} />
          <span className="text-secondary opacity-100 italic">Resultados de búsqueda</span>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-12 gap-10 items-start">
          
          {/* SIDEBAR: ELITE FILTERS (3 Cols) */}
          <aside className="lg:col-span-3 space-y-6 sticky top-32">
            <div className="bg-white rounded-[2.5rem] p-8 shadow-2xl shadow-secondary/5 border border-white/60 relative overflow-hidden group">
               <div className="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-primary/20 via-primary to-primary/20 opacity-0 group-hover:opacity-100 transition-opacity" />
               
               <h2 className="text-[10px] font-black uppercase tracking-[0.3em] text-secondary/40 mb-8 flex items-center gap-3">
                 <SlidersHorizontal size={14} strokeWidth={2.5} /> Filtros de Precisión
               </h2>

               <div className="space-y-8">
                 {/* City Context Card */}
                 <div className="relative group/city">
                   <p className="text-[9px] font-black uppercase text-secondary/30 tracking-widest mb-3 px-1">Ubicación Seleccionada</p>
                   <div className="p-4 bg-secondary text-white rounded-[1.5rem] flex items-center justify-between shadow-xl shadow-secondary/20 transition-all group-hover/city:scale-[1.02]">
                     <div className="flex items-center gap-3">
                       <div className="w-8 h-8 rounded-full bg-white/10 flex items-center justify-center">
                         <MapPin size={16} className="text-primary" />
                       </div>
                       <span className="text-sm font-black italic">{selectedCity}</span>
                     </div>
                     <span className="w-2 h-2 rounded-full bg-primary animate-pulse" />
                   </div>
                 </div>

                 {/* Counter Card */}
                 <div className="p-6 rounded-[2rem] bg-white border border-border/40 text-center">
                    <p className="text-[9px] font-black uppercase tracking-widest text-secondary/20 mb-1">Impacto de búsqueda</p>
                    <div className="text-4xl font-black text-secondary italic tracking-tighter">
                      {ads.length}
                    </div>
                    <p className="text-[10px] font-bold text-secondary/40 mt-1">Conexiones encontradas</p>
                 </div>

                 <button 
                  onClick={() => window.location.href = '/'}
                  className="w-full py-4 rounded-2xl bg-[#F5F5F7] text-secondary/60 text-[10px] font-black uppercase tracking-widest hover:bg-white hover:text-secondary hover:shadow-lg transition-all border border-transparent hover:border-border/50"
                 >
                   Reiniciar Búsqueda
                 </button>
               </div>
            </div>

            {/* Premium Badge */}
            <div className="p-8 rounded-[2.5rem] bg-primary/10 border border-primary/20 relative overflow-hidden flex flex-col items-center text-center">
               <Sparkles size={32} className="text-primary mb-4" />
               <p className="text-[9px] font-black uppercase tracking-widest text-secondary mb-2">Potenciado por KLICUS</p>
               <p className="text-xs font-medium text-secondary/60 leading-relaxed italic">
                 Resultados verificados y sincronizados en tiempo real para {selectedCity}.
               </p>
            </div>
          </aside>

          {/* MAIN: ELITE RESULTS (9 Cols) */}
          <main className="lg:col-span-9">
            
            <header className="mb-12">
               <div className="space-y-4">
                 <h1 className="text-5xl md:text-7xl font-black text-secondary tracking-tightest leading-[0.9] italic">
                   {q ? (
                     <>Resultados de <span className="text-primary drop-shadow-sm">"{q}"</span></>
                   ) : (
                     "Explorar Directorio"
                   )}
                 </h1>
                 <div className="flex items-center gap-3">
                    <div className="h-px w-12 bg-primary" />
                    <p className="text-xs font-bold text-secondary/40 uppercase tracking-widest">
                       {ads.length} Oportunidades en {selectedCity}
                    </p>
                 </div>
               </div>
            </header>

            {loading ? (
              <div className="flex flex-col items-center justify-center py-32 bg-white rounded-[3.5rem] border border-white shadow-2xl shadow-secondary/5">
                <Loader2 size={48} className="text-primary animate-spin mb-6" />
                <p className="font-black text-secondary/30 uppercase tracking-[0.3em] text-[10px] italic">Filtrando red comercial...</p>
              </div>
            ) : ads.length > 0 ? (
              <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-8">
                <AnimatePresence mode="popLayout">
                  {ads.map((ad, index) => (
                    <motion.div
                      key={ad.id}
                      initial={{ opacity: 0, y: 20 }}
                      animate={{ opacity: 1, y: 0 }}
                      transition={{ delay: index * 0.05, duration: 0.5 }}
                    >
                      <AdCard ad={ad} />
                    </motion.div>
                  ))}
                </AnimatePresence>
              </div>
            ) : (
              <div className="py-32 text-center bg-white rounded-[3.5rem] border border-white shadow-2xl shadow-secondary/5 px-10">
                <div className="w-24 h-24 rounded-[2.5rem] bg-[#F5F5F7] flex items-center justify-center mx-auto mb-8">
                  <MapPinOff size={40} className="text-secondary/20" />
                </div>
                <h3 className="text-3xl font-black text-secondary italic mb-4 tracking-tight">Sin coincidencias en {selectedCity}</h3>
                <p className="text-sm font-medium text-secondary/50 max-w-sm mx-auto leading-relaxed mb-10 italic">
                  No hemos encontrado resultados exactos para tu búsqueda. Prueba cambiando la ubicación o usa términos más generales.
                </p>
                <Link 
                  href="/"
                  className="inline-flex h-14 items-center px-10 bg-secondary text-white rounded-2xl font-black text-[10px] uppercase tracking-widest hover:bg-primary transition-all shadow-xl shadow-secondary/20 hover:scale-[1.02] active:scale-95"
                >
                  Explorar Todo el Directorio
                </Link>
              </div>
            )}
          </main>
        </div>
      </main>
    </div>
  );
}

export default function SearchPage() {
  return (
    <Suspense fallback={
      <div className="min-h-screen flex items-center justify-center bg-[#F5F5F7]">
        <div className="flex flex-col items-center">
          <Loader2 size={48} className="text-primary animate-spin mb-4" />
          <p className="font-black text-secondary/30 uppercase tracking-widest text-[9px] italic">Iniciando Ecosistema...</p>
        </div>
      </div>
    }>
      <SearchResultsContent />
    </Suspense>
  );
}
