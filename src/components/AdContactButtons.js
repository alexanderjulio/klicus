'use client';

import { Smartphone, MessageSquare, Phone, Zap } from 'lucide-react';
import { trackClick, trackContact } from './AdTracker';
import { cn } from '@/lib/utils';

export default function AdContactButtons({ adId, cellphone, phone }) {
  const handleContact = () => {
    trackContact(adId);
  };

  return (
    <div className="space-y-4">
      <a 
        href={phone ? `tel:${phone}` : `tel:${cellphone}`} 
        onClick={handleContact}
        className="group w-full h-16 bg-secondary text-white rounded-[2rem] flex items-center justify-between px-8 font-black text-[11px] uppercase tracking-[0.25em] shadow-2xl shadow-secondary/20 hover:scale-[1.02] active:scale-95 transition-all relative overflow-hidden italic"
      >
        <div className="absolute inset-0 bg-white/5 opacity-0 group-hover:opacity-100 transition-opacity" />
        <span className="relative z-10">Llamar Ahora</span>
        <Phone size={20} className="relative z-10 group-hover:rotate-12 transition-transform" />
      </a>

      <a 
        href={`https://wa.me/${cellphone?.replace(/\+/g, '')}`}
        target="_blank"
        rel="noopener noreferrer"
        onClick={handleContact}
        className="group w-full h-20 bg-[#25D366] text-white rounded-[2rem] flex items-center justify-between px-8 font-black text-sm shadow-xl shadow-green-200 hover:shadow-2xl hover:shadow-green-300 hover:scale-[1.03] active:scale-95 transition-all relative overflow-hidden italic"
      >
        <div className="absolute inset-0 bg-white/10 opacity-0 group-hover:opacity-100 transition-opacity" />
        <div className="flex flex-col items-start relative z-10">
          <span className="text-[9px] uppercase tracking-widest text-white/70 mb-0.5">WhatsApp Oficial</span>
          <span className="text-xl">Enviar Mensaje</span>
        </div>
        <MessageSquare size={26} className="relative z-10 group-hover:scale-110 transition-transform" />
      </a>

      <div className="flex items-center gap-2 justify-center pt-2">
         <div className="h-px w-8 bg-border" />
         <span className="text-[8px] font-black uppercase tracking-[0.3em] text-secondary/20">Respuesta Inmediata</span>
         <div className="h-px w-8 bg-border" />
      </div>
    </div>
  );
}

export function MobileContactButtons({ adId, cellphone, phone }) {
  const handleContact = () => trackContact(adId);
  
  return (
    <div className="lg:hidden fixed bottom-6 left-6 right-6 z-50 flex gap-4 animate-in slide-in-from-bottom-10 duration-500">
      <a 
        href={`https://wa.me/${cellphone?.replace(/\+/g, '')}`}
        target="_blank"
        rel="noopener noreferrer"
        onClick={handleContact}
        className="flex-[2.5] h-16 bg-[#25D366] text-white rounded-[1.5rem] font-black flex items-center justify-between px-6 shadow-2xl shadow-green-900/40 active:scale-95 transition-all italic border-t border-white/20"
      >
        <div className="flex flex-col items-start">
          <span className="text-[7px] uppercase tracking-widest text-white/70 leading-none">Vía WhatsApp</span>
          <span className="text-lg leading-none">Contactar</span>
        </div>
        <MessageSquare size={22} />
      </a>
      
      <a 
        href={phone ? `tel:${phone}` : `tel:${cellphone}`}
        onClick={handleContact}
        className="flex-1 h-16 bg-secondary text-white rounded-[1.5rem] flex items-center justify-center shadow-2xl shadow-secondary/40 active:scale-95 transition-all border-t border-white/10"
      >
        <Phone size={24} />
      </a>
    </div>
  );
}
