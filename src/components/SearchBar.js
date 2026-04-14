/**
 * KLICUS Search Bar
 * Minimalist real-time search input for the marketplace.
 */

'use client';

import { Search, X } from 'lucide-react';

export default function SearchBar({ value, onChange }) {
  return (
    <div className="search-wrapper" style={{
      maxWidth: '600px',
      margin: '0 auto 3rem',
      position: 'relative'
    }}>
      <div style={{ position: 'relative' }}>
        <input 
          type="text"
          value={value}
          onChange={(e) => onChange(e.target.value)}
          placeholder="Busca servicios, empresas o profesionales..."
          style={{
            width: '100%',
            padding: '1.25rem 1.5rem 1.25rem 3.5rem',
            borderRadius: 'var(--radius-lg)',
            border: '1px solid var(--border)',
            background: 'var(--card)',
            fontSize: '1.1rem',
            boxShadow: 'var(--shadow-lg)',
            outline: 'none',
            transition: 'border-color var(--duration-fast), box-shadow var(--duration-fast)'
          }}
          className="search-input"
        />
        {/* Search Icon Placeholder */}
        <Search size={22} style={{
          position: 'absolute',
          left: '1.25rem',
          top: '50%',
          transform: 'translateY(-50%)',
          color: 'var(--muted-foreground)'
        }} />
        
        {/* Clear Search Trigger */}
        {value && (
          <button 
            onClick={() => onChange('')}
            style={{
              position: 'absolute',
              right: '1.25rem',
              top: '50%',
              transform: 'translateY(-50%)',
              color: 'var(--muted-foreground)'
            }}
          >
            <X size={20} />
          </button>
        )}
      </div>

      <style jsx>{`
        .search-input:focus {
          border-color: var(--primary);
          box-shadow: 0 0 0 4px var(--ring);
        }
      `}</style>
    </div>
  );
}
