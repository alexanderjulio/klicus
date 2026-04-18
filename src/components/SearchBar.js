'use client';

/**
 * KLICUS Search Bar (Predictive + Location Aware)
 * Respects the global city selection for all suggestions and searches.
 */

import { Search, X, Loader2, ArrowRight, Tag } from 'lucide-react';
import { useState, useEffect, useRef } from 'react';
import { useRouter } from 'next/navigation';
import { motion, AnimatePresence } from 'framer-motion';
import { useLocation } from '@/context/LocationContext';

export default function SearchBar({ initialValue = '', placeholder = 'Buscar productos, marcas y más...' }) {
  const [value, setValue] = useState(initialValue);
  const [suggestions, setSuggestions] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [showDropdown, setShowDropdown] = useState(false);
  
  const { selectedCity } = useLocation();
  const router = useRouter();
  const dropdownRef = useRef(null);

  // Debounced search logic - Now including city context
  useEffect(() => {
    const timer = setTimeout(async () => {
      if (value.trim().length > 1) {
        setIsLoading(true);
        try {
          const cityQuery = selectedCity !== 'Todas' ? `&city=${encodeURIComponent(selectedCity)}` : '';
          const res = await fetch(`/api/search?type=suggestions&q=${encodeURIComponent(value.trim())}${cityQuery}`);
          const data = await res.json();
          setSuggestions(data.ads || []);
          setShowDropdown(true);
        } catch (error) {
          console.error('Suggestion fetch failed:', error);
        } finally {
          setIsLoading(false);
        }
      } else {
        setSuggestions([]);
        setShowDropdown(false);
      }
    }, 400);

    return () => clearTimeout(timer);
  }, [value, selectedCity]);

  // Click outside listener
  useEffect(() => {
    const handleClickOutside = (event) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
        setShowDropdown(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const handleSearch = (e) => {
    e.preventDefault();
    if (value.trim()) {
      setShowDropdown(false);
      const cityQuery = selectedCity !== 'Todas' ? `&city=${encodeURIComponent(selectedCity)}` : '';
      router.push(`/search?q=${encodeURIComponent(value.trim())}${cityQuery}`);
    }
  };

  const handleSuggestionClick = (adId) => {
    setShowDropdown(false);
    setValue('');
    router.push(`/anuncio/${adId}`);
  };

  return (
    <div className="relative w-full" ref={dropdownRef}>
      <form 
        onSubmit={handleSearch}
        className="w-full flex items-center bg-white rounded shadow-sm hover:shadow-md transition-all px-4 py-2 relative z-[60]"
      >
        <input 
          type="text" 
          value={value}
          onChange={(e) => setValue(e.target.value)}
          onFocus={() => value.trim().length > 1 && setShowDropdown(true)}
          placeholder={placeholder}
          className="w-full outline-none text-sm text-secondary font-medium placeholder:text-gray-400"
        />
        
        {isLoading ? (
          <Loader2 size={18} className="animate-spin text-primary mx-2" />
        ) : value ? (
          <button 
            type="button"
            onClick={() => { setValue(''); setSuggestions([]); }}
            className="text-gray-300 hover:text-gray-500 mx-2"
          >
            <X size={16} />
          </button>
        ) : null}

        <div className="w-[1px] h-6 bg-gray-200 mx-3" />
        
        <button 
          type="submit"
          className="text-gray-400 hover:text-accent transition-colors p-1"
        >
          <Search size={22} strokeWidth={1.5} />
        </button>
      </form>

      <AnimatePresence>
        {showDropdown && (suggestions.length > 0 || isLoading) && (
          <motion.div 
            initial={{ opacity: 0, y: -10, scale: 0.98 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, y: -10, scale: 0.98 }}
            className="absolute top-full left-0 right-0 mt-2 bg-white rounded-2xl shadow-2xl border border-border/50 overflow-hidden z-[55] py-2"
          >
            {suggestions.length > 0 ? (
              <>
                <div className="px-4 py-2 text-[10px] font-black uppercase tracking-widest text-muted-foreground border-b border-border/30 mb-2 flex justify-between">
                  <span>Sugerencias en {selectedCity}</span>
                  {selectedCity !== 'Todas' && <span className="text-[8px] text-primary">Filtro Activo</span>}
                </div>
                {suggestions.map((ad) => (
                  <button
                    key={ad.id}
                    onClick={() => handleSuggestionClick(ad.id)}
                    className="w-full flex items-center gap-4 px-4 py-3 hover:bg-muted/50 transition-colors text-left group"
                  >
                    <div className="w-10 h-10 rounded-lg bg-muted overflow-hidden flex-shrink-0">
                      {ad.image_urls && JSON.parse(ad.image_urls)[0] ? (
                        <img src={JSON.parse(ad.image_urls)[0]} alt="" className="w-full h-full object-cover" />
                      ) : (
                        <Tag size={16} className="m-auto text-muted-foreground/30" />
                      )}
                    </div>
                    <div className="flex-1 min-w-0">
                      <p className="text-sm font-bold text-secondary truncate group-hover:text-primary transition-colors">
                        {ad.title}
                      </p>
                      <p className="text-[10px] font-bold text-muted-foreground uppercase tracking-tight">
                        {ad.category_name}
                      </p>
                    </div>
                  </button>
                ))}
                
                <button 
                  onClick={handleSearch}
                  className="w-full px-4 py-3 bg-muted/20 hover:bg-muted transition-colors text-xs font-black text-primary uppercase tracking-widest flex items-center justify-center gap-2 mt-2 border-t border-border/30"
                >
                  Ver todos los resultados en {selectedCity}
                </button>
              </>
            ) : isLoading ? (
              <div className="px-8 py-10 text-center">
                <Loader2 size={24} className="animate-spin text-primary m-auto mb-2" />
                <p className="text-[10px] font-black uppercase text-muted-foreground tracking-widest italic">Buscando en {selectedCity}...</p>
              </div>
            ) : null}
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
