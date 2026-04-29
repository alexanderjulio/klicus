/**
 * KLICUS Marketplace Orchestrator
 * Client-side component that manages live searching, category filtering, 
 * and priority-based sorting of advertisements.
 * @version 1.1.0-revalidate
 */

'use client';

import { useState, useMemo } from 'react';
import AdCard from './AdCard';
import CategoryFilter from './CategoryFilter';
import SearchBar from './SearchBar';
import Button from './ui/Button';
import { 
  HeartPulse, Utensils, Smartphone, Map, Trophy, Home, Dog, Shirt, Car, Building, 
  Menu, Search, MapPin, Zap, Store, Gamepad2, Sparkles, Wrench, Truck, Briefcase, 
  HardHat, Cpu, ShoppingBasket
} from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import { cn } from '@/lib/utils';
import BannerCarousel from './BannerCarousel';

// Mapping category slugs to premium Lucide icons
const CATEGORY_ICONS = {
  'comercio': Store,
  'restaurante-bar': Utensils,
  'entretenimiento': Gamepad2,
  'salud': HeartPulse,
  'belleza': Sparkles,
  'servicio': Wrench,
  'transporte': Truck,
  'profesional': Briefcase,
  'construccion': HardHat,
  'turismo': Map,
  'tecnologia': Cpu,
  'supermercados': ShoppingBasket,
  'deporte': Trophy,
};

export default function Marketplace({ initialAds, categories, initialCategory = 'all' }) {
  // State for real-time search terms, category, and city
  const [search, setSearch] = useState('');
  const [activeCategory, setActiveCategory] = useState(initialCategory);
  const [selectedCity, setSelectedCity] = useState('all');
  const [displayLimit, setDisplayLimit] = useState(12);


  /**
   * Dynamically extract and normalize unique cities from the ad database.
   * Format: "Bucaramanga, Santander" -> "Bucaramanga"
   */
  const availableCities = useMemo(() => {
    const cities = initialAds.filter(ad => ad.location).map(ad => ad.location.split(',')[0].trim());
    return [...new Set(cities)].sort();
  }, [initialAds]);

  const filteredAds = useMemo(() => {
    return initialAds.filter(ad => {
      const cityMatch = selectedCity === 'all' || (ad.location && ad.location.startsWith(selectedCity));
      const searchMatch = 
        ad.title.toLowerCase().includes(search.toLowerCase()) || 
        ad.description.toLowerCase().includes(search.toLowerCase());
      const categoryMatch = activeCategory === 'all' || ad.category_slug === activeCategory;
      
      return searchMatch && categoryMatch && cityMatch;
    }).sort((a, b) => {
      const priorityOrder = { diamond: 0, pro: 1, basic: 2 };
      return priorityOrder[a.priority_level] - priorityOrder[b.priority_level];
    });
  }, [search, activeCategory, selectedCity, initialAds]);

  return (
    <div className="flex flex-col items-center w-full min-h-screen bg-[#F8F9FB]">
      {/* Header Top Section (Isolated Gradient for Banner) */}
      <div className="w-full bg-gradient-to-b from-[#FFF159] via-[#FFF159] to-[#F8F9FB] pt-16 md:pt-28 pb-10 mb-8 border-none shadow-none">
        {/* Promotional Banners */}
        <div className="w-full max-w-7xl mx-auto px-0 md:px-6">
          <BannerCarousel />
        </div>
      </div>

      {/* Category Icons Row (Apple-Style Miniaturized) - Hidden on Mobile */}
      <motion.div
        initial={{ opacity: 0, y: 10 }}
        animate={{ opacity: 1, y: 0 }}
        className="w-full max-w-7xl mx-auto px-4 md:px-8 mb-8 overflow-hidden hidden md:block"
      >
        <div className="flex flex-wrap justify-center items-start gap-3 md:gap-5 py-2">
           {/* All Categories "Icon" */}
           <div className="relative group/category">
             <button 
               onClick={() => setActiveCategory('all')}
               className="flex flex-col items-center gap-1.5 group transition-all"
             >
               <div className={cn(
                  "w-9 h-9 rounded-xl flex items-center justify-center border transition-all relative overflow-hidden",
                  activeCategory === 'all' 
                    ? "bg-white border-primary text-secondary scale-105 ring-4 ring-primary/10 shadow-sm" 
                    : "bg-white border-black/[0.08] text-muted-foreground/60 hover:border-black/20 hover:text-secondary"
                )}>
                 <Menu className={cn("w-4 h-4 transition-transform duration-500", activeCategory === 'all' ? "scale-110" : "group-hover:rotate-90")} strokeWidth={2} />
               </div>
               <span className={cn("text-[8px] font-black uppercase tracking-wider text-center leading-tight transition-colors px-1", 
                 activeCategory === 'all' ? "text-secondary" : "text-secondary/40")}>
                 Todos
               </span>
             </button>
           </div>

            {categories.map((cat) => {
              const CategoryIcon = CATEGORY_ICONS[cat.slug] || Zap;
              const displayName = cat.name.charAt(0).toUpperCase() + cat.name.slice(1).toLowerCase().replace(/-/g, ' ');
              
              return (
                <div key={cat.id} className="relative group/category">
                  <button 
                    onClick={() => setActiveCategory(cat.slug)}
                    className="flex flex-col items-center gap-1.5 group transition-all"
                  >
                    <div className={cn(
                      "w-9 h-9 rounded-xl flex items-center justify-center border transition-all relative overflow-hidden",
                      activeCategory === cat.slug 
                        ? "bg-white border-primary text-secondary scale-105 ring-4 ring-primary/10 shadow-sm" 
                        : "bg-white border-black/[0.08] text-muted-foreground/60 hover:border-black/20 hover:text-secondary"
                    )}>
                      {activeCategory === cat.slug && (
                        <div className="absolute inset-0 bg-primary/5 animate-pulse" />
                      )}
                      <CategoryIcon className={cn("w-4 h-4 transition-transform duration-500", activeCategory === cat.slug ? "scale-110 shadow-xl" : "group-hover:scale-110")} strokeWidth={2} />
                    </div>
                    <span className={cn("text-[8px] font-black uppercase tracking-wider text-center leading-tight transition-colors px-1", 
                      activeCategory === cat.slug ? "text-secondary" : "text-secondary/40")}>
                      {displayName}
                    </span>
                  </button>
                </div>
              );
            })}
          </div>
        </motion.div>

      {/* Main Content Area (Ads Grid) */}
      <div className="w-full pb-24">


      {/* Optimized Responsive Grid with Framer Motion */}
      <div className="w-full max-w-7xl mx-auto px-6">
        <motion.div 
          layout
          className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-12"
        >
          <AnimatePresence mode="popLayout">
            {filteredAds.length > 0 ? (
              filteredAds.slice(0, displayLimit).map((ad) => (
                <AdCard key={ad.id} ad={ad} />
              ))
            ) : (
              <motion.div 
                initial={{ opacity: 0, scale: 0.95 }}
                animate={{ opacity: 1, scale: 1 }}
                exit={{ opacity: 0, scale: 0.95 }}
                className="col-span-full text-center py-32 bg-muted/20 rounded-[2.5rem] border-2 border-dashed border-border/50"
              >
                <p className="text-2xl text-muted-foreground/60 mb-6 font-medium">No se encontraron anuncios que coincidan.</p>
                <Button 
                  variant="outline"
                  className="rounded-xl px-10"
                  onClick={() => { setSearch(''); setActiveCategory('all'); }}
                >
                  Ver todos los anuncios
                </Button>
              </motion.div>
            )}
          </AnimatePresence>
        </motion.div>

        {/* Load More Button Section */}
        {filteredAds.length > displayLimit && (
          <div className="flex justify-center mt-20">
            <Button 
              onClick={() => setDisplayLimit(prev => prev + 8)}
              className="px-12 py-6 rounded-2xl bg-white border border-border shadow-xl hover:shadow-2xl hover:-translate-y-1 transition-all text-secondary font-black gap-3 group"
            >
              Cargar más anuncios
              <div className="w-6 h-6 rounded-full bg-primary/10 flex items-center justify-center group-hover:bg-primary transition-colors">
                <Menu size={14} className="text-secondary rotate-90" />
              </div>
            </Button>
          </div>
        )}
      </div>
      </div>
    </div>
  );
}
