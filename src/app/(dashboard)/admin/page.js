'use client';

import { useState, useEffect } from 'react';
import {
  Users, FileText, CreditCard, Activity,
  TrendingUp, ArrowUpRight, Check, X, Clock,
  LayoutDashboard, Settings, LogOut, Bell, ShieldCheck
} from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import AdminChart from '@/components/admin/AdminChart';
import NotificationCenter from '@/components/NotificationCenter';
import AdminAnalyticsExplorer from '@/components/admin/AdminAnalyticsExplorer';
import { cn } from '@/lib/utils';
import Link from 'next/link';

export default function AdminDashboard() {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [activeTab, setActiveTab] = useState('overview');
  const [processing, setProcessing] = useState(null);
  const [lastUpdated, setLastUpdated] = useState(null);
  const [refreshing, setRefreshing] = useState(false);

  async function fetchStats(isManual = false) {
    if (isManual) setRefreshing(true);
    try {
      const res = await fetch('/api/admin/stats');
      const json = await res.json();
      setData(json.data);
      setLastUpdated(new Date());
    } catch (error) {
      console.error('Failed to fetch admin stats:', error);
    } finally {
      setLoading(false);
      if (isManual) setRefreshing(false);
    }
  }

  useEffect(() => {
    fetchStats();
    const interval = setInterval(() => fetchStats(), 30000);
    return () => clearInterval(interval);
  }, []);

  const handleAction = async (adId, status) => {
    setProcessing(adId);
    try {
      const res = await fetch('/api/admin/approve-ad', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ adId, status }),
      });
      if (res.ok) {
        // Refresh data
        await fetchStats();
      }
    } catch (err) {
      console.error('Error in admin action:', err);
    } finally {
      setProcessing(null);
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-[#F8F9FA] dark:bg-zinc-950 flex items-center justify-center">
        <div className="text-center">
          <div className="w-16 h-16 border-4 border-primary border-t-transparent rounded-full animate-spin mx-auto mb-4"></div>
          <p className="text-secondary dark:text-white font-black uppercase tracking-widest text-xs">Cargando KLICUS Admin...</p>
        </div>
      </div>
    );
  }

  const statCards = [
    { label: 'Usuarios Totales', value: data?.stats?.users || '0', icon: <Users size={20} />, trend: '+12%', color: 'from-blue-500 to-cyan-500' },
    { label: 'Pautas Activas', value: data?.stats?.activeAds || '0', icon: <FileText size={20} />, trend: '+5%', color: 'from-amber-500 to-orange-500' },
    { label: 'Ingresos Mes', value: `$${(data?.stats?.revenue || 0).toLocaleString()}`, icon: <CreditCard size={20} />, trend: '+18%', color: 'from-emerald-500 to-teal-500' },
    { label: 'Pautas Pendientes', value: data?.stats?.pendingAds || '0', icon: <Clock size={20} />, trend: 'Pendiente', color: 'from-indigo-500 to-purple-500' },
  ];

  return (
    <div className="min-h-screen bg-[#F8F9FA] dark:bg-zinc-950 transition-colors duration-500 font-sans">
      {/* Sidebar / Top Nav Area */}
      <nav className="fixed top-0 left-0 right-0 z-50 bg-white/80 dark:bg-zinc-900/80 backdrop-blur-xl border-b border-border/50 dark:border-white/5 py-4 px-8 flex items-center justify-between">
        <div className="flex items-center gap-8">
          <Link href="/" className="text-xl font-black italic tracking-tighter text-secondary dark:text-white group">
            KLICUS<span className="text-primary group-hover:animate-pulse">.</span>ADMIN
          </Link>
          <div className="hidden md:flex items-center gap-1 bg-muted/30 dark:bg-white/5 p-1 rounded-xl">
             <button 
               onClick={() => setActiveTab('overview')}
               className={cn(
                 "px-4 py-2 rounded-lg text-xs font-black transition-all",
                 activeTab === 'overview' ? "bg-white dark:bg-zinc-800 text-secondary dark:text-white shadow-sm" : "text-muted-foreground hover:text-secondary dark:hover:text-white"
               )}
             >
               VISTA GENERAL
             </button>
             <button 
               onClick={() => setActiveTab('pautas')}
               className={cn(
                 "px-4 py-2 rounded-lg text-xs font-black transition-all",
                 activeTab === 'pautas' ? "bg-white dark:bg-zinc-800 text-secondary dark:text-white shadow-sm" : "text-muted-foreground hover:text-secondary dark:hover:text-white"
               )}
             >
               APROBACIONES
             </button>
             <button 
               onClick={() => setActiveTab('analytics')}
               className={cn(
                 "px-4 py-2 rounded-lg text-xs font-black transition-all",
                 activeTab === 'analytics' ? "bg-white dark:bg-zinc-800 text-secondary dark:text-white shadow-sm" : "text-muted-foreground hover:text-secondary dark:hover:text-white"
               )}
             >
               ANÁLISIS
             </button>
          </div>
        </div>
        <div className="flex items-center gap-4">
          {lastUpdated && (
            <div className="hidden sm:flex items-center gap-2 px-3 py-1.5 bg-emerald-50 dark:bg-emerald-500/10 rounded-full">
              <span className="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse" />
              <span className="text-[10px] font-black text-emerald-600 dark:text-emerald-400 uppercase tracking-widest">
                LIVE · {lastUpdated.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', second: '2-digit' })}
              </span>
            </div>
          )}
          <button
            onClick={() => fetchStats(true)}
            disabled={refreshing}
            title="Actualizar ahora"
            className="p-2.5 rounded-full bg-muted/30 dark:bg-white/5 text-secondary dark:text-white transition-all hover:scale-110 disabled:opacity-50"
          >
            <Activity size={18} className={refreshing ? 'animate-spin' : ''} />
          </button>
          <NotificationCenter />
          <div className="w-10 h-10 rounded-full bg-gradient-to-tr from-primary to-amber-300 border-2 border-white dark:border-zinc-800 shadow-lg" />
        </div>
      </nav>

      <main className="container mx-auto px-6 pt-32 pb-24">
        {/* Header */}
        <header className="mb-12 text-secondary dark:text-white">
          <motion.div 
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            className="flex flex-col md:flex-row md:items-end justify-between gap-6"
          >
            <div>
              <h1 className="text-5xl font-black tracking-tighter leading-none mb-2 italic">
                {activeTab === 'analytics' ? 'Explorador de' : 'Bienvenido,'} <span className="text-primary">{activeTab === 'analytics' ? 'Analítica' : 'Admin'}</span>
              </h1>
              <p className="text-muted-foreground font-medium text-lg">
                {activeTab === 'analytics' ? 'Filtra métricas por cliente o anuncio individual.' : 'Métricas clave y estado global de la plataforma.'}
              </p>
            </div>
            {activeTab !== 'analytics' && (
              <div className="flex gap-3">
                <button className="px-6 h-14 bg-white dark:bg-zinc-900 border border-border dark:border-white/5 rounded-2xl font-black text-sm text-secondary dark:text-white hover:bg-muted dark:hover:bg-white/10 transition-all flex items-center gap-2">
                  Descargar Reporte
                </button>
                <button className="px-8 h-14 bg-secondary dark:bg-primary text-white dark:text-secondary rounded-2xl font-black text-sm hover:opacity-90 transition-all shadow-xl shadow-secondary/20 dark:shadow-primary/10">
                  Exportar CSV
                </button>
              </div>
            )}
          </motion.div>
        </header>

        {activeTab === 'analytics' ? (
          <motion.div
            initial={{ opacity: 0, scale: 0.98 }}
            animate={{ opacity: 1, scale: 1 }}
          >
            <AdminAnalyticsExplorer />
          </motion.div>
        ) : (
          <>
            {/* Stats Grid */}
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-12">
          {statCards.map((stat, i) => (
            <motion.div 
              key={i} 
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: i * 0.1 }}
              className="group bg-white dark:bg-zinc-900/50 backdrop-blur-sm p-8 rounded-[2.5rem] border border-border/50 dark:border-white/5 shadow-sm hover:shadow-2xl hover:-translate-y-1 transition-all duration-500 relative overflow-hidden"
            >
              <div className={cn(
                "absolute -top-12 -right-12 w-24 h-24 bg-gradient-to-br blur-3xl opacity-0 group-hover:opacity-30 transition-opacity", 
                stat.color
              )} />
              
              <div className="flex justify-between items-start mb-8 relative z-10">
                <div className={cn(
                  "p-4 rounded-2xl bg-gradient-to-br text-white group-hover:rotate-12 transition-transform shadow-lg",
                  stat.color
                )}>
                  {stat.icon}
                </div>
                <div className="flex items-center gap-1 text-emerald-600 dark:text-emerald-400 bg-emerald-50 dark:bg-emerald-500/10 px-3 py-1 rounded-full text-[10px] font-black tracking-tighter uppercase whitespace-nowrap">
                  <ArrowUpRight size={12} /> {stat.trend}
                </div>
              </div>
              <div className="relative z-10">
                <div className="text-4xl font-black text-secondary dark:text-white tracking-tighter leading-none mb-1">{stat.value}</div>
                <div className="text-[10px] font-black text-muted-foreground uppercase tracking-widest">{stat.label}</div>
              </div>
            </motion.div>
          ))}
        </div>

        {/* Middle Section: Chart and Quick Actions */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8 mb-12">
          {/* Main Chart Section */}
          <div className="lg:col-span-2 bg-white dark:bg-zinc-900 rounded-[3rem] p-10 border border-border/50 dark:border-white/5 shadow-xl">
            <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 mb-10">
              <div>
                <h2 className="text-2xl font-black text-secondary dark:text-white flex items-center gap-3 italic">
                  <TrendingUp size={28} className="text-primary" /> Rendimiento Semanal
                </h2>
                <p className="text-sm text-muted-foreground font-medium mt-1">Clics acumulados en pautas diamante/pro.</p>
              </div>
              <div className="flex gap-2 p-1.5 bg-muted/30 dark:bg-white/5 rounded-xl">
                 <button className="px-4 py-2 bg-white dark:bg-zinc-800 rounded-lg text-[10px] font-black text-secondary dark:text-white shadow-sm">SEMANA</button>
                 <button className="px-4 py-2 text-[10px] font-black text-muted-foreground hover:text-secondary dark:hover:text-white">MES</button>
              </div>
            </div>
            
            <AdminChart data={data?.chartData || []} />
          </div>

          {/* Side Info / Quick Action */}
          <div className="flex flex-col gap-6">
            <div className="bg-secondary text-white p-10 rounded-[3.5rem] shadow-2xl relative overflow-hidden flex-1 group">
              <div className="relative z-10 flex flex-col h-full justify-between">
                <div>
                  <h3 className="text-3xl font-black mb-4 leading-tight italic tracking-tighter text-primary">Precios de Pautas</h3>
                  <p className="text-white/60 text-base mb-10 font-medium">Control global de los valores comerciales del Marketplace.</p>
                  
                  <div className="space-y-6">
                     <div className="flex justify-between items-center py-4 border-b border-white/10 group-hover:border-primary/30 transition-colors">
                       <span className="text-xs font-black opacity-60 uppercase tracking-widest">Plan Pro</span>
                       <span className="text-xl font-black text-white">$45.000 <span className="text-[10px] opacity-50">COP</span></span>
                     </div>
                     <div className="flex justify-between items-center py-4 border-b border-white/10 group-hover:border-primary/30 transition-colors">
                       <span className="text-xs font-black opacity-60 uppercase tracking-widest text-primary">Plan Diamante</span>
                       <span className="text-xl font-black text-primary">$99.000 <span className="text-[10px] opacity-50">COP</span></span>
                     </div>
                  </div>
                </div>

                <button className="w-full h-16 bg-primary text-secondary py-4 rounded-2xl font-black text-sm uppercase tracking-widest hover:scale-[1.02] active:scale-95 transition-all shadow-2xl shadow-primary/20 mt-10">
                  Ajustar Tarifas
                </button>
              </div>
              {/* Decorative background visual */}
              <div className="absolute -bottom-16 -right-16 w-48 h-48 bg-primary/20 rounded-full blur-[80px] pointer-events-none group-hover:bg-primary/30 transition-colors" />
            </div>
          </div>
        </div>

        {/* Bottom Section: Approvals Queue (Conditional) */}
        <AnimatePresence>
          {(data?.stats?.pendingAds > 0 || true) && (
            <motion.div 
              initial={{ opacity: 0, scale: 0.95 }}
              animate={{ opacity: 1, scale: 1 }}
              exit={{ opacity: 0, scale: 0.95 }}
              className="mt-12"
            >
              <div className="bg-white dark:bg-zinc-900 rounded-[3rem] p-10 border-2 border-primary/20 shadow-2xl shadow-primary/5">
                <div className="flex items-center justify-between mb-8">
                  <div>
                    <h3 className="text-2xl font-black text-secondary dark:text-white flex items-center gap-3">
                      <LayoutDashboard size={28} className="text-primary animate-pulse" /> Cola de Aprobaciones
                    </h3>
                    <p className="text-muted-foreground font-medium mt-1">Hay {data?.stats?.pendingAds || 3} pautas esperando revisión táctica.</p>
                  </div>
                  <Link href="/admin/pautas" className="bg-secondary/5 dark:bg-white/5 text-secondary dark:text-white px-6 py-3 rounded-xl font-black text-xs uppercase tracking-widest hover:bg-secondary hover:text-white dark:hover:bg-primary dark:hover:text-secondary transition-all">
                    Ver todas
                  </Link>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                  {(data?.queue || []).map((ad) => (
                    <div key={ad.id} className="p-6 rounded-3xl bg-[#F8F9FA] dark:bg-white/5 border border-border/50 dark:border-white/5 flex flex-col gap-4 group hover:border-primary/50 transition-all">
                      <div className="flex items-center justify-between">
                        <div className="flex items-center gap-4">
                          <div className="w-14 h-14 rounded-2xl bg-muted dark:bg-zinc-800 overflow-hidden shadow-inner flex items-center justify-center">
                             <FileText size={24} className="text-muted-foreground" />
                          </div>
                          <div>
                            <h4 className="font-black text-secondary dark:text-white italic text-sm line-clamp-1">{ad.title}</h4>
                            <p className="text-[10px] font-bold text-muted-foreground uppercase opacity-60">Creado: {new Date(ad.created_at).toLocaleDateString()}</p>
                          </div>
                        </div>
                        <div className="flex gap-2">
                          <button 
                            onClick={() => handleAction(ad.id, 'active')}
                            disabled={processing === ad.id}
                            className="w-10 h-10 rounded-xl bg-emerald-500/10 text-emerald-600 hover:bg-emerald-500 hover:text-white transition-all flex items-center justify-center shadow-lg shadow-emerald-500/10 disabled:opacity-50"
                          >
                            <Check size={18} />
                          </button>
                          <button 
                            onClick={() => handleAction(ad.id, 'paused')}
                            disabled={processing === ad.id}
                            className="w-10 h-10 rounded-xl bg-red-500/10 text-red-600 hover:bg-red-500 hover:text-white transition-all flex items-center justify-center shadow-lg shadow-red-500/10 disabled:opacity-50"
                          >
                            <X size={18} />
                          </button>
                        </div>
                      </div>

                      {/* Payment Badges */}
                      <div className="flex items-center gap-2 pt-2 border-t border-border/10">
                        {ad.billing_status === 'paid' ? (
                          <span className="px-3 py-1 bg-emerald-100 text-emerald-700 dark:bg-emerald-500/20 dark:text-emerald-400 rounded-lg text-[9px] font-black uppercase tracking-widest flex items-center gap-1">
                            <ShieldCheck size={10} strokeWidth={3} /> PAGADA
                          </span>
                        ) : (
                          <span className="px-3 py-1 bg-amber-100 text-amber-700 dark:bg-amber-500/20 dark:text-amber-400 rounded-lg text-[9px] font-black uppercase tracking-widest flex items-center gap-1">
                            <Clock size={10} strokeWidth={3} /> PENDIENTE PAGO
                          </span>
                        )}
                        <span className="px-3 py-1 bg-secondary text-white dark:bg-white/10 dark:text-white rounded-lg text-[9px] font-black uppercase tracking-widest">
                          {ad.plan_type || 'Básico'}
                        </span>
                      </div>
                    </div>
                  ))}
                  {(!data?.queue || data.queue.length === 0) && (
                    <div className="col-span-full py-12 text-center">
                       <p className="text-muted-foreground font-medium">No hay pautas pendientes de aprobación.</p>
                    </div>
                  )}
                </div>
              </div>
            </motion.div>
          )}
        </AnimatePresence>
        </>
        )}
      </main>
    </div>
  );
}
