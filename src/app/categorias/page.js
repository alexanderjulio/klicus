import { query } from '@/lib/db';
import { 
  ShoppingBag, Utensils, Zap, Heart, Sparkles, Settings, Truck, Briefcase, 
  Construction, Map, Cpu, ShoppingCart, Info, LayoutGrid, ArrowRight,
  TrendingUp, Star, Search, ShieldCheck
} from 'lucide-react';
import Link from 'next/link';
import { cn } from '@/lib/utils';

export const metadata = {
  title: "Directorio Maestro de Categorías | KLICUS",
  description: "Explora los sectores comerciales más vibrantes de tu región con KLICUS.",
};

// Vertical Grouping Logic (Premium mapping)
const VERTICALS = [
  {
    id: 'essentials',
    title: 'Comercio & Esenciales',
    description: 'Todo lo que necesitas para tu día a día.',
    slugs: ['comercio', 'supermercados', 'restaurante-bar', 'salud'],
  },
  {
    id: 'services',
    title: 'Servicios Profesionales',
    description: 'Expertos y soluciones a tu alcance.',
    slugs: ['profesional', 'servicio', 'transporte', 'tecnologia'],
  },
  {
    id: 'home',
    title: 'Construcción & Hogar',
    description: 'Mejorando tu espacio y comunidad.',
    slugs: ['construccion', 'belleza'],
  },
  {
    id: 'lifestyle',
    title: 'Vida & Otros',
    description: 'Turismo, entretenimiento y más.',
    slugs: ['turismo', 'entretenimiento', 'otros'],
  }
];

const CATEGORY_ICONS = {
  'comercio': ShoppingBag,
  'restaurante-bar': Utensils,
  'entretenimiento': Zap,
  'salud': Heart,
  'belleza': Sparkles,
  'servicio': Settings,
  'transporte': Truck,
  'profesional': Briefcase,
  'construccion': Construction,
  'turismo': Map,
  'tecnologia': Cpu,
  'supermercados': ShoppingCart,
  'otros': Info
};

export default async function CategoriasPage() {
  /**
   * FETCH DATA: Categories + Active Ad Counts
   */
  const categoriesRaw = await query(`
    SELECT c.*, COUNT(a.id) as ad_count 
    FROM categories c 
    LEFT JOIN advertisements a ON c.id = a.category_id AND a.status = 'active'
    WHERE c.active = TRUE 
    GROUP BY c.id
    ORDER BY name ASC
  `);

  return (
    <div className="min-h-screen bg-[#F5F5F7] pt-28 md:pt-40 pb-24">
      <div className="max-w-7xl mx-auto px-6">
        {/* Elite Header */}
        <div className="flex flex-col md:flex-row items-end justify-between gap-8 mb-20">
          <div className="max-w-2xl">
            <div className="inline-flex items-center gap-2 px-3 py-1 bg-[#FFF159]/20 text-secondary rounded-full text-[9px] font-black uppercase tracking-[0.2em] mb-4 border border-[#FFF159]">
              <LayoutGrid size={12} className="text-secondary" /> Directorio Maestro
            </div>
            <h1 className="text-5xl md:text-7xl font-black text-secondary tracking-tighter mb-4 italic leading-tight">
              Explora por <span className="text-primary italic">Categorías</span>
            </h1>
            <p className="text-muted-foreground font-medium text-lg italic leading-relaxed max-w-lg">
              Hemos organizado el ecosistema comercial de KLICUS para que encuentres talento local en segundos.
            </p>
          </div>
          
          <div className="hidden lg:flex items-center gap-12 text-secondary/30">
            <div className="text-center">
              <p className="text-4xl font-black text-secondary/80 tracking-tighter italic">+{categoriesRaw.length}</p>
              <p className="text-[10px] uppercase font-bold tracking-widest">Sectores</p>
            </div>
            <div className="h-10 w-px bg-border" />
            <div className="text-center">
              <p className="text-4xl font-black text-secondary/80 tracking-tighter italic">24/7</p>
              <p className="text-[10px] uppercase font-bold tracking-widest">Disponibilidad</p>
            </div>
          </div>
        </div>

        {/* Dynamic Vertical Sections */}
        <div className="space-y-32">
          {VERTICALS.map((vertical, idx) => {
            const verticalCategories = categoriesRaw.filter(c => vertical.slugs.includes(c.slug));
            if (verticalCategories.length === 0) return null;

            return (
              <section key={vertical.id} className="relative">
                {/* Vertical Header */}
                <div className="mb-12 flex items-center justify-between border-b border-border/50 pb-6">
                  <div>
                    <h2 className="text-2xl font-black text-secondary tracking-tight mb-1 uppercase italic">{vertical.title}</h2>
                    <p className="text-sm text-muted-foreground font-medium italic">{vertical.description}</p>
                  </div>
                  <div className="text-[10px] font-black text-primary uppercase tracking-[0.2em]">
                    0{idx + 1}
                  </div>
                </div>

                {/* Categories Grid - PRO-STYLE */}
                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                  {verticalCategories.map((cat) => {
                    const IconComponent = CATEGORY_ICONS[cat.slug] || LayoutGrid;
                    const displayName = cat.name.charAt(0).toUpperCase() + cat.name.slice(1).toLowerCase().replace(/-/g, ' ');

                    return (
                      <Link
                        key={cat.id}
                        href={`/?category=${cat.slug}`}
                        className="group relative bg-white h-full p-8 rounded-[2.5rem] border border-border/40 shadow-sm hover:shadow-2xl transition-all duration-500 hover:-translate-y-2 flex flex-col items-start overflow-hidden"
                      >
                        {/* Status Pulse if has ads */}
                        {cat.ad_count > 0 && (
                          <div className="absolute top-6 right-6 flex items-center gap-1.5 px-2 py-1 bg-green-50 text-green-600 rounded-full text-[8px] font-black uppercase tracking-tighter">
                            <span className="w-1 h-1 bg-green-500 rounded-full animate-pulse" />
                            {cat.ad_count} Anuncios
                          </div>
                        )}

                        <div className="w-14 h-14 rounded-2xl bg-[#F5F5F7] group-hover:bg-[#FFF159] flex items-center justify-center text-secondary mb-8 transition-all duration-500 shadow-inner">
                          <IconComponent size={28} strokeWidth={1.5} className="group-hover:scale-110 transition-transform" />
                        </div>
                        
                        <div className="mt-auto">
                          <h3 className="text-xl font-black text-secondary mb-2 leading-tight">
                            {displayName}
                          </h3>
                          <p className="text-[11px] text-muted-foreground font-semibold leading-relaxed mb-6 opacity-80 group-hover:opacity-100 transition-opacity">
                            {cat.description || `Explora lo mejor en ${displayName.toLowerCase()} de tu región.`}
                          </p>
                          
                          <div className="flex items-center gap-2 text-[9px] font-black uppercase tracking-[0.15em] text-primary group-hover:translate-x-2 transition-transform duration-300">
                            Explorar <ArrowRight size={12} strokeWidth={3} />
                          </div>
                        </div>

                        {/* subtle water-mark */}
                        <IconComponent className="absolute -bottom-10 -right-10 w-32 h-32 text-black/[0.02] -rotate-12 group-hover:rotate-0 transition-transform duration-700" />
                      </Link>
                    );
                  })}
                </div>
              </section>
            );
          })}
        </div>

        {/* Elite CTA Banner */}
        <div className="mt-40 p-12 md:p-20 rounded-[4rem] bg-[#0E2244] text-white flex flex-col lg:flex-row items-center justify-between gap-16 relative overflow-hidden shadow-2xl">
          <div className="absolute top-0 left-0 w-full h-full opacity-10 pointer-events-none">
             <div className="absolute top-10 left-10 w-64 h-64 bg-white rounded-full blur-[100px] animate-pulse" />
             <div className="absolute bottom-10 right-10 w-64 h-64 bg-primary rounded-full blur-[100px] animate-pulse" />
          </div>

          <div className="max-w-2xl text-center lg:text-left relative z-10">
            <div className="inline-flex items-center gap-2 px-3 py-1 bg-white/10 rounded-full text-[10px] font-black uppercase tracking-[0.2em] mb-8 border border-white/10">
              <Star size={12} className="text-primary fill-primary" /> Oportunidad Comercial
            </div>
            <h2 className="text-4xl md:text-6xl font-black tracking-tighter mb-6 italic leading-tight">
               ¿No encuentras tu <br/><span className="text-primary">categoría?</span>
            </h2>
            <p className="text-white/60 font-medium text-lg italic leading-relaxed">
              Estamos expandiendo nuestra red comercial. Si tu negocio es innovador, ¡publícalo hoy o solicita una nueva categoría!
            </p>
          </div>
          
          <div className="flex flex-col sm:flex-row items-center gap-6 relative z-10">
            <Link href="/publicar" className="px-12 py-6 bg-primary text-secondary rounded-2xl font-black shadow-2xl shadow-primary/20 hover:scale-105 active:scale-95 transition-all whitespace-nowrap text-lg italic">
              Unirse como Vendedor
            </Link>
            <Link href="/ayuda" className="px-10 py-6 bg-white/5 border border-white/10 text-white rounded-2xl font-black hover:bg-white/10 transition-all text-sm uppercase tracking-widest">
              Soporte
            </Link>
          </div>
        </div>

        {/* Bottom Trust Icons */}
        <div className="mt-24 grid grid-cols-2 md:grid-cols-4 gap-12 opacity-30 select-none grayscale">
            <div className="flex flex-col items-center gap-3">
              <TrendingUp size={32} />
              <span className="text-[10px] font-black uppercase tracking-[0.2em]">Crecimiento</span>
            </div>
            <div className="flex flex-col items-center gap-3">
              <Search size={32} />
              <span className="text-[10px] font-black uppercase tracking-[0.2em]">Visibilidad</span>
            </div>
            <div className="flex flex-col items-center gap-3">
              <Zap size={32} />
              <span className="text-[10px] font-black uppercase tracking-[0.2em]">Rapidez</span>
            </div>
            <div className="flex flex-col items-center gap-3">
              <ShieldCheck size={32} />
              <span className="text-[10px] font-black uppercase tracking-[0.2em]">Seguridad</span>
            </div>
        </div>
      </div>
    </div>
  );
}
