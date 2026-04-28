'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { Mail, Lock, User, CheckCircle2, ChevronLeft, ArrowRight, AlertCircle, Loader2 } from 'lucide-react';
import Link from 'next/link';
import Logo from '@/components/ui/Logo';
import { motion, AnimatePresence } from 'framer-motion';

export default function RegisterPage() {
  const [formData, setFormData] = useState({ name: '', email: '', password: '', confirmPassword: '' });
  const [loading, setLoading] = useState(false);
  const [error, setError]     = useState(null);
  const [success, setSuccess] = useState(false);
  const router = useRouter();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError(null);

    if (formData.password !== formData.confirmPassword) {
      setError('Las contraseñas no coinciden. Verifica e intenta de nuevo.');
      return;
    }
    if (formData.password.length < 6) {
      setError('La contraseña debe tener al menos 6 caracteres.');
      return;
    }

    setLoading(true);
    try {
      const res = await fetch('/api/auth/register', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name: formData.name, email: formData.email, password: formData.password }),
      });
      const data = await res.json();

      if (res.ok) {
        setSuccess(true);
        setTimeout(() => router.push('/login'), 2500);
      } else {
        setError(data.error || 'Ocurrió un error al crear la cuenta. Intenta de nuevo.');
      }
    } catch {
      setError('Error de conexión. Verifica tu internet e intenta de nuevo.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen grid grid-cols-1 lg:grid-cols-2 bg-white">
      {/* Branding */}
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
        <div className="relative z-10 text-white/40 text-sm font-bold">© 2026 KLICUS MARKETPLACE</div>
        <div className="absolute top-[-10%] right-[-10%] w-[500px] h-[500px] bg-primary/10 rounded-full blur-3xl" />
        <div className="absolute bottom-[-5%] left-[-5%] w-[300px] h-[300px] bg-white/5 rounded-full blur-2xl" />
      </div>

      {/* Form */}
      <div className="flex flex-col justify-center items-center p-8 md:p-16">
        <div className="w-full max-w-md">
          <div className="lg:hidden mb-12 flex justify-center">
            <Logo className="h-10" />
          </div>

          <Link href="/login" className="inline-flex items-center gap-2 text-sm text-muted-foreground hover:text-secondary mb-8 transition-colors group">
            <ChevronLeft size={16} className="group-hover:-translate-x-1 transition-transform" />
            Volver al Inicio de Sesión
          </Link>

          <div className="mb-10">
            <h2 className="text-3xl font-black text-secondary tracking-tight">Crea tu cuenta</h2>
            <p className="text-muted-foreground mt-2">Empieza a publicar tus servicios en pocos minutos.</p>
          </div>

          {/* Success */}
          <AnimatePresence>
            {success && (
              <motion.div
                initial={{ opacity: 0, scale: 0.95 }}
                animate={{ opacity: 1, scale: 1 }}
                className="mb-6 p-5 bg-emerald-50 border border-emerald-200 rounded-2xl flex items-start gap-3"
              >
                <CheckCircle2 size={20} className="text-emerald-500 shrink-0 mt-0.5" />
                <div>
                  <p className="text-sm font-black text-emerald-800">¡Cuenta creada con éxito!</p>
                  <p className="text-xs text-emerald-600 mt-1">Serás redirigido al inicio de sesión en unos segundos...</p>
                </div>
              </motion.div>
            )}
          </AnimatePresence>

          {/* Error */}
          <AnimatePresence>
            {error && (
              <motion.div
                initial={{ opacity: 0, y: -10 }}
                animate={{ opacity: 1, y: 0 }}
                exit={{ opacity: 0 }}
                className="mb-6 p-4 bg-red-50 border border-red-200 rounded-2xl flex items-start gap-3"
              >
                <AlertCircle size={18} className="text-red-500 shrink-0 mt-0.5" />
                <p className="text-sm font-bold text-red-800 leading-snug">{error}</p>
              </motion.div>
            )}
          </AnimatePresence>

          <form onSubmit={handleSubmit} className="space-y-5">
            <div className="space-y-2">
              <label className="text-sm font-bold text-secondary uppercase tracking-wider">Nombre Completo / Empresa</label>
              <div className="relative">
                <input
                  type="text" required value={formData.name}
                  onChange={(e) => setFormData({...formData, name: e.target.value})}
                  placeholder="Juan Pérez o CompuByte"
                  disabled={loading || success}
                  className="w-full bg-muted/30 border border-border rounded-xl px-4 py-3 pl-11 outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all text-secondary disabled:opacity-50"
                />
                <User size={18} className="absolute left-4 top-1/2 -translate-y-1/2 text-muted-foreground" />
              </div>
            </div>

            <div className="space-y-2">
              <label className="text-sm font-bold text-secondary uppercase tracking-wider">Email</label>
              <div className="relative">
                <input
                  type="email" required value={formData.email}
                  onChange={(e) => setFormData({...formData, email: e.target.value})}
                  placeholder="ejemplo@correo.com"
                  disabled={loading || success}
                  className="w-full bg-muted/30 border border-border rounded-xl px-4 py-3 pl-11 outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all text-secondary disabled:opacity-50"
                />
                <Mail size={18} className="absolute left-4 top-1/2 -translate-y-1/2 text-muted-foreground" />
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="space-y-2">
                <label className="text-sm font-bold text-secondary uppercase tracking-wider">Contraseña</label>
                <div className="relative">
                  <input
                    type="password" required value={formData.password}
                    onChange={(e) => setFormData({...formData, password: e.target.value})}
                    placeholder="Mín. 6 caracteres"
                    disabled={loading || success}
                    className="w-full bg-muted/30 border border-border rounded-xl px-4 py-3 pl-11 outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all text-secondary disabled:opacity-50"
                  />
                  <Lock size={18} className="absolute left-4 top-1/2 -translate-y-1/2 text-muted-foreground" />
                </div>
              </div>
              <div className="space-y-2">
                <label className="text-sm font-bold text-secondary uppercase tracking-wider">Confirmar</label>
                <div className="relative">
                  <input
                    type="password" required value={formData.confirmPassword}
                    onChange={(e) => setFormData({...formData, confirmPassword: e.target.value})}
                    placeholder="Repite la contraseña"
                    disabled={loading || success}
                    className="w-full bg-muted/30 border border-border rounded-xl px-4 py-3 pl-11 outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all text-secondary disabled:opacity-50"
                  />
                  <Lock size={18} className="absolute left-4 top-1/2 -translate-y-1/2 text-muted-foreground" />
                </div>
              </div>
            </div>

            {/* Password match indicator */}
            {formData.confirmPassword && (
              <p className={`text-xs font-bold flex items-center gap-1.5 -mt-1 ${formData.password === formData.confirmPassword ? 'text-emerald-600' : 'text-red-500'}`}>
                {formData.password === formData.confirmPassword
                  ? <><CheckCircle2 size={13} /> Las contraseñas coinciden</>
                  : <><AlertCircle size={13} /> Las contraseñas no coinciden</>}
              </p>
            )}

            <div className="flex items-start gap-3 py-1">
              <input type="checkbox" required className="mt-1 accent-primary h-4 w-4" />
              <p className="text-xs text-muted-foreground leading-relaxed">
                Acepto los <Link href="/terminos" className="font-bold text-secondary hover:underline">Términos de Servicio</Link> y la <Link href="/privacidad" className="font-bold text-secondary hover:underline">Política de Privacidad</Link>.
              </p>
            </div>

            <button
              type="submit" disabled={loading || success}
              className="w-full bg-primary text-secondary font-black py-4 rounded-xl flex items-center justify-center gap-2 hover:bg-primary/90 transition-all shadow-lg active:scale-[0.98] disabled:opacity-60 mt-2"
            >
              {loading ? (
                <><Loader2 size={18} className="animate-spin" /> Creando tu cuenta...</>
              ) : success ? (
                <><CheckCircle2 size={18} /> Cuenta creada</>
              ) : (
                <>Registrarme ahora <ArrowRight size={18} /></>
              )}
            </button>
          </form>

          <p className="mt-10 text-center text-sm text-muted-foreground">
            ¿Ya tienes una cuenta?{' '}
            <Link href="/login" className="text-secondary font-black hover:underline underline-offset-4">Inicia sesión</Link>
          </p>
        </div>
      </div>
    </div>
  );
}
