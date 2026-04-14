/**
 * KLICUS Category Filter
 * Renders a horizontal scrollable list of categories for ad filtering.
 */

'use client';

export default function CategoryFilter({ categories, activeCategory, onCategoryChange }) {
  return (
    <div className="category-container" style={{
      marginBottom: '2rem',
      display: 'flex',
      gap: '0.75rem',
      overflowX: 'auto',
      paddingBottom: '1rem',
      scrollbarWidth: 'none',
      msOverflowStyle: 'none'
    }}>
      {/* "All" category trigger */}
      <button 
        onClick={() => onCategoryChange('all')}
        style={{
          whiteSpace: 'nowrap',
          padding: '0.6rem 1.25rem',
          borderRadius: 'var(--radius-full)',
          background: activeCategory === 'all' ? 'var(--primary)' : 'var(--card)',
          color: activeCategory === 'all' ? 'var(--primary-foreground)' : 'var(--foreground)',
          border: '1px solid var(--border)',
          fontWeight: '600',
          transition: 'all var(--duration-fast)'
        }}
      >
        Todas
      </button>

      {/* Dynamic categories from database */}
      {categories.map((cat) => (
        <button 
          key={cat.id}
          onClick={() => onCategoryChange(cat.slug)}
          style={{
            whiteSpace: 'nowrap',
            padding: '0.6rem 1.25rem',
            borderRadius: 'var(--radius-full)',
            background: activeCategory === cat.slug ? 'var(--primary)' : 'var(--card)',
            color: activeCategory === cat.slug ? 'var(--primary-foreground)' : 'var(--foreground)',
            border: '1px solid var(--border)',
            fontWeight: '600',
            transition: 'all var(--duration-fast)'
          }}
        >
          {cat.name}
        </button>
      ))}

      <style jsx>{`
        .category-container::-webkit-scrollbar {
          display: none;
        }
      `}</style>
    </div>
  );
}
