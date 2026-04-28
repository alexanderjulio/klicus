'use client';

import { useState } from 'react';
import { signIn } from 'next-auth/react';
import { useRouter } from 'next/navigation';
import { Mail, Lock, ArrowRight, AlertCircle, X, Loader2, CheckCircle2, KeyRound } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import Link from 'next/link';
import Logo from '@/components/ui/Logo';
import { cn } from '@/lib/utils';

const STEPS = [
  { key: 'verifying',    label: 'Verificando credenciales...' },
  { key: 'starting',     label: 'Iniciando sesión...' },
  { key: 'redirecting',  label: 'Redireccionando a tu cuenta...' },
];

export default function LoginPage() {
  const [email, setEmail]       = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading]   = useState(false);
  const [stepIdx, setStepIdx]   = useState(0);
  const [error, setError]       = useState(null);
  const router = useRouter();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError(null);
    setLoading(true);
    setStepIdx(0);

    const result = await signIn('credentials', { redirect: false, email, password });

    if (result.ok) {
      setStepIdx(1);
      const res     = await fetch('/api/auth/session');
      const session = await res.json();
      setStepIdx(2);
      await new Promise(r => setTimeout(r, 400));
      router.push(session?.user?.role === 'admin' ? '/dashboard/admin' : '/dashboard');
    } else {
      setError('Correo o contraseña incorrectos. Revisa tus datos e intenta de nuevo.');
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen grid grid-cols-1 lg:grid-cols-2 bg-white">
      {/* Branding */}
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
        <div className="relative z-10 text-secondary/40 text-sm font-bold">© 2026 KLICUS MARKETPLACE</div>
        <div className="absolute top-[-10%] right-[-10%] w-[500px] h-[500px] bg-white/10 rounded-full blur-3xl" />
        <div className="absolute bottom-[-5%] left-[-5%] w-[300px] h-[300px] bg-secondary/5 rounded-full blur-2xl" />
      </div>

      {/* Form */}
      <div className="flex flex-col justify-center items-center p-8 md:p-16">
        <div className="w-full max-w-md">
          <div className="lg:hidden mb-12 flex justify-center">
            <Logo className="h-10" />
          </div>

          <Link href="/" className="inline-flex items-center gap-2 text-sm text-muted-foreground hover:text-secondary mb-8 transition-colors group">
            ← Volver al Inicio
          </Link>

          <div className="mb-10">
            <h2 className="text-3xl font-black text-secondary tracking-tight">Ingresa ahora</h2>
            <p className="text-muted-foreground mt-2">Gestiona tus pautas y conecta con clientes.</p>
          </div>

          {/* Error */}
          <AnimatePresence>
            {error && (
              <motion.div
                initial={{ opacity: 0, y: -10, scale: 0.95 }}
                animate={{ opacity: 1, y: 0, scale: 1 }}
                exit={{ opacity: 0, scale: 0.95 }}
                className="mb-6 p-4 bg-red-50 border border-red-200 rounded-2xl flex items-start gap-3"
              >
                <AlertCircle size={18} className="text-red-500 shrink-0 mt-0.5" />
                <p className="text-sm font-bold text-red-800 flex-1 leading-snug">{error}</p>
                <button onClick={() => setError(null)} className="shrink-0">
                  <X size={16} className="text-red-400 hover:text-red-600" />
                </button>
              </motion.div>
            )}
          </AnimatePresence>

          {/* Progress indicator */}
          <AnimatePresence>
            {loading && (
              <motion.div
                initial={{ opacity: 0, y: -8 }}
                animate={{ opacity: 1, y: 0 }}
                exit={{ opacity: 0 }}
                className="mb-6 p-4 bg-primary/10 border border-primary/20 rounded-2xl flex items-center gap-3"
              >
                <Loader2 size={18} className="text-secondary animate-spin shrink-0" />
                <div className="flex-1">
                  <p className="text-sm font-black text-secondary">{STEPS[stepIdx].label}</p>
                  <div className="mt-2 h-1 bg-secondary/10 rounded-full overflow-hidden">
                    <motion.div
                      className="h-full bg-secondary rounded-full"
                      initial={{ width: '10%' }}
                      animate={{ width: `${((stepIdx + 1) / STEPS.length) * 100}%` }}
                      transition={{ duration: 0.5 }}
                    />
                  </div>
                </div>
              </motion.div>
            )}
          </AnimatePresence>

          <form onSubmit={handleSubmit} className="space-y-5">
            {/* Email */}
            <div className="space-y-2">
              <label className="text-sm font-bold text-secondary uppercase tracking-wider">Email</label>
              <div className="relative">
                <input
                  type="email" required value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  placeholder="ejemplo@klicus.com"
                  disabled={loading}
                  className="w-full bg-muted/30 border border-border rounded-xl px-4 py-3.5 pl-11 outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all text-secondary disabled:opacity-50"
                />
                <Mail size={18} className="absolute left-4 top-1/2 -translate-y-1/2 text-muted-foreground" />
              </div>
            </div>

            {/* Password */}
            <div className="space-y-2">
              <label className="text-sm font-bold text-secondary uppercase tracking-wider">Contraseña</label>
              <div className="relative">
                <input
                  type="password" required value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  placeholder="••••••••"
                  disabled={loading}
                  className="w-full bg-muted/30 border border-border rounded-xl px-4 py-3.5 pl-11 outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all text-secondary disabled:opacity-50"
                />
                <Lock size={18} className="absolute left-4 top-1/2 -translate-y-1/2 text-muted-foreground" />
              </div>
              {/* Forgot password — below the input */}
              <div className="flex items-center gap-2 pt-1">
                <KeyRound size={13} className="text-muted-foreground" />
                <Link
                  href="/recuperar-contrasena"
                  className="text-xs font-bold text-secondary/60 hover:text-secondary transition-colors underline underline-offset-2"
                >
                  ¿Olvidaste tu contraseña?
                </Link>
              </div>
            </div>

            <button
              type="submit" disabled={loading}
              className={cn(
                "w-full font-bold py-4 rounded-xl flex items-center justify-center gap-2 transition-all shadow-lg active:scale-[0.98]",
                loading
                  ? "bg-secondary/60 text-white cursor-not-allowed"
                  : "bg-secondary text-white hover:bg-secondary/90 shadow-secondary/10"
              )}
            >
              {loading ? (
                <><Loader2 size={18} className="animate-spin" /> Procesando...</>
              ) : (
                <>Entrar a mi cuenta <ArrowRight size={18} /></>
              )}
            </button>
          </form>

          <p className="mt-10 text-center text-sm text-muted-foreground">
            ¿Aún no tienes cuenta?{' '}
            <Link href="/register" className="text-secondary font-black hover:underline underline-offset-4">Regístrate gratis</Link>
          </p>
        </div>
      </div>
    </div>
  );
}
