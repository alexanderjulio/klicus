'use client';

import { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { ChevronLeft, ChevronRight, Sparkles, Megaphone, TrendingUp } from 'lucide-react';
import { cn } from '@/lib/utils';

const BANNERS = [
  {
    id: 1,
    title: "Impulsa tu negocio con KLICUS",
    subtitle: "Llega a miles de clientes potenciales en tu región con nuestras pautasDiamante.",
    cta: "Publicar anuncio",
    color: "from-primary/95 via-primary/80 to-transparent",
    overlay: "bg-primary",
    textMode: "text-secondary",
    icon: Megaphone,
    image: "https://images.unsplash.com/photo-1556761175-5973dc0f32e7?auto=format&fit=crop&q=80&w=1200"
  },
  {
    id: 2,
    title: "Encuentra lo mejor de tu ciudad",
    subtitle: "Salud, Gastronomía, Tecnología y mucho más. Calidad verificada.",
    cta: "Explorar categorías",
    color: "from-secondary/95 via-secondary/80 to-transparent",
    overlay: "bg-secondary",
    textMode: "text-white",
    icon: Sparkles,
    image: "https://images.unsplash.com/photo-1600880212319-4627a58c882c?auto=format&fit=crop&q=80&w=1200"
  },
  {
    id: 3,
    title: "Publicidad efectiva y local",
    subtitle: "Únete a la comunidad de emprendedores que están creciendo con nosotros.",
    cta: "Comenzar ahora",
    color: "from-accent/95 via-accent/80 to-transparent",
    overlay: "bg-accent",
    textMode: "text-white",
    icon: TrendingUp,
    image: "https://images.unsplash.com/photo-1542744173-8e7e53415bb0?auto=format&fit=crop&q=80&w=1200"
  }
];

export default function BannerCarousel() {
  const [current, setCurrent] = useState(0);

  useEffect(() => {
    const timer = setInterval(() => {
      setCurrent((prev) => (prev + 1) % BANNERS.length);
    }, 6000);
    return () => clearInterval(timer);
  }, []);

  const next = () => setCurrent((prev) => (prev + 1) % BANNERS.length);
  const prev = () => setCurrent((prev) => (prev - 1 + BANNERS.length) % BANNERS.length);

  return (
    <div className="relative w-full aspect-[4/5] md:aspect-[21/7] overflow-hidden md:rounded-2xl shadow-xl group">
      <AnimatePresence mode="wait">
        <motion.div
          key={BANNERS[current].id}
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          transition={{ duration: 0.8, ease: "easeInOut" }}
          className={`absolute inset-0 flex items-center ${BANNERS[current].overlay}`}
        >
          {/* Background Image with Zoom Animation */}
          <motion.div 
            initial={{ scale: 1.1 }}
            animate={{ scale: 1 }}
            transition={{ duration: 10, ease: "linear" }}
            className="absolute inset-0 bg-cover bg-center"
            style={{ backgroundImage: `url(${BANNERS[current].image})` }}
          />
          
          {/* Brand Gradient Overlay */}
          <div className={`absolute inset-0 bg-gradient-to-r ${BANNERS[current].color}`} />
 
          {/* Content */}
          <div className={cn("relative z-10 px-8 md:px-20 max-w-3xl", BANNERS[current].textMode)}>
            <motion.span 
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.2 }}
              className="inline-flex items-center gap-2 text-[10px] md:text-xs font-black uppercase tracking-[0.3em] opacity-80 mb-4 md:mb-6"
            >
              {(() => {
                const Icon = BANNERS[current].icon;
                return <Icon size={14} strokeWidth={3} />;
              })()} Destacado
            </motion.span>
            
            <motion.h2 
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.3 }}
              className="text-4xl md:text-7xl font-black tracking-tighter leading-[1] mb-4 md:mb-8 text-balance"
            >
              {BANNERS[current].title}
            </motion.h2>
            
            <motion.p 
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.4 }}
              className="text-sm md:text-xl mb-8 md:mb-12 opacity-90 max-w-lg font-medium leading-relaxed"
            >
              {BANNERS[current].subtitle}
            </motion.p>
            
            <motion.button 
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.5 }}
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              className={cn(
                "px-8 py-3 md:px-10 md:py-4 rounded-full font-black text-[12px] md:text-base shadow-2xl transition-all",
                BANNERS[current].textMode === "text-secondary" 
                  ? "bg-secondary text-white shadow-secondary/20" 
                  : "bg-primary text-secondary shadow-primary/20"
              )}
            >
              {BANNERS[current].cta}
            </motion.button>
          </div>
        </motion.div>
      </AnimatePresence>

      {/* Navigation Arrows */}
      <button 
        onClick={prev}
        className="absolute left-4 top-1/2 -translate-y-1/2 bg-white/20 hover:bg-white/40 backdrop-blur-md p-2 rounded-full text-white opacity-0 group-hover:opacity-100 transition-opacity z-20"
      >
        <ChevronLeft size={24} />
      </button>
      <button 
        onClick={next}
        className="absolute right-4 top-1/2 -translate-y-1/2 bg-white/20 hover:bg-white/40 backdrop-blur-md p-2 rounded-full text-white opacity-0 group-hover:opacity-100 transition-opacity z-20"
      >
        <ChevronRight size={24} />
      </button>

      {/* Indicators */}
      <div className="absolute bottom-6 left-1/2 -translate-x-1/2 flex gap-2 z-20">
        {BANNERS.map((_, i) => (
          <button 
            key={i}
            onClick={() => setCurrent(i)}
            className={`h-1.5 rounded-full transition-all ${current === i ? "w-8 bg-white" : "w-2 bg-white/40"}`}
          />
        ))}
      </div>
    </div>
  );
}
