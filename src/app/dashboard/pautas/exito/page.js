'use client';

import { 
  CheckCircle2, ShoppingBag, ArrowRight, CreditCard, 
  Copy, Smartphone, Landmark, AlertCircle, MessageCircle, QrCode 
} from 'lucide-react';
import { motion } from 'framer-motion';
import Button from '@/components/ui/Button';
import Link from 'next/link';
import { useSearchParams } from 'next/navigation';
import { manualPaymentConfig } from '@/config/manualPayment';
import { useState, useEffect, Suspense } from 'react';
import { cn } from '@/lib/utils';

function PaymentResultsContent() {
  const searchParams = useSearchParams();
  const isFallback = searchParams.get('fallback') === 'true';
  const adId = searchParams.get('adId');
  const [copied, setCopied] = useState(false);
  const [methods, setMethods] = useState([]);
  const [selectedMethod, setSelectedMethod] = useState(null);
  const [isLoading, setIsLoading] = useState(true);
  const [adTitle, setAdTitle] = useState('');

  useEffect(() => {
    const fetchData = async () => {
      try {
        // Fetch ad info if available
        if (adId) {
          const adRes = await fetch(`/api/pautas/${adId}`);
          const adData = await adRes.json();
          if (adData && adData.title) setAdTitle(adData.title);
        }

        if (isFallback) {
          const res = await fetch('/api/admin/settings');
          const data = await res.json();
          if (data.manualPayments && data.manualPayments.length > 0) {
            setMethods(data.manualPayments);
            setSelectedMethod(data.manualPayments[0]);
          } else {
            // Use hardcoded fallback
            const fallback = {
              id: 'fallback',
              name: manualPaymentConfig.bankName,
              type: manualPaymentConfig.accountType,
              number: manualPaymentConfig.accountNumber,
              owner: manualPaymentConfig.accountOwner,
              qr_enabled: manualPaymentConfig.qr.enabled,
              qr_image: manualPaymentConfig.qr.imagePath,
              whatsapp_number: manualPaymentConfig.whatsappNumber,
              whatsapp_message: manualPaymentConfig.whatsappMessage
            };
            setMethods([fallback]);
            setSelectedMethod(fallback);
          }
        }
      } catch (err) {
        console.error('Error fetching settings/ad:', err);
      } finally {
        setIsLoading(false);
      }
    };

    fetchData();
  }, [isFallback, adId]);

  const getWhatsAppLink = () => {
    if (!selectedMethod) return '#';
    let message = selectedMethod.whatsapp_message;
    if (adTitle) {
      message += ` (Anuncio: ${adTitle})`;
    }
    return `https://wa.me/${selectedMethod.whatsapp_number}?text=${encodeURIComponent(message)}`;
  };

  const copyNumber = () => {
    if (!selectedMethod) return;
    navigator.clipboard.writeText(selectedMethod.number);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  if (isLoading) {
    return (
      <div className="min-h-screen bg-[#F8F9FA] flex items-center justify-center p-6">
        <div className="text-center">
          <div className="w-12 h-12 border-4 border-primary border-t-transparent rounded-full animate-spin mx-auto mb-4"></div>
          <p className="text-[10px] font-black uppercase tracking-widest text-zinc-400">Preparando instrucciones...</p>
        </div>
      </div>
    );
  }

  if (isFallback && selectedMethod) {
    return (
      <div className="min-h-screen bg-[#F8F9FA] flex items-center justify-center p-6 pb-32">
        <motion.div 
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          className="max-w-xl w-full bg-white rounded-[3.5rem] p-10 md:p-14 text-center shadow-2xl shadow-secondary/5 border border-zinc-100"
        >
          <div className="w-20 h-20 bg-primary/10 text-primary rounded-[2rem] flex items-center justify-center mx-auto mb-10 shadow-lg shadow-primary/10">
            <Landmark size={40} strokeWidth={2} />
          </div>

          <h1 className="text-4xl font-black text-secondary tracking-tighter mb-4 italic leading-none">
            Pago por <span className="text-primary tracking-tightest not-italic">Consignación</span>
          </h1>
          
          <p className="text-zinc-500 font-bold text-lg mb-10 leading-snug">
            Selecciona el método que prefieras y realiza tu transferencia para activar tu pauta.
          </p>

          {methods.length > 1 && (
            <div className="flex flex-wrap gap-2 mb-8 justify-center">
               {methods.map(m => (
                 <button 
                  key={m.id} 
                  onClick={() => setSelectedMethod(m)}
                  className={cn(
                    "px-6 py-3 rounded-2xl text-[9px] font-black uppercase tracking-widest transition-all border",
                    selectedMethod.id === m.id ? "bg-secondary text-white border-secondary" : "bg-white text-muted-foreground border-zinc-200 hover:border-primary hover:text-primary"
                  )}
                 >
                   {m.name}
                 </button>
               ))}
            </div>
          )}

          <div className="space-y-6">
            <div className="bg-zinc-50 rounded-[2.5rem] p-10 text-left space-y-8 border border-zinc-100 relative overflow-hidden group">
              <div className="absolute top-0 right-0 p-4 opacity-10 group-hover:opacity-20 transition-opacity">
                 <Smartphone size={80} className="text-secondary" />
              </div>

              <div className="space-y-1">
                <span className="text-[10px] font-black uppercase tracking-widest text-zinc-400">Banco / Plataforma</span>
                <p className="text-xl font-black text-secondary italic">{selectedMethod.name} ({selectedMethod.type})</p>
              </div>

              <div className="flex flex-col md:flex-row md:justify-between md:items-end gap-4 border-t border-zinc-200/50 pt-8">
                 <div className="space-y-1">
                   <span className="text-[10px] font-black uppercase tracking-widest text-zinc-400">Número de Cuenta</span>
                   <p className="text-3xl font-black text-secondary tracking-tighter">{selectedMethod.number}</p>
                 </div>
                 <button 
                   onClick={copyNumber}
                   className="h-14 px-6 bg-white border border-zinc-200 rounded-2xl flex items-center gap-3 text-[10px] font-black uppercase tracking-widest hover:bg-secondary hover:text-white transition-all shadow-sm active:scale-95"
                 >
                   {copied ? <CheckCircle2 size={16} className="text-emerald-500" /> : <Copy size={16} />}
                   {copied ? "Copiado" : "Copiar"}
                 </button>
              </div>

              <div className="pt-4 border-t border-zinc-200/50">
                 <span className="text-[10px] font-black uppercase tracking-widest text-zinc-400">Titular</span>
                 <p className="text-sm font-bold text-secondary/60 italic">{selectedMethod.owner}</p>
              </div>
            </div>

            {/* Dynamic QR Code Section */}
            {selectedMethod.qr_enabled && (
              <div className="bg-white p-8 rounded-[2.5rem] border border-zinc-100 shadow-sm flex flex-col items-center group">
                 <div className="w-10 h-10 bg-primary/10 text-primary rounded-xl flex items-center justify-center mb-6">
                    <QrCode size={20} />
                 </div>
                 <span className="text-[10px] font-black uppercase tracking-widest text-zinc-400 mb-6 font-bold">Escanea para pagar con {selectedMethod.name}</span>
                 <div className="w-64 h-64 bg-zinc-50 rounded-3xl border-2 border-dashed border-zinc-200 flex items-center justify-center overflow-hidden relative">
                    <img 
                      src={selectedMethod.qr_image} 
                      alt="QR Pago"
                      className="w-full h-full object-contain p-4 transition-transform group-hover:scale-110 duration-500"
                      onError={(e) => {
                        e.target.style.display = 'none';
                        e.target.parentElement.innerHTML = '<div class="text-zinc-300 font-bold text-[10px] uppercase tracking-widest text-center px-4">QR no disponible o ruta inválida</div>';
                      }}
                    />
                 </div>
              </div>
            )}
          </div>

          <div className="mt-12 space-y-6">
             <a 
               href={getWhatsAppLink()}
               target="_blank"
               className="w-full h-16 bg-emerald-500 text-white rounded-2xl font-black flex items-center justify-center gap-4 hover:scale-[1.02] active:scale-95 transition-all shadow-xl shadow-emerald-500/20"
             >
               <MessageCircle size={22} fill="white" />
               <span className="text-[11px] uppercase tracking-widest">Enviar Comprobante por WhatsApp</span>
             </a>

             <Link href="/dashboard" className="block text-[10px] font-black uppercase tracking-[0.3em] text-zinc-300 hover:text-primary transition-all">
                Volver al Panel de Control
             </Link>
          </div>
        </motion.div>
      </div>
    );
  }

  // STANDARD SUCCESS VIEW (Original Flow)
  return (
    <div className="min-h-screen bg-[#F8F9FA] flex items-center justify-center p-6">
      <motion.div 
        initial={{ opacity: 0, scale: 0.9 }}
        animate={{ opacity: 1, scale: 1 }}
        className="max-w-xl w-full bg-white rounded-[3.5rem] p-12 text-center shadow-2xl shadow-emerald-500/5 border border-emerald-100"
      >
        <div className="w-24 h-24 bg-emerald-500 text-white rounded-[2rem] flex items-center justify-center mx-auto mb-10 shadow-xl shadow-emerald-500/30">
          <CheckCircle2 size={48} strokeWidth={2.5} />
        </div>

        <h1 className="text-5xl font-black text-secondary tracking-tightest mb-4 italic leading-none">
          ¡Pago <span className="text-emerald-500 not-italic tracking-tighter">Exitoso</span>!
        </h1>
        
        <p className="text-zinc-500 font-bold text-lg mb-10 leading-snug">
          Hemos recibido tu pago correctamente. Tu pauta ha sido enviada a la cola de revisión prioritaria.
        </p>

        <div className="bg-emerald-50/50 p-8 rounded-[2.5rem] mb-12 text-left space-y-4 border border-emerald-100">
          <div className="flex justify-between items-center text-[10px] font-black uppercase tracking-widest text-emerald-800/40">
            <span>Estado del Pago</span>
            <span className="px-4 py-1.5 bg-emerald-500 text-white rounded-full">Aprobado</span>
          </div>
          <div className="flex justify-between items-center text-[10px] font-black uppercase tracking-widest text-zinc-400 border-t border-emerald-100 pt-4">
            <span>Visibilidad</span>
            <span className="text-secondary italic">En proceso de activación</span>
          </div>
        </div>

        <div className="flex flex-col sm:flex-row gap-4">
          <Link href="/dashboard" className="flex-1">
            <Button className="w-full h-16 rounded-2xl font-black gap-3 text-[11px] uppercase tracking-widest hover:scale-[1.05] transition-all">
              Ver mis Anuncios <ArrowRight size={18} />
            </Button>
          </Link>
          <Link href="/" className="flex-1">
            <Button variant="outline" className="w-full h-16 rounded-2xl font-black border-2 border-zinc-200 text-[11px] uppercase tracking-widest hover:bg-zinc-50 transition-all">
              Ir al Inicio
            </Button>
          </Link>
        </div>

        <p className="mt-12 text-[9px] text-zinc-300 font-black uppercase tracking-[0.2em] flex items-center justify-center gap-3">
          <ShoppingBag size={12} /> KLICUS SECURE PAY · MP GATEWAY
        </p>
      </motion.div>
    </div>
  );
}

export default function PaymentResultsPage() {
  return (
    <Suspense fallback={
      <div className="min-h-screen bg-[#F8F9FA] flex items-center justify-center p-6">
        <div className="text-center">
          <div className="w-12 h-12 border-4 border-primary border-t-transparent rounded-full animate-spin mx-auto mb-4"></div>
          <p className="text-[10px] font-black uppercase tracking-widest text-zinc-400">Cargando transacción...</p>
        </div>
      </div>
    }>
      <PaymentResultsContent />
    </Suspense>
  );
}
