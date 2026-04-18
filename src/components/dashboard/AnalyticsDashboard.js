'use client';

import { useState, useEffect } from 'react';
import { 
  AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, 
  ResponsiveContainer, PieChart, Pie, Cell, Legend 
} from 'recharts';
import { motion, AnimatePresence } from 'framer-motion';
import { 
  TrendingUp, TrendingDown, MousePointer2, 
  Eye, Smartphone, Monitor, Calendar, Download,
  MessageCircle, BarChart3, Activity, Check, FileText, ChevronDown
} from 'lucide-react';
import { cn } from '@/lib/utils';
import * as XLSX from 'xlsx';
import { jsPDF } from 'jspdf';
import autoTable from 'jspdf-autotable';

const COLORS = ['#E2E000', '#1C1C1C', '#9CA3AF'];

export default function AnalyticsDashboard({ 
    data, 
    title = "Analítica Avanzada", 
    onDateChange,
    showToast = (msg, type) => console.log(`[Toast ${type}]: ${msg}`) // Fallback
}) {
  if (!data) return null;

  const { timeSeries, devices, totals, adTitle } = data;
  const [dateRange, setDateRange] = useState({ start: '', end: '' });
  const [isExportOpen, setIsExportOpen] = useState(false);

  const safeStats = data.stats || { views: 0, clicks: 0, contacts: 0, ctr: 0, installs: 0, sessions: 0 };
  const [downloadSuccess, setDownloadSuccess] = useState(false);

  // --- EXPORT LOGIC ---

  const exportToExcel = () => {
    try {
      if (!timeSeries || timeSeries.length === 0) {
        showToast('No hay datos para exportar.', 'warning');
        return;
      }

      const rows = timeSeries.map(day => ({
        'Fecha': day.date,
        'Vistas': day.views || 0,
        'Clics': day.clicks || 0,
        'Chat': day.chats || 0,
        'Contactos WA': day.contacts || 0
      }));

      // Add totals row
      rows.push({
        'Fecha': 'TOTALES',
        'Vistas': safeStats.views,
        'Clics': safeStats.clicks,
        'Chat': safeStats.chats,
        'Contactos WA': safeStats.contacts
      });

      const worksheet = XLSX.utils.json_to_sheet(rows);
      const workbook = XLSX.utils.book_new();
      XLSX.utils.book_append_sheet(workbook, worksheet, "Rendimiento");

      // Auto-size columns
      const max_width = rows.reduce((w, r) => Math.max(w, r.Fecha.length), 10);
      worksheet["!cols"] = [ { wch: max_width }, { wch: 10 }, { wch: 10 }, { wch: 15 } ];

      const fileName = `Klicus_Reporte_${(adTitle || 'Pauta').replace(/[^a-z0-9]/gi, '_')}.xlsx`;
      XLSX.writeFile(workbook, fileName);

      showToast('Excel generado con éxito', 'success');
      setDownloadSuccess(true);
      setTimeout(() => setDownloadSuccess(false), 3000);
      setIsExportOpen(false);
    } catch (error) {
      console.error('Excel Export error:', error);
      showToast('Error al generar Excel', 'error');
    }
  };

  const exportToPDF = () => {
    try {
      if (!timeSeries || timeSeries.length === 0) {
        showToast('No hay datos para exportar.', 'warning');
        return;
      }

      const doc = new jsPDF();
      
      // Header KLICUS
      doc.setFillColor(14, 34, 68); // #0E2244
      doc.rect(0, 0, 210, 40, 'F');
      
      doc.setTextColor(226, 224, 0); // #E2E000
      doc.setFontSize(22);
      doc.setFont("helvetica", "bold");
      doc.text("KLICUS INTELLIGENCE", 15, 25);
      
      doc.setTextColor(255, 255, 255);
      doc.setFontSize(10);
      doc.text("REPORTE DE RENDIMIENTO COMERCIAL", 15, 32);

      // Metada
      doc.setTextColor(28, 28, 28);
      doc.setFontSize(14);
      doc.text(`Pauta: ${adTitle || 'Sin Título'}`, 15, 55);
      
      doc.setFontSize(9);
      doc.setTextColor(100, 100, 100);
      doc.text(`Generado el: ${new Date().toLocaleString()}`, 15, 62);
      if (dateRange.start) {
        doc.text(`Periodo: ${dateRange.start} a ${dateRange.end || 'Hoy'}`, 15, 67);
      }

      // Summary Table
      autoTable(doc, {
        startY: 75,
        head: [['Métrica', 'Resultado Acumulado']],
        body: [
          ['Vistas Totales', safeStats.views],
          ['Clics Únicos', safeStats.clicks],
          ['Chats Iniciados', safeStats.chats],
          ['Contactos WhatsApp', safeStats.contacts],
          ['CTR Promedio', `${safeStats.ctr}%`],
          ['Conversión', `${safeStats.conversionRate}%`]
        ],
        theme: 'striped',
        headStyles: { fillColor: [14, 34, 68], textColor: [255, 255, 255] }
      });

      // Detailed History Table
      autoTable(doc, {
        startY: doc.lastAutoTable.finalY + 15,
        head: [['Fecha', 'Vistas', 'Clics', 'Chats', 'Contactos (WA)']],
        body: timeSeries.map(d => [d.date, d.views, d.clicks, d.chats, d.contacts]),
        theme: 'grid',
        headStyles: { fillColor: [226, 224, 0], textColor: [28, 28, 28] }
      });

      const fileName = `Klicus_Reporte_${(adTitle || 'Pauta').replace(/[^a-z0-9]/gi, '_')}.pdf`;
      doc.save(fileName);

      showToast('PDF generado con éxito', 'success');
      setDownloadSuccess(true);
      setTimeout(() => setDownloadSuccess(false), 3000);
      setIsExportOpen(false);
    } catch (error) {
      console.error('PDF Export error:', error);
      showToast('Error al generar PDF', 'error');
    }
  };

  return (
    <div className="space-y-10 animate-in fade-in duration-700">
      <style jsx>{`
        input[type="date"]::-webkit-calendar-picker-indicator {
          filter: invert(0.5) brightness(1.5);
          cursor: pointer;
        }
        .dark input[type="date"]::-webkit-calendar-picker-indicator {
          filter: invert(1) brightness(100%);
        }
      `}</style>
      {/* Header with Export - Added pr-14 to avoid close-button overlap */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-6 mb-4 md:pr-14">
         <div>
            <h2 className="text-2xl font-black text-secondary dark:text-white flex items-center gap-3 italic tracking-tighter">
              <Activity className="text-primary" /> {adTitle || title}
            </h2>
            <p className="text-muted-foreground text-xs font-medium">Visualización de tráfico y conversiones.</p>
         </div>
         <div className="flex items-center gap-4">
             {/* Presets */}
             <div className="hidden md:flex items-center gap-1 bg-muted/30 dark:bg-white/10 p-1.5 rounded-2xl border border-border/50 backdrop-blur-md">
                {['7D', '30D', '90D', 'Todo'].map((preset) => {
                    const isActive = (preset === '7D' && dateRange.start && !dateRange.end) || // Logic for current selection
                                   (preset === 'Todo' && !dateRange.start);
                    
                    return (
                        <button 
                            key={preset}
                            onClick={() => {
                                const end = new Date();
                                const start = new Date();
                                if (preset === '7D') start.setDate(end.getDate() - 7);
                                else if (preset === '30D') start.setDate(end.getDate() - 30);
                                else if (preset === '90D') start.setDate(end.getDate() - 90);
                                
                                const sStr = preset === 'Todo' ? '' : start.toISOString().split('T')[0];
                                const eStr = preset === 'Todo' ? '' : end.toISOString().split('T')[0];
                                
                                setDateRange({ start: sStr, end: eStr });
                                if (onDateChange) onDateChange(sStr, eStr);
                            }}
                            className={cn(
                                "px-4 py-2 rounded-xl text-[10px] font-black transition-all uppercase tracking-widest",
                                (dateRange.start === (preset === 'Todo' ? '' : new Date(new Date().setDate(new Date().getDate() - (preset === '7D' ? 7 : preset === '30D' ? 30 : 90))).toISOString().split('T')[0])) 
                                ? "bg-white dark:bg-zinc-800 text-secondary dark:text-white shadow-sm" 
                                : "text-muted-foreground hover:text-secondary dark:hover:text-white"
                            )}
                        >
                            {preset}
                        </button>
                    );
                })}
             </div>

             <div className="flex items-center gap-2 bg-white dark:bg-zinc-900 border border-border/50 p-2 rounded-2xl shadow-xl">
                <input 
                    type="date" 
                    value={dateRange.start} 
                    onChange={(e) => {
                        const newRange = { ...dateRange, start: e.target.value };
                        setDateRange(newRange);
                        if (newRange.start && newRange.end && onDateChange) onDateChange(newRange.start, newRange.end);
                    }}
                    className="bg-transparent border-none outline-none text-[10px] font-black text-secondary dark:text-white p-1 cursor-pointer"
                />
                <span className="text-primary text-[10px] font-black px-1">/</span>
                <input 
                    type="date" 
                    value={dateRange.end} 
                    onChange={(e) => {
                        const newRange = { ...dateRange, end: e.target.value };
                        setDateRange(newRange);
                        if (newRange.start && newRange.end && onDateChange) onDateChange(newRange.start, newRange.end);
                    }}
                    className="bg-transparent border-none outline-none text-[10px] font-black text-secondary dark:text-white p-1 cursor-pointer"
                />
             </div>

             <div className="relative">
               <button 
                 onClick={() => setIsExportOpen(!isExportOpen)}
                 className={cn(
                   "h-12 px-5 rounded-2xl flex items-center gap-3 transition-all shadow-xl font-black uppercase text-[10px] tracking-widest",
                   downloadSuccess 
                     ? "bg-emerald-500 text-white" 
                     : "bg-secondary text-white hover:bg-primary hover:text-secondary shadow-secondary/20"
                 )}
                 title="Descargar Reporte"
               >
                 {downloadSuccess ? <Check size={16} /> : <Download size={16} />}
                 <span>Exportar</span>
                 <ChevronDown size={14} className={cn("transition-transform", isExportOpen && "rotate-180")} />
               </button>

               <AnimatePresence>
                 {isExportOpen && (
                   <motion.div 
                     initial={{ opacity: 0, y: 10, scale: 0.95 }}
                     animate={{ opacity: 1, y: 0, scale: 1 }}
                     exit={{ opacity: 0, y: 10, scale: 0.95 }}
                     className="absolute top-full right-0 mt-4 w-64 bg-white dark:bg-zinc-900 rounded-3xl shadow-2xl border border-border/50 dark:border-white/10 p-3 z-50 backdrop-blur-xl"
                   >
                     <div className="space-y-1">
                        <button 
                          onClick={exportToExcel}
                          className="w-full flex items-center gap-3 p-4 hover:bg-muted/50 dark:hover:bg-white/5 rounded-2xl transition-all text-left group"
                        >
                           <div className="p-2 bg-emerald-500/10 text-emerald-600 rounded-xl group-hover:scale-110 transition-transform">
                              <BarChart3 size={18} />
                           </div>
                           <div>
                              <p className="text-[10px] font-black uppercase text-secondary dark:text-white tracking-widest">Excel (.xlsx)</p>
                              <p className="text-[9px] text-muted-foreground font-medium">Hoja de cálculo filtrable.</p>
                           </div>
                        </button>

                        <button 
                          onClick={exportToPDF}
                          className="w-full flex items-center gap-3 p-4 hover:bg-muted/50 dark:hover:bg-white/5 rounded-2xl transition-all text-left group"
                        >
                           <div className="p-2 bg-red-500/10 text-red-600 rounded-xl group-hover:scale-110 transition-transform">
                              <FileText size={18} />
                           </div>
                           <div>
                              <p className="text-[10px] font-black uppercase text-secondary dark:text-white tracking-widest">Documento PDF</p>
                              <p className="text-[9px] text-muted-foreground font-medium">Bajo demanda con marca KLICUS.</p>
                           </div>
                        </button>
                     </div>
                   </motion.div>
                 )}
               </AnimatePresence>
             </div>
         </div>
      </div>

      {/* Overview Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-6">
        {[
          { label: 'Descargas App', value: safeStats.installs || 0, icon: <Download size={18} />, color: 'text-primary' },
          { label: 'Sesiones Activas', value: safeStats.sessions || 0, icon: <Activity size={18} />, color: 'text-amber-500' },
          { label: 'Chats Inicia.', value: safeStats.chats || 0, icon: <MessageCircle size={18} />, color: 'text-emerald-500' },
          { label: 'Vistas Totales', value: safeStats.views || 0, icon: <Eye size={18} />, color: 'text-zinc-400' },
          { label: 'Clics Únicos', value: safeStats.clicks || 0, icon: <MousePointer2 size={18} />, color: 'text-primary' },
          { label: 'CTR Promedio', value: `${safeStats.ctr || 0}%`, icon: <TrendingUp size={18} />, color: 'text-amber-500' },
        ].map((card, i) => (
          <motion.div 
            key={i}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: i * 0.1 }}
            className="bg-white dark:bg-zinc-900 p-8 rounded-[2.5rem] border border-border/50 dark:border-white/5 shadow-sm"
          >
            <div className="flex justify-between items-start mb-4">
              <div className="p-3 rounded-2xl bg-muted/50 dark:bg-white/5 text-secondary dark:text-white">
                {card.icon}
              </div>
            </div>
            <div className="text-3xl font-black text-secondary dark:text-white tracking-tightest mb-1">{card.value}</div>
            <div className="text-[10px] font-black text-muted-foreground uppercase tracking-widest">{card.label}</div>
          </motion.div>
        ))}
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        {/* Main Time-Series Chart */}
        <div className="lg:col-span-2 bg-white dark:bg-zinc-900 p-10 rounded-[3.5rem] border border-border/50 dark:border-white/5 shadow-xl">
          <div className="flex items-center justify-between mb-10">
            <div>
              <h3 className="text-xl font-black text-secondary dark:text-white italic tracking-tight">Rendimiento Histórico</h3>
              <p className="text-xs text-muted-foreground font-medium">Interacciones diarias en los últimos 30 días.</p>
            </div>
          </div>
          
          <div className="h-[300px] w-full">
            <ResponsiveContainer width="100%" height="100%">
              <AreaChart data={timeSeries}>
                <defs>
                  <linearGradient id="colorViews" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="5%" stopColor="#E2E000" stopOpacity={0.3}/>
                    <stop offset="95%" stopColor="#E2E000" stopOpacity={0}/>
                  </linearGradient>
                </defs>
                <CartesianGrid strokeDasharray="3 3" vertical={false} strokeOpacity={0.1} />
                <XAxis 
                  dataKey="date" 
                  axisLine={false} 
                  tickLine={false} 
                  tick={{fontSize: 10, fontWeight: 700, fill: '#666'}}
                  dy={10}
                />
                <YAxis hide />
                <Tooltip 
                  contentStyle={{ 
                    borderRadius: '1.5rem', 
                    border: 'none', 
                    boxShadow: '0 20px 50px rgba(0,0,0,0.1)',
                    fontSize: '10px',
                    fontWeight: 900
                  }}
                />
                <Area 
                  type="monotone" 
                  dataKey="views" 
                  stroke="#E2E000" 
                  strokeWidth={4} 
                  fillOpacity={1} 
                  fill="url(#colorViews)" 
                  name="Vistas"
                />
                <Area 
                  type="monotone" 
                  dataKey="installs" 
                  stroke="#10b981" 
                  strokeWidth={4} 
                  fill="transparent" 
                  name="Descargas"
                />
                <Area 
                  type="monotone" 
                  dataKey="clicks" 
                  stroke="#1C1C1C" 
                  strokeWidth={4} 
                  fill="transparent" 
                  name="Clicks"
                />
                <Area 
                  type="monotone" 
                  dataKey="chats" 
                  stroke="#10b981" 
                  strokeWidth={4} 
                  fill="transparent" 
                  name="Chats"
                />
              </AreaChart>
            </ResponsiveContainer>
          </div>
        </div>

        {/* Device Breakdown */}
        <div className="bg-white dark:bg-zinc-900 p-10 rounded-[3.5rem] border border-border/50 dark:border-white/5 shadow-xl flex flex-col">
          <h3 className="text-xl font-black text-secondary dark:text-white italic tracking-tight mb-8">Dispositivos</h3>
          <div className="relative flex-1 flex flex-col items-center justify-center">
            <ResponsiveContainer width="100%" height={200}>
              <PieChart>
                <Pie
                  data={devices}
                  innerRadius={60}
                  outerRadius={80}
                  paddingAngle={5}
                  dataKey="value"
                >
                  {devices.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                  ))}
                </Pie>
                <Tooltip />
              </PieChart>
            </ResponsiveContainer>
            
            <div className="w-full space-y-4 mt-8">
              {devices.map((d, i) => (
                <div key={i} className="flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <div className="w-3 h-3 rounded-full" style={{ backgroundColor: COLORS[i % COLORS.length] }} />
                    <span className="text-[10px] font-black uppercase text-secondary dark:text-white tracking-widest">{d.name}</span>
                  </div>
                  <span className="text-xs font-black text-secondary dark:text-white">{d.value}</span>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
      </div>
  );
}
