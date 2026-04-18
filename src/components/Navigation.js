'use client';

/**
 * KLICUS Navigation Header
 * Redesigned with Mercado Libre inspiration: Yellow background, integrated search.
 */

import { 
  User, MapPin, ChevronDown, Bell, ShoppingCart, Search,
  Home, LayoutGrid, Zap, PlusCircle, HelpCircle 
} from 'lucide-react';
import Button from './ui/Button';
import Logo from './ui/Logo';
import SearchBar from './SearchBar';
import { cn } from '@/lib/utils';
import { useLocation } from '@/context/LocationContext';
import { useState, useRef, useEffect } from 'react';
import { useSession, signOut } from 'next-auth/react';
import { motion, AnimatePresence } from 'framer-motion';
import Link from 'next/link';
import { usePathname } from 'next/navigation';

export default function Navigation() {
  const pathname = usePathname();
  const { data: session } = useSession();
  const { selectedCity, setSelectedCity } = useLocation();
  const [isLocationOpen, setIsLocationOpen] = useState(false);
  const locationRef = useRef(null);

  // Click outside for location dropdown
  useEffect(() => {
    const handleClickOutside = (e) => {
      if (locationRef.current && !locationRef.current.contains(e.target)) {
        setIsLocationOpen(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const cities = ['Todas', 'Ocaña', 'Cúcuta', 'Abrego', 'Convención', 'Aguachica'];

  if (pathname.startsWith('/dashboard')) return null;

  return (
    <header className="bg-[#FFF159] fixed top-0 left-0 right-0 z-50 transition-all duration-300">
      {/* Top Bar: Logo + Search + Desktop Icons */}
      <div className="max-w-7xl mx-auto px-6 py-3">
        <div className="flex md:grid md:grid-cols-[auto_1fr_auto] items-center gap-4 md:gap-12 w-full">
          {/* Column 1: Logo Only */}
          <div className="flex items-center gap-2 shrink-0">
            <a href="/" className="shrink-0">
              <Logo className="h-8 md:h-11" />
            </a>
          </div>

          {/* Column 2: Location + Search Bar (The Center Block) */}
          <div className="flex-1 w-full order-3 md:order-2 col-span-full md:col-span-1 mt-2 md:mt-0 flex items-center gap-6">
            {/* Location Selector - Now Centered */}
            <div className="relative shrink-0" ref={locationRef}>
              <button 
                onClick={() => setIsLocationOpen(!isLocationOpen)}
                className="group flex flex-col items-start px-2 py-1 rounded hover:bg-black/5 transition-all text-left"
              >
                <span className="text-[9px] text-secondary/60 leading-none">Cerca de</span>
                <div className="flex items-center gap-1">
                  <MapPin size={12} className={cn("text-secondary", selectedCity !== 'Todas' && "text-primary")} />
                  <span className="text-[11px] font-black text-secondary uppercase tracking-tighter truncate max-w-[80px]">
                    {selectedCity}
                  </span>
                  <ChevronDown size={10} className={cn("text-secondary/40 transition-transform", isLocationOpen && "rotate-180")} />
                </div>
              </button>

              <AnimatePresence>
                {isLocationOpen && (
                  <motion.div 
                    initial={{ opacity: 0, y: 10 }}
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0, y: 10 }}
                    className="absolute top-full left-0 mt-2 w-48 bg-white rounded-xl shadow-2xl border border-border/50 py-2 z-[70] overflow-hidden"
                  >
                    <p className="px-4 py-2 text-[10px] font-black uppercase tracking-widest text-muted-foreground border-b border-border/30 mb-1">Elige tu ubicación</p>
                    {cities.map((city) => (
                      <button
                        key={city}
                        onClick={() => { setSelectedCity(city); setIsLocationOpen(false); }}
                        className={cn(
                          "w-full text-left px-4 py-2.5 text-xs font-bold transition-colors hover:bg-muted/50 flex items-center justify-between group",
                          selectedCity === city ? "text-primary bg-primary/5" : "text-secondary"
                        )}
                      >
                        {city}
                        {selectedCity === city && <div className="w-1.5 h-1.5 rounded-full bg-primary" />}
                      </button>
                    ))}
                  </motion.div>
                )}
              </AnimatePresence>
            </div>

            {/* Optimized Search Bar */}
            <div className="flex-1">
              <SearchBar />
            </div>
          </div>

          {/* Column 3: Right Actions */}
          <div className="flex items-center gap-3 shrink-0 justify-end h-full order-2 md:order-3">
            <Link href={session ? "/dashboard" : "/login"} className="md:hidden">
              <Button variant="ghost" size="icon" className="text-secondary hover:bg-black/5">
                <User size={20} />
              </Button>
            </Link>
            
            <div className="hidden md:flex items-center gap-6">
              {!session ? (
                <>
                  <Link href="/register" className="text-sm font-medium text-secondary hover:underline transition-colors hover:text-black">Crear cuenta</Link>
                  <Link href="/login" className="text-sm font-medium text-secondary hover:underline transition-colors hover:text-black">Ingresar</Link>
                </>
              ) : (
                <>
                  <Link 
                    href={session.user.role === 'admin' ? "/dashboard/admin" : "/dashboard"} 
                    className="text-sm font-medium text-secondary hover:underline transition-colors hover:text-black"
                  >
                    Mi Cuenta
                  </Link>
                  <button 
                    onClick={() => signOut()} 
                    className="text-sm font-medium text-secondary hover:underline transition-colors hover:text-red-600"
                  >
                    Salir
                  </button>
                </>
              )}
              <a 
                href={session ? "/publicar" : "/login?callbackUrl=/publicar"} 
                className="px-4 py-1.5 bg-accent text-white rounded-md text-sm font-bold hover:bg-accent/90 transition-all shadow-sm active:scale-95 transition-all"
              >
                Vender
              </a>
            </div>
            
            {session && (
              <Button variant="ghost" size="icon" className="text-secondary hover:bg-black/5">
                <Bell size={20} />
              </Button>
            )}
            <Button variant="ghost" size="icon" className="text-secondary hover:bg-black/5">
              <ShoppingCart size={20} />
            </Button>
          </div>
        </div>
      </div>

      {/* Lower Bar: Desktop Nav Centered - DESIGN OVERHAUL */}
      <div className="max-w-7xl mx-auto px-6 pb-3 hidden md:flex justify-center items-center pt-1 border-t border-black/5 mt-1">
        <nav className="flex items-center gap-12">
          <Link href="/" className="group flex items-center gap-2 text-[10px] font-black text-secondary/60 hover:text-secondary transition-all uppercase tracking-[0.2em]">
            <Home size={14} className="group-hover:scale-110 transition-transform" />
            Inicio
          </Link>
          <Link href="/categorias" className="group flex items-center gap-2 text-[10px] font-black text-secondary/60 hover:text-secondary transition-all uppercase tracking-[0.2em]">
            <LayoutGrid size={14} className="group-hover:scale-110 transition-transform" />
            Categorías
          </Link>
          <Link href="/ofertas" className="group flex items-center gap-2 text-[10px] font-black text-secondary/60 hover:text-secondary transition-all uppercase tracking-[0.2em]">
            <Zap size={14} className="text-amber-600 group-hover:scale-125 transition-transform" />
            Ofertas
          </Link>
          <a 
            href={session ? "/publicar" : "/login?callbackUrl=/publicar"} 
            className="group flex items-center gap-2 text-[10px] font-black text-secondary/60 hover:text-secondary transition-all uppercase tracking-[0.2em]"
          >
            <PlusCircle size={14} className="text-secondary group-hover:rotate-90 transition-transform" />
            Vender
          </a>
          <Link href="/ayuda" className="group flex items-center gap-2 text-[10px] font-black text-secondary/60 hover:text-secondary transition-all uppercase tracking-[0.2em]">
            <HelpCircle size={14} className="group-hover:scale-110 transition-transform" />
            Ayuda
          </Link>
        </nav>
      </div>
    </header>
  );
}
