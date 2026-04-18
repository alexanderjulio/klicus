'use client';

import { useState } from 'react';
import Image from 'next/image';
import { motion, AnimatePresence } from 'framer-motion';
import { Crown, ChevronLeft, ChevronRight } from 'lucide-react';
import { cn } from '@/lib/utils';

export default function ImageGallery({ images, title, isDiamond }) {
  const [index, setIndex] = useState(0);

  if (!images || images.length === 0) {
    return (
      <div className="aspect-[16/9] bg-muted rounded-[2.5rem] flex items-center justify-center">
        <p className="text-muted-foreground font-bold italic">Sin imágenes disponibles</p>
      </div>
    );
  }

  const next = () => setIndex((i) => (i + 1) % images.length);
  const prev = () => setIndex((i) => (i - 1 + images.length) % images.length);

  return (
    <section className="relative group rounded-[3rem] overflow-hidden bg-white shadow-2xl shadow-secondary/5 border border-white p-2">
      {isDiamond && (
        <div className="absolute top-8 left-8 z-10 bg-secondary text-primary px-5 py-2.5 rounded-2xl text-[10px] font-black uppercase tracking-[0.25em] shadow-2xl flex items-center gap-3 border border-primary/20">
          <Crown size={14} fill="currentColor" className="animate-pulse" /> Premium Destacado
        </div>
      )}
      
      <div className="aspect-[16/9] relative bg-[#F5F5F7] overflow-hidden rounded-[2.5rem] group/main">
        <AnimatePresence mode="wait">
          <motion.div
            key={index}
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            transition={{ duration: 0.5 }}
            className="absolute inset-0"
          >
            <Image 
              src={images[index]} 
              alt={`${title} - imagen ${index + 1}`} 
              fill
              className="object-cover" 
              unoptimized={true}
              priority
            />
          </motion.div>
        </AnimatePresence>

        <div className="absolute inset-0 bg-gradient-to-t from-black/20 to-transparent opacity-0 group-hover/main:opacity-100 transition-opacity duration-500" />
        
        {/* Navigation Arrows (Only on hover) */}
        {images.length > 1 && (
          <>
            <button 
              onClick={(e) => { e.preventDefault(); prev(); }}
              className="absolute left-6 top-1/2 -translate-y-1/2 w-12 h-12 bg-white/10 backdrop-blur-md border border-white/20 text-white rounded-full flex items-center justify-center opacity-0 group-hover/main:opacity-100 transition-all hover:bg-white hover:text-secondary shadow-2xl"
            >
              <ChevronLeft size={24} />
            </button>
            <button 
              onClick={(e) => { e.preventDefault(); next(); }}
              className="absolute right-6 top-1/2 -translate-y-1/2 w-12 h-12 bg-white/10 backdrop-blur-md border border-white/20 text-white rounded-full flex items-center justify-center opacity-0 group-hover/main:opacity-100 transition-all hover:bg-white hover:text-secondary shadow-2xl"
            >
              <ChevronRight size={24} />
            </button>
          </>
        )}
      </div>
      
      {/* Gallery Strip */}
      {images.length > 1 && (
        <div className="mt-4 flex gap-4 overflow-x-auto p-2 no-scrollbar scroll-smooth">
          {images.map((url, i) => (
            <button 
              key={i} 
              onClick={() => setIndex(i)}
              className={cn(
                "flex-shrink-0 w-24 h-24 rounded-3xl overflow-hidden border-2 transition-all ring-offset-2 hover:ring-4 ring-primary/10 bg-[#F5F5F7] relative group/thumb shadow-sm",
                index === i ? "border-primary ring-4" : "border-transparent"
              )}
            >
              <Image src={url} alt={`${title} mini ${i}`} fill className="object-cover" unoptimized={true} />
              <div className={cn("absolute inset-0 transition-colors", index === i ? "bg-transparent" : "bg-black/10 group-hover/thumb:bg-transparent")} />
            </button>
          ))}
        </div>
      )}
    </section>
  );
}
