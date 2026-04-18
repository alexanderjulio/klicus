'use client';

/**
 * KLICUS Mobile Bottom Navigation
 * Provides easy thumb access to main actions on mobile devices.
 * Dynamically updates based on authentication state.
 */

import { Home, LayoutGrid, PlusSquare, Heart, User, LogIn } from 'lucide-react';
import { cn } from '@/lib/utils';
import { usePathname } from 'next/navigation';
import { useSession } from 'next-auth/react';
import Link from 'next/link';

export default function BottomNav() {
  const pathname = usePathname();
  const { data: session } = useSession();

  if (pathname.startsWith('/dashboard/admin') || pathname.includes('/dashboard/pautas/editar')) return null;

  const navItems = [
    { label: 'Inicio', icon: Home, href: '/' },
    { label: 'Categorías', icon: LayoutGrid, href: '/categorias' },
    { label: 'Publicar', icon: PlusSquare, href: session ? '/publicar' : '/login?callbackUrl=/publicar' },
    { label: 'Favoritos', icon: Heart, href: '/favoritos' },
    { 
      label: session ? 'Mi Perfil' : 'Ingresar', 
      icon: session ? User : LogIn, 
      href: session ? '/dashboard' : '/login' 
    },
  ];

  return (
    <nav className="md:hidden fixed bottom-1 left-4 right-4 bg-white/80 backdrop-blur-xl border border-white/20 rounded-2xl shadow-2xl z-50 flex justify-around items-center h-16 px-2 overflow-hidden">
      {navItems.map((item) => {
        const isActive = pathname === item.href;
        const Icon = item.icon;
        
        return (
          <Link 
            key={item.label}
            href={item.href}
            className={cn(
              "flex flex-col items-center gap-1 min-w-[64px] transition-all duration-300",
              isActive ? "text-primary scale-110" : "text-secondary/60 hover:text-secondary"
            )}
          >
            <div className={cn(
              "p-1.5 rounded-xl transition-all",
              isActive ? "bg-primary/10" : "bg-transparent"
            )}>
              <Icon size={22} strokeWidth={isActive ? 2.5 : 2} />
            </div>
            <span className={cn(
              "text-[9px] font-black uppercase tracking-widest",
              isActive ? "opacity-100" : "opacity-60"
            )}>
              {item.label}
            </span>
          </Link>
        );
      })}
    </nav>
  );
}
