'use client';

/**
 * KLICUS Navigation Header
 * Premium glassmorphism header with responsive mobile/desktop navigation.
 */

import { Menu, User, Search, Home } from 'lucide-react';

export default function Navigation() {
  return (
    <header className="glass" style={{
      position: 'fixed',
      top: 0,
      left: 0,
      right: 0,
      zIndex: 1000,
      height: '64px',
      display: 'flex',
      alignItems: 'center',
      padding: '0 1.5rem'
    }}>
      <div className="container" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '2rem' }}>
          <h1 style={{ fontSize: '1.5rem', color: 'var(--primary)', letterSpacing: '-0.02em', margin: 0 }}>
            KLICUS
          </h1>
          {/* Desktop Navigation Links */}
          <nav className="desktop-only" style={{ display: 'flex', gap: '1.5rem', fontWeight: '500' }}>
            <a href="/">Inicio</a>
            <a href="/categorias">Categorías</a>
            <a href="/planes">Planes</a>
          </nav>
        </div>

        <div style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
          {/* Quick Search Trigger */}
          <button style={{ padding: '8px', color: 'var(--muted-foreground)' }}>
            <Search size={20} />
          </button>
          {/* User Account Access */}
          <a href="/login" style={{ 
            display: 'flex', 
            alignItems: 'center', 
            gap: '0.5rem', 
            padding: '6px 12px', 
            borderRadius: 'var(--radius-full)',
            border: '1px solid var(--border)',
            fontWeight: '600'
          }}>
            <User size={18} /> Mi Cuenta
          </a>
          {/* Mobile Menu Toggle */}
          <button className="mobile-only" style={{ padding: '8px' }}>
            <Menu size={24} />
          </button>
        </div>
      </div>

      <style jsx>{`
        @media (max-width: 768px) {
          .desktop-only { display: none; }
        }
        @media (min-width: 769px) {
          .mobile-only { display: none; }
        }
      `}</style>
    </header>
  );
}
