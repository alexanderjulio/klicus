'use client';

import { useState, useEffect } from 'react';
import { 
  Users, FileText, Activity, TrendingUp, 
  ArrowUpRight, Edit3, Eye, MoreVertical, 
  Plus, CheckCircle2, Clock, AlertCircle,
  Smartphone, BarChart3, ChevronRight, Layout,
  Sparkles, ExternalLink, Zap, User, LogOut
} from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import Link from 'next/link';
import { useSession, signOut } from 'next-auth/react';
import NotificationCenter from '@/components/NotificationCenter';
import { cn } from '@/lib/utils';

/**
 * KLICUS Advertiser Dashboard - Elite Edition
 * The high-performance mission control for business owners.
 */

export default function AdvertiserDashboard() {
  const { data: session } = useSession();
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [showUpgradeModal, setShowUpgradeModal] = useState(false);
  const [upgradingId, setUpgradingId] = useState(null);

  useEffect(() => {
    async function fetchStats() {
      try {
        const res = await fetch('/api/user/dashboard-stats');
        const json = await res.json();
        setData(json);
      } catch (error) {
        console.error('Failed to fetch user dashboard stats:', error);
      } finally {
        setTimeout(() => setLoading(false), 800);
      }
    }
    fetchStats();
  }, []);

  const handleUpgrade = async (adId) => {
    setUpgradingId(adId);
    try {
      const res = await fetch('/api/payments/checkout', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ adId, planId: 'diamond' })
      });
      const json = await res.json();
      if (json.success && json.initPoint) {
        window.location.href = json.initPoint;
      } else {
        alert('Error al iniciar el pago: ' + (json.error || 'Intenta de nuevo'));
      }
    } catch (error) {
      console.error('Upgrade error:', error);
    } finally {
      setUpgradingId(null);
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-[#F5F5F7] flex items-center justify-center">
        <div className="text-center">
          <div className="w-16 h-16 border-4 border-primary border-t-transparent rounded-full animate-spin mx-auto mb-4"></div>
          <p className="text-[10px] font-black uppercase tracking-[0.3em] text-secondary/30 italic">Sincronizando Consola...</p>
        </div>
      </div>
    );
  }

  const stats = [
    { label: 'Pautas Activas', value: data?.stats?.activeAds || 0, icon: <Layout size={20} />, color: 'bg-emerald-500', glow: 'shadow-emerald-500/20' },
    { label: 'Clics Totales', value: data?.stats?.totalClicks || 0, icon: <Smartphone size={20} />, color: 'bg-primary', glow: 'shadow-primary/20' },
    { label: 'Impresiones', value: data?.stats?.totalViews || 0, icon: <Eye size={20} />, color: 'bg-blue-600', glow: 'shadow-blue-600/20' },
    { label: 'Pendientes', value: data?.stats?.pendingAds || 0, icon: <Clock size={20} />, color: 'bg-amber-500', glow: 'shadow-amber-500/20' },
  ];

  return (
    <div className="min-h-screen bg-[#F5F5F7] text-secondary pb-32">
      {/* Elite Atmosphere Header */}
      <div className="h-[40vh] bg-[#0E2244] relative flex items-center pt-20">
         {/* Background Decoration - Contained overflow here */}
         <div className="absolute inset-0 overflow-hidden pointer-events-none">
            <div className="absolute top-0 right-0 w-[50vw] h-full bg-primary/5 rounded-full blur-[120px]" />
            <div className="absolute bottom-[-10%] left-[-5%] w-64 h-64 bg-primary/10 rounded-full blur-[100px] animate-pulse" />
         </div>

         <div className="container mx-auto px-8 relative z-30 flex flex-col md:flex-row items-end justify-between gap-10">
            <div className="space-y-4">
              <div className="flex items-center gap-3">
                 <span className="px-3 py-1 bg-primary text-secondary text-[9px] font-black uppercase tracking-widest rounded-full">Socio KLICUS</span>
                 <div className="h-px w-8 bg-white/20" />
                 <span className="text-white/40 text-[9px] font-black uppercase tracking-widest">Dashboard de Control</span>
              </div>
              <h1 className="text-6xl md:text-7xl font-black text-white tracking-tightest leading-none italic">
                Bienvenido, <span className="text-primary italic">{session?.user?.name || 'Socio'}</span>
              </h1>
              <p className="text-white/50 font-medium text-lg max-w-xl italic leading-tight">
                Gestiona tus resultados comerciales y maximiza el impacto de tu marca en Ocaña.
              </p>
            </div>
            <div className="flex items-center gap-4 pb-2">
               <NotificationCenter />
               <Link 
                 href="/dashboard/perfil"
                 className="w-12 h-12 rounded-full bg-white/5 border border-white/10 flex items-center justify-center text-white hover:bg-white hover:text-secondary hover:scale-110 active:scale-90 transition-all shadow-xl"
                 title="Mi Perfil"
               >
                 <User size={20} />
               </Link>
               <button 
                 onClick={() => signOut({ callbackUrl: '/' })}
                 className="w-12 h-12 rounded-full bg-red-500/10 border border-red-500/20 flex items-center justify-center text-red-500 hover:bg-red-500 hover:text-white hover:scale-110 active:scale-90 transition-all shadow-xl"
                 title="Cerrar Sesión"
               >
                 <LogOut size={20} />
               </button>
               <Link 
                 href="/publicar" 
                 className="h-16 px-10 bg-primary text-secondary rounded-2xl font-black flex items-center gap-4 hover:scale-[1.05] active:scale-95 transition-all shadow-2xl shadow-primary/20 group"
               >
                 <Plus size={22} className="group-hover:rotate-90 transition-transform" /> 
                 <span className="text-[11px] uppercase tracking-widest">Nueva Pauta</span>
               </Link>
            </div>
         </div>
         <div className="absolute bottom-[-10%] left-[-5%] w-64 h-64 bg-primary/10 rounded-full blur-[100px] pointer-events-none animate-pulse" />
      </div>

      <main className="max-w-7xl mx-auto px-8 -mt-16 relative z-20">
        
        {/* Stats Row - Elite Cards */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-8 mb-20">
          {stats.map((stat, i) => (
            <motion.div 
              key={i}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: i * 0.1 }}
              className="bg-white p-8 rounded-[3rem] border border-white shadow-2xl shadow-secondary/5 relative overflow-hidden group hover:scale-[1.02] transition-all"
            >
              <div className="flex justify-between items-start mb-8">
                <div className={cn("p-4 rounded-2xl text-white shadow-lg transition-transform group-hover:rotate-12", stat.color, stat.glow)}>
                  {stat.icon}
                </div>
                <div className="text-4xl font-black text-secondary tracking-tighter italic">{stat.value}</div>
              </div>
              <p className="text-[10px] font-black uppercase tracking-[0.2em] text-secondary/30">{stat.label}</p>
              <div className={cn("absolute bottom-[-2rem] right-[-2rem] w-16 h-16 blur-2xl opacity-0 group-hover:opacity-20 transition-opacity", stat.color)} />
            </motion.div>
          ))}
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12">
          
          {/* Main List Section (8 Cols) */}
          <div className="lg:col-span-8 space-y-10">
            <div className="flex items-center justify-between border-b border-border/40 pb-6 mb-2">
               <h2 className="text-2xl font-black text-secondary flex items-center gap-4 italic tracking-tight">
                 <Zap size={24} className="text-primary fill-primary" /> Inventario Comercial
               </h2>
            </div>

            {data?.ads?.length === 0 ? (
              <div className="bg-white rounded-[4rem] p-24 text-center border-2 border-dashed border-border/40 shadow-inner">
                <div className="w-24 h-24 bg-[#F5F5F7] rounded-[2.5rem] flex items-center justify-center mx-auto mb-8">
                  <Plus size={40} className="text-secondary/20" />
                </div>
                <h3 className="text-2xl font-black text-secondary italic mb-4">Tu vitrina está vacía</h3>
                <p className="text-sm font-medium text-secondary/40 mb-10 max-w-xs mx-auto">Publica tu primer anuncio y empieza a conectar con miles de clientes potenciales.</p>
                <Link href="/publicar" className="h-14 inline-flex items-center px-10 bg-secondary text-white rounded-2xl font-black uppercase text-[10px] tracking-widest hover:bg-primary hover:text-secondary shadow-xl shadow-secondary/20 transition-all">Publicar ahora</Link>
              </div>
            ) : (
              <div className="space-y-6">
                {data?.ads?.map((ad, idx) => (
                  <motion.div 
                    key={ad.id}
                    initial={{ opacity: 0, x: -20 }}
                    animate={{ opacity: 1, x: 0 }}
                    transition={{ delay: idx * 0.05 }}
                    className="bg-white rounded-[3.5rem] p-8 border border-white shadow-2xl shadow-secondary/5 flex flex-col md:flex-row items-center gap-10 group hover:shadow-primary/10 transition-all border-l-8 border-l-transparent hover:border-l-primary"
                  >
                    <div className="w-40 h-32 rounded-3xl overflow-hidden bg-[#F5F5F7] shrink-0 relative shadow-inner">
                      <img src={ad.image_urls[0] || 'https://via.placeholder.com/300'} className="w-full h-full object-cover transition-transform group-hover:scale-110 duration-700" />
                      {ad.priority_level === 'diamond' && (
                        <div className="absolute top-2 right-2 p-1.5 bg-primary rounded-xl shadow-lg animate-bounce">
                          <Sparkles size={14} className="text-secondary" />
                        </div>
                      )}
                    </div>
                    
                    <div className="flex-1 text-center md:text-left space-y-3">
                      <div className="flex flex-wrap items-center justify-center md:justify-start gap-3">
                        {ad.status === 'active' && <span className="flex items-center gap-2 px-4 py-1.5 bg-emerald-50 text-emerald-600 text-[9px] font-black uppercase rounded-full border border-emerald-100"><CheckCircle2 size={12} /> Activo</span>}
                        {ad.status === 'pending' && <span className="flex items-center gap-2 px-4 py-1.5 bg-amber-50 text-amber-600 text-[9px] font-black uppercase rounded-full border border-amber-100"><Clock size={12} strokeWidth={3} /> Verificando</span>}
                        {ad.status === 'paused' && <span className="flex items-center gap-2 px-4 py-1.5 bg-zinc-100 text-zinc-600 text-[9px] font-black uppercase rounded-full border border-zinc-200"><AlertCircle size={12} /> Pausado</span>}
                        {ad.status === 'rejected' && <span className="flex items-center gap-2 px-4 py-1.5 bg-red-50 text-red-600 text-[9px] font-black uppercase rounded-full border border-red-100"><AlertCircle size={12} /> Rechazado</span>}
                        <span className="text-[10px] font-black text-secondary/20 uppercase tracking-widest">{ad.category_name}</span>
                      </div>
                      <h3 className="text-2xl font-black text-secondary tracking-tightest leading-tight italic truncate max-w-[300px]">{ad.title}</h3>
                      
                      {ad.status === 'rejected' && ad.rejection_reason && (
                        <div className="bg-red-500/5 border border-red-100 p-4 rounded-2xl mb-2">
                           <p className="text-[10px] font-black text-red-600 uppercase tracking-widest flex items-center gap-2 mb-1">
                             <AlertCircle size={12} /> Motivo del rechazo:
                           </p>
                           <p className="text-xs font-medium text-red-700 italic">"{ad.rejection_reason}"</p>
                        </div>
                      )}
                      <div className="flex items-center justify-center md:justify-start gap-6 text-[10px] font-bold text-secondary/40">
                         <span className="flex items-center gap-1.5"><Eye size={14} /> {ad.real_views || 0} vistas</span>
                         <span className="flex items-center gap-1.5"><Smartphone size={14} /> {ad.real_clicks || 0} clics</span>
                      </div>
                    </div>

                    <div className="flex gap-4 shrink-0">
                       <Link 
                         href={`/dashboard/pautas/analitica/${ad.id}`}
                         className="w-14 h-14 bg-[#F5F5F7] text-secondary/40 rounded-2xl flex items-center justify-center hover:bg-primary hover:text-secondary hover:scale-105 transition-all shadow-sm"
                         title="Analítica Detallada"
                       >
                         <BarChart3 size={20} />
                       </Link>
                       <Link 
                         href={`/dashboard/pautas/editar/${ad.id}`}
                         className="w-14 h-14 bg-[#F5F5F7] text-secondary/40 rounded-2xl flex items-center justify-center hover:bg-secondary hover:text-white hover:scale-105 transition-all shadow-sm"
                         title="Editar Pauta"
                       >
                         <Edit3 size={20} />
                       </Link>
                       <Link 
                         href={`/anuncio/${ad.id}`}
                         className="w-14 h-14 bg-primary text-secondary rounded-2xl flex items-center justify-center hover:scale-110 active:scale-90 transition-all shadow-xl shadow-primary/20"
                         title="Ir al Anuncio"
                       >
                         <ExternalLink size={20} />
                       </Link>
                    </div>
                  </motion.div>
                ))}
              </div>
            )}
          </div>

          {/* Sidebar (4 Cols) */}
          <div className="lg:col-span-4 space-y-10">
             {/* Only show upgrade CTA if there are ads that are NOT diamond */}
             {data?.ads?.some(ad => ad.priority_level !== 'diamond') && (
               <div className="bg-[#0E2244] p-12 rounded-[4rem] text-white shadow-2xl relative overflow-hidden group">
                  <div className="relative z-10">
                    <Sparkles size={40} className="text-primary mb-8" />
                    <h3 className="text-4xl font-black mb-6 leading-none italic tracking-tighter text-primary">Hazte <br />Irresistible</h3>
                    <p className="text-white/50 text-sm font-medium mb-10 leading-relaxed italic">
                      Los anuncios **Diamante** tienen prioridad absoluta en el buscador y generan 10 veces más contactos.
                    </p>
                    <button 
                      onClick={() => setShowUpgradeModal(true)}
                      className="w-full h-16 bg-primary text-secondary rounded-2xl font-black uppercase text-xs tracking-widest hover:scale-[1.05] transition-all shadow-inner active:scale-95"
                    >
                      Subir a Diamante
                    </button>
                  </div>
                  <div className="absolute -bottom-10 -right-10 w-48 h-48 bg-primary/10 rounded-full blur-[100px] pointer-events-none group-hover:scale-150 transition-transform duration-1000" />
               </div>
             )}

             <div className="bg-white p-10 rounded-[3.5rem] border border-white shadow-2xl shadow-secondary/5">
                <h4 className="text-[10px] font-black uppercase tracking-[0.3em] text-secondary/30 mb-8 flex items-center justify-between">
                  Gestión Contable
                  <Link href="/dashboard/pagos" className="text-primary hover:underline transition-all">Ver Facturas</Link>
                </h4>
                <div className="space-y-6">
                  {data?.recentBills?.length > 0 ? data.recentBills.map((bill) => (
                    <div key={bill.id} className="flex items-center justify-between pb-6 border-b border-border/20 last:border-0 group cursor-default">
                      <div>
                        <p className="text-sm font-black text-secondary italic group-hover:text-primary transition-colors">{bill.ad_title}</p>
                        <p className="text-[9px] font-bold text-secondary/20 uppercase tracking-widest">{new Date(bill.created_at).toLocaleDateString()}</p>
                      </div>
                      <div className="text-sm font-black text-secondary tracking-tighter">${bill.amount.toLocaleString()}</div>
                    </div>
                  )) : (
                    <div className="text-center py-6">
                       <p className="text-[10px] text-secondary/20 font-black uppercase tracking-widest italic">Sin registros de pago</p>
                    </div>
                  )}
                </div>
             </div>
          </div>
        </div>
      </main>

      {/* Premium Upgrade Selection Modal */}
      <AnimatePresence>
        {showUpgradeModal && (
          <div className="fixed inset-0 z-[100] flex items-center justify-center p-6">
            <motion.div 
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              onClick={() => setShowUpgradeModal(false)}
              className="absolute inset-0 bg-secondary/80 backdrop-blur-xl"
            />
            
            <motion.div 
              initial={{ opacity: 0, scale: 0.9, y: 20 }}
              animate={{ opacity: 1, scale: 1, y: 0 }}
              exit={{ opacity: 0, scale: 0.9, y: 20 }}
              className="relative bg-white rounded-[3.5rem] p-10 md:p-14 max-w-2xl w-full shadow-2xl border border-white overflow-hidden"
            >
              {/* Decorative Accent */}
              <div className="absolute top-0 right-0 w-48 h-48 bg-primary/5 rounded-full blur-3xl -translate-y-1/2 translate-x-1/2" />
              
              <div className="flex flex-col md:flex-row items-center gap-10 mb-12">
                 <div className="w-24 h-24 rounded-[2rem] bg-primary flex items-center justify-center text-secondary shadow-2xl shadow-primary/20 animate-pulse">
                    <Sparkles size={48} />
                 </div>
                 <div className="flex-1 text-center md:text-left">
                    <h3 className="text-4xl font-black text-secondary tracking-tightest leading-none mb-4 italic">Elige tu <span className="text-primary not-italic">Diamante</span></h3>
                    <p className="text-sm font-bold text-secondary/40 italic">Selecciona la pauta que deseas convertir en una vitrina imparable.</p>
                 </div>
              </div>

              <div className="max-h-[40vh] overflow-y-auto pr-2 space-y-4 mb-10 custom-scrollbar">
                {data?.ads?.filter(ad => ad.priority_level !== 'diamond').length === 0 ? (
                  <div className="py-12 text-center bg-zinc-50 rounded-3xl border border-dashed border-zinc-200">
                    <p className="text-xs font-black uppercase tracking-widest text-secondary/30">No hay anuncios disponibles para upgrade</p>
                  </div>
                ) : (
                  data?.ads?.filter(ad => ad.priority_level !== 'diamond').map(ad => (
                    <div key={ad.id} className="p-6 rounded-3xl bg-zinc-50 border border-zinc-100 flex items-center gap-6 group hover:bg-white hover:shadow-xl transition-all">
                       <div className="w-20 h-20 rounded-2xl overflow-hidden bg-zinc-200">
                         <img src={ad.image_urls[0]} className="w-full h-full object-cover" />
                       </div>
                       <div className="flex-1">
                          <h4 className="text-lg font-black text-secondary italic leading-tight mb-1">{ad.title}</h4>
                          <span className="text-[9px] font-black uppercase tracking-widest text-primary bg-secondary px-3 py-1 rounded-full">{ad.priority_level}</span>
                       </div>
                       <button 
                         onClick={() => handleUpgrade(ad.id)}
                         disabled={upgradingId === ad.id}
                         className={cn(
                           "px-6 py-3 rounded-xl bg-primary text-secondary font-black text-[10px] uppercase tracking-widest hover:scale-105 transition-all shadow-lg active:scale-95",
                           upgradingId === ad.id && "opacity-50 animate-pulse"
                         )}
                       >
                         {upgradingId === ad.id ? 'Cargando...' : 'Mejorar'}
                       </button>
                    </div>
                  ))
                )}
              </div>

              <div className="flex justify-center">
                 <button 
                   onClick={() => setShowUpgradeModal(false)}
                   className="text-[10px] font-black uppercase tracking-[0.3em] text-secondary/30 hover:text-secondary transition-colors"
                 >
                   Quizás más tarde
                 </button>
              </div>
            </motion.div>
          </div>
        )}
      </AnimatePresence>
    </div>
  );
}
