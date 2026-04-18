import { query } from '@/lib/db';
import { Check, X, Eye, Clock, MapPin, Tag } from 'lucide-react';
import Button from '@/components/ui/Button';

export default async function AdminPendingAds() {
  const pendingAds = await query(`
    SELECT a.*, p.business_name, p.full_name, c.name as category_name 
    FROM advertisements a
    JOIN profiles p ON a.owner_id = p.id
    LEFT JOIN categories c ON a.category_id = c.id
    WHERE a.status = 'pending'
    ORDER BY a.created_at DESC
  `);

  return (
    <div className="container mx-auto px-6 pt-32 pb-24">
      <header className="mb-12">
        <h1 className="text-4xl font-black text-secondary tracking-tighter">Revisiones Pendientes</h1>
        <p className="text-muted-foreground font-medium mt-1">Revisa y activa los anuncios nuevos en la plataforma.</p>
      </header>

      {pendingAds.length > 0 ? (
        <div className="space-y-6">
          {pendingAds.map((ad) => (
            <div 
              key={ad.id} 
              className="bg-white p-6 rounded-[2.5rem] border border-border shadow-sm hover:shadow-md transition-shadow flex flex-col lg:flex-row lg:items-center gap-8"
            >
              {/* Visual Preview */}
              <div className="w-full lg:w-48 h-32 bg-muted/30 rounded-3xl overflow-hidden shrink-0 border border-border">
                {ad.image_urls && JSON.parse(ad.image_urls)[0] ? (
                   <img src={JSON.parse(ad.image_urls)[0]} alt="" className="w-full h-full object-cover" />
                ) : (
                  <div className="w-full h-full flex items-center justify-center text-muted-foreground font-bold text-xs uppercase tracking-widest">Sin imagen</div>
                )}
              </div>

              {/* Ad Content Summary */}
              <div className="flex-1">
                <div className="flex flex-wrap items-center gap-2 mb-2">
                  <h3 className="text-xl font-black text-secondary tracking-tight">{ad.title}</h3>
                  <span className={`px-3 py-0.5 rounded-full text-[10px] font-black uppercase tracking-widest ${
                    ad.priority_level === 'diamond' ? 'bg-primary text-secondary shadow-sm' : 'bg-muted text-secondary'
                  }`}>
                    {ad.priority_level}
                  </span>
                </div>
                
                <p className="text-sm font-medium text-muted-foreground mb-4">
                  Por <span className="text-secondary font-bold">{ad.business_name || ad.full_name}</span> • <span className="opacity-70">{ad.category_name}</span>
                </p>
                
                <div className="flex flex-wrap gap-4 text-[11px] font-bold text-muted-foreground uppercase tracking-wider">
                  <span className="flex items-center gap-1.5"><MapPin size={14} className="text-primary" /> {ad.location}</span>
                  <span className="flex items-center gap-1.5"><Tag size={14} className="text-primary" /> {ad.price_range}</span>
                  <span className="flex items-center gap-1.5"><Clock size={14} className="text-primary" /> {new Date(ad.created_at).toLocaleDateString()}</span>
                </div>
              </div>

              {/* Administrative Actions */}
              <div className="flex items-center gap-3 pt-4 lg:pt-0 border-t lg:border-t-0 border-border">
                <Button variant="outline" className="h-12 px-6 rounded-2xl gap-2 font-bold border-border">
                  <Eye size={18} /> Ver Detalles
                </Button>
                <div className="w-px h-8 bg-border hidden lg:block mx-1" />
                <button className="h-12 w-12 flex items-center justify-center rounded-2xl bg-red-50 text-red-600 hover:bg-red-100 transition-colors shadow-sm" title="Rechazar">
                  <X size={20} strokeWidth={3} />
                </button>
                <button className="h-12 px-8 flex items-center justify-center rounded-2xl bg-emerald-500 text-white font-black shadow-lg shadow-emerald-500/20 hover:opacity-90 transition-all gap-2" title="Aprobar">
                  <Check size={20} strokeWidth={3} /> Activar Pauta
                </button>
              </div>
            </div>
          ))}
        </div>
      ) : (
        <div className="text-center py-32 bg-muted/10 rounded-[3rem] border-2 border-dashed border-border/50">
          <div className="w-20 h-20 bg-muted/20 rounded-full flex items-center justify-center mx-auto mb-6">
            <Check size={40} className="text-muted-foreground/40" />
          </div>
          <h3 className="text-2xl font-black text-secondary/40">No hay pautas pendientes</h3>
          <p className="text-muted-foreground/60 font-medium mt-1">¡Buen trabajo! Estás al día con las revisiones.</p>
        </div>
      )}
    </div>
  );
}
