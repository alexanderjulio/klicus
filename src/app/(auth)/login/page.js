'use client';

import { useState } from 'react';
import { signIn } from 'next-auth/react';
import { useRouter } from 'next/navigation';
import { Mail, Lock, LogIn, ChevronLeft, ArrowRight, AlertCircle, X } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import Link from 'next/link';
import Logo from '@/components/ui/Logo';
import { useToast } from '@/context/ToastContext';

export default function LoginPage() {
  const { showToast } = useToast();
  const [email, setEmail] = useState('');

  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [localError, setLocalError] = useState(null);
  const router = useRouter();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setLocalError(null);
    const result = await signIn('credentials', {
      redirect: false,
      email,
      password,
    });

    if (result.ok) {
      // Fetch session to determine role-based redirect
      const res = await fetch('/api/auth/session');
      const session = await res.json();
      
      if (session?.user?.role === 'admin') {
        router.push('/dashboard/admin');
      } else {
        router.push('/dashboard');
      }
    } else {
      setLocalError('Credenciales incorrectas. Por favor, revisa tus datos de acceso.');
      setLoading(false);
    }


  };

  return (
    <div className="min-h-screen grid grid-cols-1 lg:grid-cols-2 bg-white">
      {/* Left Side: Visual/Branding (Desktop Only) */}
      <div className="hidden lg:flex flex-col justify-between bg-primary p-12 relative overflow-hidden">
        <div className="relative z-10">
          <Logo className="h-12" />
          <h1 className="text-6xl font-black text-secondary mt-20 leading-[0.9] tracking-tighter">
            Conecta con <br /> lo mejor de <br /> tu región.
          </h1>
          <p className="text-secondary/70 text-lg mt-6 max-w-md font-medium">
            La plataforma líder de pautas publicitarias donde profesionales y comercios premium encuentran su lugar.
          </p>
        </div>
        
        <div className="relative z-10 text-secondary/40 text-sm font-bold">
          © 2026 KLICUS MARKETPLACE
        </div>

        {/* Abstract Background Shapes */}
        <div className="absolute top-[-10%] right-[-10%] w-[500px] h-[500px] bg-white/10 rounded-full blur-3xl" />
        <div className="absolute bottom-[-5%] left-[-5%] w-[300px] h-[300px] bg-secondary/5 rounded-full blur-2xl" />
      </div>

      {/* Right Side: Login Form */}
      <div className="flex flex-col justify-center items-center p-8 md:p-16">
        <div className="w-full max-w-md">
          <div className="lg:hidden mb-12 flex justify-center">
             <Logo className="h-10" />
          </div>

          <Link 
            href="/" 
            className="inline-flex items-center gap-2 text-sm text-muted-foreground hover:text-secondary mb-8 transition-colors group"
          >
            <ChevronLeft size={16} className="group-hover:-translate-x-1 transition-transform" /> 
            Volver al Inicio
          </Link>

          <div className="mb-10">
            <h2 className="text-3xl font-black text-secondary tracking-tight">Ingresa ahora</h2>
            <p className="text-muted-foreground mt-2">Gestiona tus pautas y conecta con clientes.</p>
          </div>

          <AnimatePresence>
            {localError && (
              <motion.div 
                initial={{ opacity: 0, y: -10, scale: 0.95 }}
                animate={{ opacity: 1, y: 0, scale: 1 }}
                exit={{ opacity: 0, scale: 0.95 }}
                className="mb-8 p-4 bg-red-50 dark:bg-red-500/10 border border-red-200 dark:border-red-500/20 rounded-2xl flex items-center gap-3 relative group"
              >
                <div className="w-10 h-10 rounded-full bg-red-100 dark:bg-red-500/20 flex items-center justify-center flex-shrink-0">
                  <AlertCircle size={20} className="text-red-500" />
                </div>
                <div className="flex-1">
                  <p className="text-sm font-bold text-red-800 dark:text-red-200 tracking-tight leading-tight">
                    {localError}
                  </p>
                </div>
                <button 
                  onClick={() => setLocalError(null)}
                  className="p-1 hover:bg-black/5 dark:hover:bg-white/5 rounded-lg transition-colors"
                >
                  <X size={16} className="text-red-400 group-hover:text-red-600 transition-colors" />
                </button>
              </motion.div>
            )}
          </AnimatePresence>

          <form onSubmit={handleSubmit} className="space-y-6">
            <div className="space-y-2">
              <label className="text-sm font-bold text-secondary uppercase tracking-wider">Email</label>
              <div className="relative">
                <input 
                  type="email" 
                  required 
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  placeholder="ejemplo@klicus.com"
                  className="w-full bg-muted/30 border border-border rounded-xl px-4 py-3.5 pl-11 outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all text-secondary"
                />
                <Mail size={18} className="absolute left-4 top-1/2 -translate-y-1/2 text-muted-foreground" />
              </div>
            </div>

            <div className="space-y-2">
              <div className="flex justify-between items-center">
                <label className="text-sm font-bold text-secondary uppercase tracking-wider">Contraseña</label>
                <a href="#" className="text-xs font-bold text-primary-foreground hover:underline">¿La olvidaste?</a>
              </div>
              <div className="relative">
                <input 
                  type="password" 
                  required 
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  placeholder="••••••••"
                  className="w-full bg-muted/30 border border-border rounded-xl px-4 py-3.5 pl-11 outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all text-secondary"
                />
                <Lock size={18} className="absolute left-4 top-1/2 -translate-y-1/2 text-muted-foreground" />
              </div>
            </div>

            <button 
              type="submit" 
              disabled={loading}
              className="w-full bg-secondary text-white font-bold py-4 rounded-xl flex items-center justify-center gap-2 hover:bg-secondary/90 transition-all shadow-lg shadow-secondary/10 active:scale-[0.98] disabled:opacity-50"
            >
              {loading ? 'Iniciando...' : 'Entrar a mi cuenta'} 
              {!loading && <ArrowRight size={18} />}
            </button>
          </form>

          <p className="mt-12 text-center text-sm text-muted-foreground">
            ¿Aún no tienes cuenta? <Link href="/register" className="text-secondary font-black hover:underline underline-offset-4">Regístrate gratis</Link>
          </p>
        </div>
      </div>
    </div>
  );
}

