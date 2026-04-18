import { query } from '@/lib/db';
import { Tag, Zap, ArrowRight, ShoppingBag, Clock } from 'lucide-react';
import Image from 'next/image';
import Link from 'next/link';
import { cn } from '@/lib/utils';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/lib/auth';

export const metadata = {
  title: "Ofertas Exclusivas | KLICUS",
  description: "Encuentra los mejores descuentos y promociones en tu ciudad.",
};

export default async function OfertasPage() {
  const session = await getServerSession(authOptions);

  // Fetch active offers
  const offers = await query(`
    SELECT 
      a.*, 
      c.name as category_name, 
      p.business_name
    FROM advertisements a
    LEFT JOIN categories c ON a.category_id = c.id
    LEFT JOIN profiles p ON a.owner_id = p.id
    WHERE a.is_offer = TRUE AND a.status = 'active'
    ORDER BY a.priority_level = 'diamond' DESC, a.created_at DESC
  `);

  return (
    <div className="min-h-screen bg-[#F5F5F7] pt-32 pb-24">
      <div className="container mx-auto px-6">
        {/* Header Section */}
        <div className="text-center mb-16 animate-in fade-in duration-1000">
          <div className="inline-flex items-center gap-2 px-4 py-2 bg-[#0E2244] text-white rounded-full text-[10px] font-black uppercase tracking-[0.2em] mb-6 shadow-xl shadow-[#0E2244]/20 border border-white/10">
            <Tag size={14} className="text-primary" /> Promociones Activas
          </div>
          <h1 className="text-4xl md:text-5xl font-black text-secondary tracking-tighter mb-4 italic">
            Ofertas del Día
          </h1>
          <p className="text-muted-foreground font-medium text-lg italic max-w-lg mx-auto">
            Seleccionamos las mejores oportunidades de comercio local para ti.
          </p>
        </div>

        {offers.length === 0 ? (
          <div className="text-center py-24 bg-white rounded-[3rem] border-2 border-dashed border-border flex flex-col items-center justify-center">
            <div className="w-20 h-20 bg-muted/50 rounded-full flex items-center justify-center text-muted-foreground mb-6">
              <ShoppingBag size={40} />
            </div>
            <h3 className="text-2xl font-black text-secondary mb-2">Aún no hay ofertas activas</h3>
            <p className="text-muted-foreground font-medium">¡Vuelve pronto para descubrir nuevas promociones!</p>
            <Link 
              href={session ? "/publicar" : "/login?callbackUrl=/publicar"} 
              className="mt-8 px-8 py-3 bg-primary text-secondary rounded-xl font-black text-sm hover:scale-105 transition-all shadow-xl shadow-primary/20"
            >
              ¿Tienes una oferta? Publícala aquí
            </Link>
          </div>
        ) : (
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-8 animate-in fade-in slide-in-from-bottom-8 duration-700">
            {offers.map((ad) => {
              const images = ad.image_urls ? JSON.parse(ad.image_urls) : [];
              const thumbnail = images[0] || '/assets/placeholder-ad.png';

              return (
                <Link 
                  key={ad.id}
                  href={`/anuncio/${ad.id}`}
                  className="group bg-white rounded-[2.5rem] overflow-hidden border border-border shadow-sm hover:shadow-2xl transition-all duration-500 hover:-translate-y-2 flex flex-col h-full"
                >
                  <div className="aspect-[4/3] relative overflow-hidden bg-muted">
                    <Image
                      src={thumbnail}
                      alt={ad.title}
                      fill
                      unoptimized
                      className="object-cover transition-transform duration-700 group-hover:scale-110"
                    />
                    {/* Offer Badge Overlay */}
                    <div className="absolute top-4 left-4 z-10">
                      <div className="bg-[#E2E000] text-[#0E2244] px-4 py-1.5 rounded-full text-[10px] font-black uppercase tracking-widest shadow-lg flex items-center gap-2">
                        <Zap size={12} fill="#0E2244" /> OFERTA
                      </div>
                    </div>
                  </div>

                  <div className="p-7 flex flex-col flex-grow">
                    <div className="flex items-center gap-2 mb-3">
                      <span className="text-[10px] font-black text-primary uppercase tracking-widest bg-primary/10 px-3 py-1 rounded-full">
                        {ad.category_name}
                      </span>
                      {ad.priority_level === 'diamond' && (
                        <div className="flex gap-0.5">
                          {[1,2,3].map(i => <div key={i} className="w-1 h-1 rounded-full bg-primary" />)}
                        </div>
                      )}
                    </div>
                    
                    <h3 className="text-xl font-black text-secondary mb-2 line-clamp-1 group-hover:text-primary transition-colors">
                      {ad.title}
                    </h3>
                    
                    <p className="text-sm text-muted-foreground line-clamp-2 font-medium mb-6 leading-relaxed flex-grow italic">
                      {ad.description}
                    </p>

                    <div className="pt-6 border-t border-border flex items-center justify-between mt-auto">
                      <div className="flex items-center gap-2 text-xs font-black text-secondary">
                        <ShoppingBag size={14} className="text-primary" /> {ad.business_name}
                      </div>
                      <div className="w-8 h-8 rounded-full bg-muted flex items-center justify-center text-secondary transition-all group-hover:bg-primary group-hover:scale-110">
                        <ArrowRight size={16} />
                      </div>
                    </div>
                  </div>
                </Link>
              );
            })}
          </div>
        )}

        {/* Info Banner */}
        <div className="mt-20 bg-white border border-border rounded-[3rem] p-12 md:p-16 flex flex-col md:flex-row items-center justify-between gap-12">
          <div className="max-w-xl text-center md:text-left">
            <div className="w-16 h-16 bg-blue-50 text-blue-600 rounded-3xl flex items-center justify-center mb-6">
              <Clock size={32} />
            </div>
            <h2 className="text-3xl font-black text-secondary tracking-tight mb-4 italic">Ofertas de tiempo limitado</h2>
            <p className="text-muted-foreground font-medium leading-relaxed italic">
              Nuestras ofertas se actualizan diariamente. No pierdas la oportunidad de ahorrar mientras apoyas a los emprendedores de tu región.
            </p>
          </div>
          <Link href="/" className="px-12 py-5 bg-secondary text-white rounded-2xl font-black shadow-2xl shadow-secondary/20 hover:scale-105 transition-all whitespace-nowrap">
            Explorar más anuncios
          </Link>
        </div>
      </div>
    </div>
  );
}
