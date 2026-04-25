'use client';

import Link from 'next/link';
import Logo from './ui/Logo';
import { usePathname } from 'next/navigation';

export default function Footer() {
  const pathname = usePathname();

  // Hide footer on dashboard pages
  if (pathname.startsWith('/dashboard')) return null;

  return (
    <footer className="py-20 bg-secondary text-white mt-20 relative overflow-hidden">
      {/* Decorative background element */}
      <div className="absolute top-0 right-0 w-96 h-96 bg-primary/5 rounded-full -translate-y-1/2 translate-x-1/2 blur-3xl pointer-events-none" />
      
      <div className="container mx-auto px-6 grid grid-cols-1 md:grid-cols-4 gap-12 relative z-10">
        {/* Brand Section */}
        <div className="col-span-1 md:col-span-1 text-center md:text-left">
          <Link href="/" className="inline-block mb-6">
            <h2 className="text-primary text-4xl font-black tracking-tighter italic">KLICUS</h2>
          </Link>
          <p className="text-white/60 max-w-sm leading-relaxed text-sm font-medium">
            Conectando lo mejor de tu región con un diseño premium y tecnología de vanguardia. La vitrina publicitaria líder en el mercado local.
          </p>
        </div>
        
        {/* Navigation Links */}
        <div className="text-center md:text-left">
          <h4 className="font-black mb-6 uppercase text-[10px] tracking-[0.2em] text-primary">Plataforma</h4>
          <ul className="space-y-3 text-sm font-bold">
            <li><Link href="/" className="text-white/50 hover:text-white transition-colors">Inicio</Link></li>
            <li><Link href="/categorias" className="text-white/50 hover:text-white transition-colors">Categorías</Link></li>
            <li><Link href="/ofertas" className="text-white/50 hover:text-white transition-colors">Ofertas Destacadas</Link></li>
            <li><Link href="/publicar" className="text-white/50 hover:text-white transition-colors">Publicar Anuncio</Link></li>
          </ul>
        </div>

        {/* Legal Links */}
        <div className="text-center md:text-left">
          <h4 className="font-black mb-6 uppercase text-[10px] tracking-[0.2em] text-primary">Soporte y Legal</h4>
          <ul className="space-y-3 text-sm font-bold">
            <li><Link href="/ayuda" className="text-white/50 hover:text-white transition-colors">Centro de Ayuda</Link></li>
            <li><Link href="/terminos" className="text-white/50 hover:text-white transition-colors">Términos de Servicio</Link></li>
            <li><Link href="/privacidad" className="text-white/50 hover:text-white transition-colors">Política de Privacidad</Link></li>
            <li><Link href="/contacto" className="text-white/50 hover:text-white transition-colors">Contacto</Link></li>
          </ul>
        </div>

        {/* Copyright Section */}
        <div className="text-center md:text-right flex flex-col justify-end">
          <div className="space-y-1">
            <p className="text-xs font-black text-white/30 uppercase tracking-widest">© 2026 KLICUS Marketplace</p>
            <p className="text-[10px] font-medium text-white/20">Todos los derechos reservados.</p>
            <div className="pt-4 flex justify-center md:justify-end gap-4 opacity-30 grayscale hover:grayscale-0 hover:opacity-100 transition-all">
              {/* Optional: Add social icons here if available in the design system */}
            </div>
          </div>
        </div>
      </div>
    </footer>
  );
}
