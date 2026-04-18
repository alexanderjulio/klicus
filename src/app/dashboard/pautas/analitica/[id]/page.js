'use client';

import { useState, useEffect, useCallback } from 'react';
import { useParams, useRouter } from 'next/navigation';
import { ArrowLeft, Activity, Info, Calendar } from 'lucide-react';
import Link from 'next/link';
import AnalyticsDashboard from '@/components/dashboard/AnalyticsDashboard';
import { motion } from 'framer-motion';
import { useToast } from '@/context/ToastContext';

export default function UserAnalyticsPage() {
  const params = useParams();
  const router = useRouter();
  const { showToast } = useToast();
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);

  const fetchStats = useCallback(async (startDate = '', endDate = '') => {
    try {
      let url = `/api/user/analytics/${params.id}`;
      if (startDate && endDate) {
        url += `?startDate=${startDate}&endDate=${endDate}`;
      }
      
      const res = await fetch(url);
      const json = await res.json();
      if (json.success) {
        setData(json);
      } else {
        console.error('Analytics Error:', json.error);
        if (startDate) showToast('Error al filtrar fechas', 'error');
      }
    } catch (error) {
      console.error('Failed to fetch analytics:', error);
      showToast('Error de conexión', 'error');
    } finally {
      setLoading(false);
    }
  }, [params.id, showToast]);

  useEffect(() => {
    fetchStats();
  }, [fetchStats]);

  if (loading) {
    return (
      <div className="min-h-screen bg-[#F8F9FA] dark:bg-zinc-950 flex items-center justify-center">
        <div className="text-center">
            <Activity className="text-primary animate-spin mx-auto mb-4" size={32} />
            <p className="text-[10px] font-black uppercase tracking-widest text-muted-foreground animate-pulse">Consultando Inteligencia de Datos...</p>
        </div>
      </div>
    );
  }

  const formattedDate = data?.createdAt 
    ? new Date(data.createdAt).toLocaleDateString('es-ES', { day: '2-digit', month: 'long', year: 'numeric' })
    : null;

  return (
    <div className="min-h-screen bg-[#F8F9FA] dark:bg-zinc-950 transition-colors duration-500 font-sans">
      <main className="container mx-auto px-6 pt-32 pb-24">
        {/* Header */}
        <header className="mb-12">
          <Link 
            href="/dashboard" 
            className="inline-flex items-center gap-3 bg-primary hover:bg-primary/90 px-6 py-3 rounded-2xl text-[10px] font-black text-secondary transition-all uppercase tracking-[0.2em] group shadow-xl shadow-primary/20 mb-10"
          >
            <ArrowLeft size={16} className="group-hover:-translate-x-1 transition-transform" /> 
            Volver al Dashboard
          </Link>
          
          <motion.div 
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            className="flex flex-col md:flex-row md:items-end justify-between gap-6"
          >
            <div>
              <div className="flex items-center gap-3 mb-2">
                <span className="text-[10px] font-black uppercase tracking-[0.3em] text-primary block">Inteligencia de Datos</span>
                {formattedDate && (
                  <div className="flex items-center gap-1.5 px-3 py-1 bg-muted/30 dark:bg-white/5 rounded-full border border-border/50">
                    <Calendar size={10} className="text-muted-foreground" />
                    <span className="text-[9px] font-bold text-muted-foreground uppercase tracking-wider">Creada el {formattedDate}</span>
                  </div>
                )}
              </div>
              <h1 className="text-5xl font-black text-secondary dark:text-white tracking-tighter leading-none italic">
                Rendimiento de <br /><span className="text-primary truncate block max-w-4xl">{data?.adTitle || 'Tu Pauta'}</span>
              </h1>
              <p className="text-muted-foreground font-medium text-lg mt-2 italic">Métricas de interacción y conversión en tiempo real.</p>
            </div>
          </motion.div>
        </header>

        {data ? (
          <AnalyticsDashboard 
            data={data} 
            title="Estadísticas Detalladas" 
            onDateChange={fetchStats}
            showToast={showToast}
          />
        ) : (
          <div className="bg-white dark:bg-zinc-900 rounded-[3rem] p-20 text-center border-2 border-dashed border-border/50">
             <Info className="mx-auto mb-6 text-muted-foreground opacity-20" size={48} />
             <h3 className="text-xl font-black text-secondary dark:text-white mb-2 italic">Sin datos suficientes</h3>
             <p className="text-muted-foreground max-w-md mx-auto">Tu pauta aún no tiene interacciones registradas. Comparte tu anuncio para empezar a medir resultados.</p>
          </div>
        )}
      </main>
    </div>
  );
}
