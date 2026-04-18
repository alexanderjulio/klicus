'use client';

import { useState, useEffect } from 'react';
import { Search, User, FileText, Filter, Calendar, Activity } from 'lucide-react';
import AnalyticsDashboard from '../dashboard/AnalyticsDashboard';
import { cn } from '@/lib/utils';

export default function AdminAnalyticsExplorer() {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState({ userId: '', adId: '', days: '30' });

  async function fetchAnalytics() {
    setLoading(true);
    try {
      const query = new URLSearchParams(filter).toString();
      const res = await fetch(`/api/admin/analytics?${query}`);
      const json = await res.json();
      if (json.success) setData(json);
    } catch (error) {
      console.error('Error fetching admin analytics:', error);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    fetchAnalytics();
  }, [filter.days]); // Auto-fetch on days change

  const handleSearch = (e) => {
    e.preventDefault();
    fetchAnalytics();
  };

  return (
    <div className="space-y-10">
      {/* Search & Filters */}
      <div className="bg-white dark:bg-zinc-900 p-8 rounded-[3rem] border border-border/50 dark:border-white/5 shadow-xl">
        <form onSubmit={handleSearch} className="grid grid-cols-1 md:grid-cols-4 gap-6 items-end">
          <div className="md:col-span-1">
            <label className="text-[10px] font-black uppercase text-muted-foreground mb-3 block tracking-widest">Cliente (ID/Nombre)</label>
            <div className="relative">
              <User className="absolute left-4 top-1/2 -translate-y-1/2 text-muted-foreground" size={16} />
              <input 
                type="text" 
                placeholder="ID del usuario..."
                value={filter.userId}
                onChange={(e) => setFilter({...filter, userId: e.target.value})}
                className="w-full h-12 bg-muted/30 dark:bg-white/5 border-none rounded-2xl pl-12 pr-4 text-xs font-bold text-secondary dark:text-white focus:ring-2 ring-primary/50 transition-all shadow-inner"
              />
            </div>
          </div>
          
          <div className="md:col-span-1">
            <label className="text-[10px] font-black uppercase text-muted-foreground mb-3 block tracking-widest">Anuncio (ID)</label>
            <div className="relative">
              <FileText className="absolute left-4 top-1/2 -translate-y-1/2 text-muted-foreground" size={16} />
              <input 
                type="text" 
                placeholder="ID del anuncio..."
                value={filter.adId}
                onChange={(e) => setFilter({...filter, adId: e.target.value})}
                className="w-full h-12 bg-muted/30 dark:bg-white/5 border-none rounded-2xl pl-12 pr-4 text-xs font-bold text-secondary dark:text-white focus:ring-2 ring-primary/50 transition-all shadow-inner"
              />
            </div>
          </div>

          <div className="md:col-span-1">
            <label className="text-[10px] font-black uppercase text-muted-foreground mb-3 block tracking-widest">Período</label>
            <div className="relative">
              <Calendar className="absolute left-4 top-1/2 -translate-y-1/2 text-muted-foreground" size={16} />
              <select 
                value={filter.days}
                onChange={(e) => setFilter({...filter, days: e.target.value})}
                className="w-full h-12 bg-muted/30 dark:bg-white/5 border-none rounded-2xl pl-12 pr-4 text-xs font-bold text-secondary dark:text-white focus:ring-2 ring-primary/50 transition-all appearance-none cursor-pointer"
              >
                <option value="7">Últimos 7 días</option>
                <option value="30">Últimos 30 días</option>
                <option value="90">Últimos 90 días</option>
              </select>
            </div>
          </div>

          <button 
            type="submit"
            className="h-12 bg-secondary dark:bg-primary text-white dark:text-secondary rounded-2xl font-black text-xs uppercase tracking-widest hover:scale-[1.02] active:scale-95 transition-all shadow-lg shadow-secondary/20 dark:shadow-primary/10 flex items-center justify-center gap-2"
          >
            <Search size={16} /> BUSCAR MÉTRICAS
          </button>
        </form>
      </div>

      {loading ? (
        <div className="py-24 text-center">
          <Activity className="mx-auto mb-4 text-primary animate-spin" size={32} />
          <p className="text-xs font-black text-muted-foreground uppercase tracking-widest">Explorando patrones de datos...</p>
        </div>
      ) : (
        <AnalyticsDashboard 
          data={data} 
          title="Resultados del Explorador"
        />
      )}
    </div>
  );
}
