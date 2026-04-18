'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { Mail, Lock, User, CheckCircle2, ChevronLeft, ArrowRight } from 'lucide-react';
import Link from 'next/link';
import Logo from '@/components/ui/Logo';

export default function RegisterPage() {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    password: '',
    confirmPassword: ''
  });
  const [loading, setLoading] = useState(false);
  const router = useRouter();

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (formData.password !== formData.confirmPassword) {
      alert('Las contraseñas no coinciden');
      return;
    }

    setLoading(true);
    try {
      const res = await fetch('/api/auth/register', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          name: formData.name,
          email: formData.email,
          password: formData.password
        }),
      });

      const data = await res.json();
      
      if (res.ok) {
        alert(data.message);
        router.push('/login');
      } else {
        alert(data.error || 'Ocurrió un error en el registro');
      }
    } catch (error) {
      console.error('Registration error:', error);
      alert('Error de conexión');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen grid grid-cols-1 lg:grid-cols-2 bg-white">
      {/* Right Side: Visual/Branding (Desktop Only) - Flipped for variety */}
      <div className="hidden lg:flex flex-col justify-between bg-secondary p-12 relative overflow-hidden order-last">
        <div className="relative z-10">
          <Logo className="h-12" secondary />
          <h1 className="text-6xl font-black text-white mt-20 leading-[0.9] tracking-tighter">
            Únete a la <br /> comunidad <br /> de KLICUS.
          </h1>
          <p className="text-white/70 text-lg mt-6 max-w-md font-medium">
            Crea tu perfil profesional, publica tus servicios y empieza a recibir contactos hoy mismo.
          </p>
        </div>
        
        <div className="relative z-10 text-white/40 text-sm font-bold">
          © 2026 KLICUS MARKETPLACE
        </div>

        {/* Abstract Background Shapes */}
        <div className="absolute top-[-10%] right-[-10%] w-[500px] h-[500px] bg-primary/10 rounded-full blur-3xl" />
        <div className="absolute bottom-[-5%] left-[-5%] w-[300px] h-[300px] bg-white/5 rounded-full blur-2xl" />
      </div>

      {/* Left Side: Register Form */}
      <div className="flex flex-col justify-center items-center p-8 md:p-16">
        <div className="w-full max-w-md">
          <div className="lg:hidden mb-12 flex justify-center">
             <Logo className="h-10" />
          </div>

          <Link 
            href="/login" 
            className="inline-flex items-center gap-2 text-sm text-muted-foreground hover:text-secondary mb-8 transition-colors group"
          >
            <ChevronLeft size={16} className="group-hover:-translate-x-1 transition-transform" /> 
            Volver al Inicio de Sesión
          </Link>

          <div className="mb-10">
            <h2 className="text-3xl font-black text-secondary tracking-tight">Crea tu cuenta</h2>
            <p className="text-muted-foreground mt-2">Empieza a publicar tus servicios en pocos minutos.</p>
          </div>

          <form onSubmit={handleSubmit} className="space-y-5">
            <div className="space-y-2">
              <label className="text-sm font-bold text-secondary uppercase tracking-wider">Nombre Completo / Empresa</label>
              <div className="relative">
                <input 
                  type="text" 
                  required 
                  value={formData.name}
                  onChange={(e) => setFormData({...formData, name: e.target.value})}
                  placeholder="Juan Pérez o Clínica Dental"
                  className="w-full bg-muted/30 border border-border rounded-xl px-4 py-3 pl-11 outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all text-secondary"
                />
                <User size={18} className="absolute left-4 top-1/2 -translate-y-1/2 text-muted-foreground" />
              </div>
            </div>

            <div className="space-y-2">
              <label className="text-sm font-bold text-secondary uppercase tracking-wider">Email</label>
              <div className="relative">
                <input 
                  type="email" 
                  required 
                  value={formData.email}
                  onChange={(e) => setFormData({...formData, email: e.target.value})}
                  placeholder="ejemplo@correo.com"
                  className="w-full bg-muted/30 border border-border rounded-xl px-4 py-3 pl-11 outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all text-secondary"
                />
                <Mail size={18} className="absolute left-4 top-1/2 -translate-y-1/2 text-muted-foreground" />
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="space-y-2">
                <label className="text-sm font-bold text-secondary uppercase tracking-wider">Contraseña</label>
                <div className="relative">
                  <input 
                    type="password" 
                    required 
                    value={formData.password}
                    onChange={(e) => setFormData({...formData, password: e.target.value})}
                    placeholder="••••••••"
                    className="w-full bg-muted/30 border border-border rounded-xl px-4 py-3 pl-11 outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all text-secondary"
                  />
                  <Lock size={18} className="absolute left-4 top-1/2 -translate-y-1/2 text-muted-foreground" />
                </div>
              </div>
              <div className="space-y-2">
                <label className="text-sm font-bold text-secondary uppercase tracking-wider">Confirmar</label>
                <div className="relative">
                  <input 
                    type="password" 
                    required 
                    value={formData.confirmPassword}
                    onChange={(e) => setFormData({...formData, confirmPassword: e.target.value})}
                    placeholder="••••••••"
                    className="w-full bg-muted/30 border border-border rounded-xl px-4 py-3 pl-11 outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all text-secondary"
                  />
                  <Lock size={18} className="absolute left-4 top-1/2 -translate-y-1/2 text-muted-foreground" />
                </div>
              </div>
            </div>

            <div className="flex items-start gap-3 py-2">
              <input type="checkbox" required className="mt-1 accent-primary h-4 w-4" />
              <p className="text-xs text-muted-foreground leading-relaxed">
                Acepto los <a href="#" className="font-bold text-secondary hover:underline">Términos de Servicio</a> y la <a href="#" className="font-bold text-secondary hover:underline">Política de Privacidad</a> de KLICUS.
              </p>
            </div>

            <button 
              type="submit" 
              disabled={loading}
              className="w-full bg-primary text-secondary font-black py-4 rounded-xl flex items-center justify-center gap-2 hover:bg-primary/90 transition-all shadow-lg active:scale-[0.98] disabled:opacity-50 mt-4"
            >
              {loading ? 'Creando cuenta...' : 'Registrarme ahora'} 
              {!loading && <CheckCircle2 size={18} />}
            </button>
          </form>

          <p className="mt-10 text-center text-sm text-muted-foreground">
            ¿Ya tienes una cuenta? <Link href="/login" className="text-secondary font-black hover:underline underline-offset-4">Inicia sesión</Link>
          </p>
        </div>
      </div>
    </div>
  );
}
