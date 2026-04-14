'use client';

import { useState } from 'react';
import { signIn } from 'next-auth/react';
import { useRouter } from 'next/navigation';
import { Mail, Lock, LogIn, ChevronLeft } from 'lucide-react';
import Link from 'next/link';

export default function LoginPage() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const router = useRouter();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    const result = await signIn('credentials', {
      redirect: false,
      email,
      password,
    });

    if (result.ok) {
      router.push('/admin'); // Or user dashboard
    } else {
      alert('Error: Check your credentials');
      setLoading(false);
    }
  };

  return (
    <div style={{ 
      minHeight: '100vh', 
      display: 'flex', 
      alignItems: 'center', 
      justifyContent: 'center',
      background: 'var(--muted)',
      padding: '1.5rem'
    }}>
      <div className="glass fade-in" style={{
        width: '100%',
        maxWidth: '400px',
        padding: '2.5rem',
        borderRadius: 'var(--radius-lg)',
        boxShadow: 'var(--shadow-xl)'
      }}>
        <Link href="/" style={{ color: 'var(--muted-foreground)', display: 'flex', alignItems: 'center', gap: '0.5rem', marginBottom: '2rem' }}>
          <ChevronLeft size={16} /> Volver al Inicio
        </Link>
        
        <div style={{ textAlign: 'center', marginBottom: '2rem' }}>
          <h1 style={{ fontSize: '2rem', marginBottom: '0.5rem' }}>Bienvenido</h1>
          <p style={{ color: 'var(--muted-foreground)' }}>Ingresa tus credenciales para continuar.</p>
        </div>

        <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '1.25rem' }}>
          <div>
            <label style={{ display: 'block', marginBottom: '0.5rem', fontWeight: '600' }}>Email</label>
            <div style={{ position: 'relative' }}>
              <input 
                type="email" 
                required 
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="nombre@ejemplo.com"
                style={{
                  width: '100%',
                  padding: '0.75rem 1rem 0.75rem 2.5rem',
                  borderRadius: 'var(--radius)',
                  border: '1px solid var(--border)',
                  background: 'var(--background)'
                }}
              />
              <Mail size={18} style={{ position: 'absolute', left: '0.75rem', top: '50%', transform: 'translateY(-50%)', color: 'var(--muted-foreground)' }} />
            </div>
          </div>

          <div>
            <label style={{ display: 'block', marginBottom: '0.5rem', fontWeight: '600' }}>Contraseña</label>
            <div style={{ position: 'relative' }}>
              <input 
                type="password" 
                required 
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="••••••••"
                style={{
                  width: '100%',
                  padding: '0.75rem 1rem 0.75rem 2.5rem',
                  borderRadius: 'var(--radius)',
                  border: '1px solid var(--border)',
                  background: 'var(--background)'
                }}
              />
              <Lock size={18} style={{ position: 'absolute', left: '0.75rem', top: '50%', transform: 'translateY(-50%)', color: 'var(--muted-foreground)' }} />
            </div>
          </div>

          <button type="submit" className="btn-primary" disabled={loading} style={{ 
            width: '100%', 
            justifyContent: 'center',
            marginTop: '1rem' 
          }}>
            {loading ? 'Cargando...' : 'Iniciar Sesión'} <LogIn size={18} />
          </button>
        </form>

        <p style={{ textAlign: 'center', marginTop: '2rem', color: 'var(--muted-foreground)', fontSize: '0.875rem' }}>
          ¿No tienes una cuenta? <Link href="/register" style={{ color: 'var(--primary)', fontWeight: '600' }}>Regístrate</Link>
        </p>
      </div>
    </div>
  );
}
