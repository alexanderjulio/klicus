'use client';

/**
 * KLICUS Category Filter
 * Renders a horizontal scrollable list of categories for ad filtering.
 */

import { cn } from '@/lib/utils';

export default function CategoryFilter({ categories, activeCategory, onCategoryChange }) {
  return (
    <div className="flex gap-3 overflow-x-auto pb-4 mb-8 scrollbar-hide no-scrollbar select-none">
      {/* "All" category trigger */}
      <button 
        onClick={() => onCategoryChange('all')}
        className={cn(
          "whitespace-nowrap px-6 py-2 rounded-full border border-border font-bold transition-all duration-300",
          activeCategory === 'all' 
            ? "bg-primary text-primary-foreground border-primary shadow-md scale-105" 
            : "bg-card text-foreground hover:bg-muted"
        )}
      >
        Todas
      </button>

      {/* Dynamic categories from database */}
      {categories.map((cat) => (
        <button 
          key={cat.id}
          onClick={() => onCategoryChange(cat.slug)}
          className={cn(
            "whitespace-nowrap px-6 py-2 rounded-full border border-border font-bold transition-all duration-300",
            activeCategory === cat.slug 
              ? "bg-primary text-primary-foreground border-primary shadow-md scale-105" 
              : "bg-card text-foreground hover:bg-muted"
          )}
        >
          {cat.name}
        </button>
      ))}

      <style jsx global>{`
        .no-scrollbar::-webkit-scrollbar {
          display: none;
        }
        .no-scrollbar {
          -ms-overflow-style: none;
          scrollbar-width: none;
        }
      `}</style>
    </div>
  );
}
