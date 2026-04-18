import { query } from '@/lib/db';
import { notFound } from 'next/navigation';
import { 
  MapPin, Clock, Phone, Smartphone, Mail, Globe, 
  MessageSquare, Truck, Heart, Share2, ArrowLeft, ArrowRight,
  ChevronRight, Crown, Sparkles, CheckCircle2, ShieldCheck,
  Info, Star, Zap, Building2, ExternalLink, Navigation as NavIcon
} from 'lucide-react';
import Link from 'next/link';
import Image from 'next/image';
import { cn } from '@/lib/utils';
import AdTracker from '@/components/AdTracker';
import AdContactButtons, { MobileContactButtons } from '@/components/AdContactButtons';
import ImageGallery from '@/components/ImageGallery';

/**
 * KLICUS Ad Showcase - Elite Redesign (TOTAL VISIBILITY RESTORED)
 * Professional, high-conversion product page with all business fields integrated.
 */

async function getAdData(id) {
  const results = await query(`
    SELECT 
      a.*, 
      c.name as category_name, 
      c.slug as category_slug,
      p.business_name as profile_business_name,
      p.full_name as owner_name,
      p.avatar_url,
      p.bio as owner_bio,
      p.social_links as profile_social_links
    FROM advertisements a
    LEFT JOIN categories c ON a.category_id = c.id
    LEFT JOIN profiles p ON a.owner_id = p.id
    WHERE a.id = ?
  `, [id]);

  if (results.length === 0) return null;

  const ad = results[0];
  return {
    ...ad,
    image_urls: ad.image_urls ? JSON.parse(ad.image_urls) : [],
    profile_social_links: ad.profile_social_links ? JSON.parse(ad.profile_social_links) : {}
  };
}

export default async function AdDetailPage({ params: paramsPromise }) {
  const params = await paramsPromise;
  const { id } = params;
  const ad = await getAdData(id);

  if (!ad) notFound();

  // CLEANUP LOGIC: Strip legacy contact info from description to avoid redundancy
  const cleanDescription = (text) => {
    if (!text) return '';
    const separators = ['--- CONTACTO', '--- 🌟 CONTACTO', 'WhatsApp:', 'Teléfono:', 'Web:'];
    let cleaned = text;
    for (const sep of separators) {
      const index = cleaned.indexOf(sep);
      if (index !== -1) {
        cleaned = cleaned.substring(0, index).trim();
      }
    }
    return cleaned;
  };

  const isDiamond = ad.priority_level === 'diamond';
  const mainImage = ad.image_urls[0] || 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&q=80&w=1200';

  return (
    <div className="min-h-screen bg-[#F5F5F7] text-secondary selection:bg-primary/30 pb-32">
      <AdTracker adId={id} />
      
      {/* Dynamic Header Blur Backdrop */}
      <div className="fixed top-0 left-0 right-0 h-[50vh] bg-gradient-to-b from-[#FFF159]/20 to-transparent pointer-events-none -z-10" />

      <main className="max-w-7xl mx-auto pt-28 md:pt-40 px-6">
        {/* Breadcrumbs - Minimalist & Elegant */}
        <div className="flex items-center gap-3 text-[10px] font-black uppercase tracking-[0.2em] text-secondary/30 mb-12">
          <Link href="/" className="hover:text-secondary transition-colors">Directorio</Link>
          <div className="w-1 h-1 rounded-full bg-secondary/20" />
          <Link href={`/categorias`} className="hover:text-secondary transition-colors">{ad.category_name}</Link>
          <div className="w-1 h-1 rounded-full bg-secondary/20" />
          <span className="text-secondary opacity-100 italic transition-all">{ad.title}</span>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 items-start">
          
          {/* LEFT: MEDIA & DESCRIPTION (70%) */}
          <div className="lg:col-span-8 space-y-10">
            
            {/* Visual Masterpiece Drawer (Interactive) */}
            <ImageGallery 
              images={ad.image_urls} 
              title={ad.title} 
              isDiamond={isDiamond} 
            />

            {/* Content Core: Story & Specs */}
            <section className="bg-white rounded-[3.5rem] p-10 md:p-16 shadow-2xl shadow-secondary/5 border border-white">
               <div className="space-y-12">
                 <div className="space-y-8">
                   <h1 className="text-5xl md:text-7xl font-black text-secondary tracking-tightest leading-[0.9] italic">
                     {ad.title}
                   </h1>
                   
                   <div className="flex flex-wrap items-center gap-4">
                     <div className="flex items-center gap-2 bg-[#F5F5F7] px-5 py-2.5 rounded-2xl text-[11px] font-black tracking-tight text-secondary/70">
                       <MapPin size={16} className="text-secondary" />
                       {ad.location}
                     </div>
                     {ad.delivery_info && (
                        <div className="flex items-center gap-3 bg-blue-50 text-blue-700 px-5 py-2.5 rounded-2xl text-[9px] font-black uppercase tracking-[0.2em] border border-blue-100 animate-in zoom-in duration-500">
                          <Truck size={16} className="animate-bounce" /> Domicilios: {ad.delivery_info}
                        </div>
                     )}
                     <div className="flex items-center gap-2 bg-green-50 text-green-700 px-5 py-2.5 rounded-2xl text-[9px] font-black uppercase tracking-[0.2em] border border-green-100">
                       <ShieldCheck size={16} className="text-green-500" /> Verificado por KLICUS
                     </div>
                   </div>
                 </div>

                 <div className="pt-12 border-t border-border/50">
                   <h2 className="text-[10px] font-black uppercase tracking-[0.3em] text-secondary/30 mb-8 flex items-center gap-3">
                     <Info size={14} strokeWidth={2.5} /> Descripción Detallada
                   </h2>
                   <div className="prose prose-zinc max-w-none">
                     <p className="text-xl leading-[1.8] text-secondary/80 font-medium whitespace-pre-wrap italic">
                       {cleanDescription(ad.description)}
                     </p>
                   </div>
                 </div>

                 {/* Information Grid: Professional Attributes */}
                 <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mt-12">
                    {ad.address && (
                      <div className="p-8 rounded-[2.5rem] bg-secondary text-white border border-secondary group hover:scale-[1.02] transition-all relative overflow-hidden md:col-span-2">
                        <div className="absolute top-0 right-0 w-32 h-32 bg-white/5 rounded-full -translate-x-1/2 -translate-y-1/2 blur-2xl" />
                        <span className="text-[9px] font-black uppercase text-white/30 tracking-[0.2em] block mb-2">Ubicación Física</span>
                        <div className="flex items-center justify-between gap-3 relative z-10">
                           <div className="flex items-center gap-3">
                            <Building2 size={24} className="text-primary" />
                            <p className="text-xl font-black italic">{ad.address}</p>
                           </div>
                           <a 
                             href={`https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(ad.address + ' ' + ad.location)}`}
                             target="_blank"
                             rel="noopener noreferrer"
                             className="flex items-center gap-2 px-4 py-2 bg-white text-secondary rounded-xl text-[9px] font-black uppercase tracking-widest hover:bg-primary transition-all"
                           >
                             <NavIcon size={12} /> Cómo llegar
                           </a>
                        </div>
                      </div>
                    )}

                    {ad.phone && (
                      <div className="p-8 rounded-[2.5rem] bg-[#F5F5F7] border border-border/20 group hover:bg-white hover:shadow-xl transition-all">
                        <span className="text-[9px] font-black uppercase text-secondary/30 tracking-[0.2em] block mb-2">Línea de Atención</span>
                        <div className="flex items-center gap-3">
                           <Phone size={20} className="text-secondary/40 group-hover:text-primary transition-colors" />
                           <p className="text-2xl font-black text-secondary">{ad.phone}</p>
                        </div>
                      </div>
                    )}
                    {ad.business_hours && (
                      <div className="p-8 rounded-[2.5rem] bg-[#F5F5F7] border border-border/20 group hover:bg-white hover:shadow-xl transition-all">
                        <span className="text-[9px] font-black uppercase text-secondary/30 tracking-[0.2em] block mb-2">Horario Comercial</span>
                        <div className="flex items-center gap-3">
                           <Clock size={20} className="text-secondary/40 group-hover:text-primary transition-colors" />
                           <p className="text-xl font-black text-secondary">{ad.business_hours}</p>
                        </div>
                      </div>
                    )}
                    {ad.email && (
                      <div className="p-8 rounded-[2.5rem] bg-[#F5F5F7] border border-border/20 group hover:bg-white hover:shadow-xl transition-all md:col-span-2">
                        <span className="text-[9px] font-black uppercase text-secondary/30 tracking-[0.2em] block mb-2">Correo Corporativo</span>
                        <div className="flex items-center gap-3 overflow-hidden">
                           <Mail size={20} className="text-secondary/40 group-hover:text-primary transition-colors" />
                           <p className="text-xl font-black text-secondary truncate">{ad.email}</p>
                        </div>
                      </div>
                    )}

                    {/* Elite Social Media Block */}
                    {(ad.facebook_url || ad.instagram_url) && (
                      <div className="md:col-span-2 pt-12 border-t border-border/50">
                        <h2 className="text-[10px] font-black uppercase tracking-[0.3em] text-secondary/30 mb-8 flex items-center gap-3 text-center justify-center">
                          <Crown size={14} strokeWidth={2.5} /> Canales Digitales Oficiales
                        </h2>
                        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                           {ad.facebook_url && (
                             <a 
                               href={ad.facebook_url} 
                               target="_blank" 
                               rel="noopener noreferrer"
                               className="flex items-center justify-between p-6 px-8 rounded-3xl bg-[#1877F2] text-white hover:scale-[1.02] transition-all shadow-xl shadow-blue-500/10 group"
                             >
                                <div className="flex items-center gap-4">
                                  <svg className="w-8 h-8 fill-white" viewBox="0 0 24 24"><path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-0.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/></svg>
                                  <span className="font-black italic text-lg">Facebook</span>
                                </div>
                                <ArrowRight size={20} className="group-hover:translate-x-2 transition-transform" />
                             </a>
                           )}
                           {ad.instagram_url && (
                             <a 
                               href={ad.instagram_url} 
                               target="_blank" 
                               rel="noopener noreferrer"
                               className="flex items-center justify-between p-6 px-8 rounded-3xl bg-gradient-to-tr from-[#f9ce34] via-[#ee2a7b] to-[#6228d7] text-white hover:scale-[1.02] transition-all shadow-xl shadow-pink-500/10 group"
                             >
                                <div className="flex items-center gap-4">
                                  <svg className="w-8 h-8 fill-none stroke-white stroke-[2]" viewBox="0 0 24 24" strokeLinecap="round" strokeLinejoin="round"><rect x="2" y="2" width="20" height="20" rx="5" ry="5"></rect><path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z"></path><line x1="17.5" y1="6.5" x2="17.51" y2="6.5"></line></svg>
                                  <span className="font-black italic text-lg">Instagram</span>
                                </div>
                                <ArrowRight size={20} className="group-hover:translate-x-2 transition-transform" />
                             </a>
                           )}
                        </div>
                      </div>
                    )}
                 </div>
               </div>
            </section>
          </div>

          {/* RIGHT: CONVERSION SIDEBAR (30%) */}
          <aside className="lg:col-span-4 space-y-10 sticky top-32">
            
            {/* CTA Master Card */}
            <div className="bg-white rounded-[3.5rem] p-10 shadow-[0_32px_64px_-16px_rgba(0,0,0,0.1)] border border-border/50 relative overflow-hidden group">
               {/* Background Accent */}
               <div className="absolute -top-24 -right-24 w-48 h-48 bg-[#FFF159]/10 rounded-full blur-[80px] pointer-events-none" />
               
               <div className="mb-10 text-center lg:text-left">
                 <div className="inline-flex items-center gap-2 px-3 py-1 bg-secondary/5 text-secondary/60 rounded-full text-[9px] font-black uppercase tracking-[0.2em] mb-4">
                    Comienza la conversación
                 </div>
                 <div className="flex items-baseline justify-center lg:justify-start gap-2 overflow-hidden">
                   <span className="text-3xl font-black text-secondary tracking-tightest italic leading-none truncate max-w-full">
                     {ad.price_range || 'CONSULTAR'}
                   </span>
                   {(ad.price_range && ad.price_range.match(/^\d/)) && <span className="text-xs font-black text-secondary/40 uppercase tracking-widest leading-none">COP</span>}
                 </div>
               </div>

               <AdContactButtons 
                 adId={id} 
                 cellphone={ad.cellphone} 
                 phone={ad.phone || ad.cellphone} 
               />

               <div className="mt-10 pt-10 border-t border-border/50 space-y-6">
                 {ad.website_url && (
                    <a 
                      href={ad.website_url.startsWith('http') ? ad.website_url : `https://${ad.website_url}`} 
                      target="_blank" 
                      rel="noopener noreferrer"
                      className="w-full py-4 rounded-3xl bg-[#F5F5F7] border border-border/50 text-secondary font-black text-[10px] uppercase tracking-[0.2em] flex items-center justify-center gap-2 hover:bg-white transition-all shadow-sm group"
                    >
                      Sitio Web Oficial <ExternalLink size={14} className="group-hover:translate-x-1 group-hover:-translate-y-1 transition-transform" />
                    </a>
                 )}
                 <div className="flex items-center gap-4">
                   <div className="w-10 h-10 rounded-xl bg-green-50 flex items-center justify-center text-green-600">
                      <ShieldCheck size={20} />
                   </div>
                   <div>
                     <p className="text-[10px] font-black uppercase tracking-widest text-secondary leading-none mb-1">Negocio Seguro</p>
                     <p className="text-[9px] text-secondary/40 font-bold leading-tight">Verificado por nuestro equipo local.</p>
                   </div>
                 </div>
               </div>
            </div>

            {/* Profile Micro-Panel */}
            <div className="bg-secondary rounded-[3.5rem] p-10 text-white shadow-2xl shadow-secondary/20 relative overflow-hidden">
              <div className="absolute top-0 left-0 w-full h-full bg-gradient-to-br from-white/10 to-transparent pointer-events-none" />
              
              <div className="flex items-center gap-5 mb-8 relative z-10">
                <div className="w-20 h-20 rounded-[2.2rem] bg-white/10 border border-white/20 flex items-center justify-center text-3xl font-black overflow-hidden relative shadow-2xl">
                  {ad.avatar_url ? (
                    <Image src={ad.avatar_url} alt="Profile" fill className="object-cover" unoptimized={true} />
                  ) : (
                    <span className="text-primary italic">{(ad.profile_business_name?.[0] || ad.owner_name?.[0])}</span>
                  )}
                </div>
                <div>
                  <h3 className="text-2xl font-black tracking-tight italic text-primary leading-none mb-2">
                    {ad.profile_business_name || ad.owner_name}
                  </h3>
                  <div className="flex items-center gap-2">
                    <span className="w-1.5 h-1.5 rounded-full bg-green-400 animate-pulse" />
                    <p className="text-[9px] font-black uppercase text-white/40 tracking-widest">Socio KLICUS</p>
                  </div>
                </div>
              </div>
              
              <p className="text-sm text-white/50 leading-relaxed font-medium mb-10 relative z-10 italic">
                {ad.owner_bio || 'Este profesional gestiona su presencia digital con el respaldo de KLICUS Marketplace.'}
              </p>

              <Link 
                href="/" 
                className="w-full py-5 rounded-3xl bg-white text-secondary hover:bg-[#FFF159] transition-all font-black text-[10px] uppercase tracking-[0.25em] relative z-10 shadow-xl shadow-black/20 italic flex items-center justify-center gap-3 group"
              >
                Ver Directorio <ArrowRight size={14} className="group-hover:translate-x-2 transition-transform" />
              </Link>
            </div>
            
          </aside>
        </div>
      </main>

      {/* Global Contact Bar (Mobile Only) */}
      <MobileContactButtons 
        adId={id} 
        cellphone={ad.cellphone} 
        phone={ad.phone || ad.cellphone} 
      />
    </div>
  );
}
