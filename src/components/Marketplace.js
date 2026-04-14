/**
 * KLICUS Marketplace Orchestrator
 * Client-side component that manages live searching, category filtering, 
 * and priority-based sorting of advertisements.
 */

'use client';

import { useState, useMemo } from 'react';
import AdCard from './AdCard';
import CategoryFilter from './CategoryFilter';
import SearchBar from './SearchBar';

export default function Marketplace({ initialAds, categories }) {
  // State for real-time search terms and selected category
  const [search, setSearch] = useState('');
  const [activeCategory, setActiveCategory] = useState('all');

  /**
   * Memoized logic to filter and sort ads based on user interaction.
   * Priority: Diamond (0) > Pro (1) > Basic (2)
   */
  const filteredAds = useMemo(() => {
    return initialAds.filter(ad => {
      // Search matching logic (title and description)
      const matchesSearch = 
        ad.title.toLowerCase().includes(search.toLowerCase()) || 
        ad.description.toLowerCase().includes(search.toLowerCase());
      
      // Category filtering logic
      const matchesCategory = activeCategory === 'all' || ad.category_slug === activeCategory;
      
      return matchesSearch && matchesCategory;
    }).sort((a, b) => {
      // Numerical priority sorting
      const priorityOrder = { diamond: 0, pro: 1, basic: 2 };
      return priorityOrder[a.priority_level] - priorityOrder[b.priority_level];
    });
  }, [search, activeCategory, initialAds]);

  return (
    <div className="container" style={{ paddingTop: '100px', paddingBottom: '4rem' }}>
      <header style={{ textAlign: 'center', marginBottom: '4rem' }}>
        <h1 style={{ fontSize: 'clamp(2rem, 5vw, 3.5rem)', marginBottom: '1.5rem' }}>
          Encuentra <span style={{ color: 'var(--primary)' }}>lo mejor</span> cerca de ti
        </h1>
        {/* Real-time search component */}
        <SearchBar value={search} onChange={setSearch} />
      </header>

      {/* Interactive category selection bar */}
      <CategoryFilter 
        categories={categories} 
        activeCategory={activeCategory} 
        onCategoryChange={setActiveCategory} 
      />

      {/* Responsive Grid of AdCards */}
      <div style={{ 
        display: 'grid', 
        gridTemplateColumns: 'repeat(auto-fill, minmax(320px, 1fr))', 
        gap: '2rem',
        marginTop: '2rem'
      }}>
        {filteredAds.length > 0 ? (
          filteredAds.map((ad) => (
            <AdCard key={ad.id} ad={ad} />
          ))
        ) : (
          /* Empty State */
          <div style={{ 
            gridColumn: '1 / -1', 
            textAlign: 'center', 
            padding: '4rem',
            color: 'var(--muted-foreground)'
          }}>
            <p style={{ fontSize: '1.25rem' }}>No se encontraron anuncios que coincidan con tu búsqueda.</p>
            <button 
              onClick={() => { setSearch(''); setActiveCategory('all'); }}
              style={{ color: 'var(--primary)', fontWeight: '600', marginTop: '1rem' }}
            >
              Limpiar todos los filtros
            </button>
          </div>
        )}
      </div>
    </div>
  );
}
