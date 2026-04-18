'use client';

import React from 'react';
import { motion } from 'framer-motion';
import { CheckCircle2, AlertCircle, Info, X } from 'lucide-react';
import { cn } from '@/lib/utils';

const icons = {
  success: <CheckCircle2 className="text-emerald-500" size={14} strokeWidth={2.5} />,
  error: <AlertCircle className="text-rose-500" size={14} strokeWidth={2.5} />,
  info: <Info className="text-sky-500" size={14} strokeWidth={2.5} />,
};

/**
 * KLICUS Ultra-Min Notification (Pure Prolijo Style)
 * Minimalist, thin, and professional bar for high-end applications.
 * Placed at the bottom for non-intrusive feedback.
 */
export default function Notification({ message, type, onClose }) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 40, scale: 0.98 }}
      animate={{ opacity: 1, y: 0, scale: 1 }}
      exit={{ opacity: 0, y: 20, scale: 0.98, transition: { duration: 0.15 } }}
      className="pointer-events-auto px-4 mb-4"
    >
      <div className={cn(
        "flex items-center gap-4 px-5 py-3 bg-white/90 backdrop-blur-xl border rounded-[1.2rem] shadow-[0_25px_60px_-15px_rgba(0,0,0,0.15)] min-w-[320px] max-w-lg group border-zinc-100"
      )}>
        <div className="shrink-0">
          {icons[type] || icons.info}
        </div>
        
        <div className="flex-1">
          <p className="text-[11px] font-bold text-zinc-700 tracking-tight leading-none uppercase italic">
            {message}
          </p>
        </div>

        <button 
          onClick={onClose}
          className="ml-2 p-1.5 rounded-lg hover:bg-zinc-50 transition-colors text-zinc-300 hover:text-zinc-900"
        >
          <X size={12} strokeWidth={3} />
        </button>
      </div>
    </motion.div>
  );
}
