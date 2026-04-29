'use client';

import { useState, useEffect } from 'react';
import {
  User, Building2, Mail, ShieldCheck,
  Save, ArrowLeft, Gem, Sparkles, CheckCircle2,
  AlertTriangle, Trash2
} from 'lucide-react';
import { signOut } from 'next-auth/react';
import { motion, AnimatePresence } from 'framer-motion';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { cn } from '@/lib/utils';

export default function ProfilePage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [profile, setProfile] = useState({
    fullName: '',
    businessName: '',
    email: '',
    planType: ''
  });
  const [success, setSuccess] = useState(false);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [deleteConfirm, setDeleteConfirm] = useState('');
  const [deleteReason, setDeleteReason] = useState('');
  const [deleting, setDeleting] = useState(false);
  const [deleteError, setDeleteError] = useState('');

  useEffect(() => {
    async function fetchProfile() {
      try {
        const res = await fetch('/api/user/profile');
        const data = await res.json();
        if (data.profile) {
          setProfile({
            fullName: data.profile.full_name || '',
            businessName: data.profile.business_name || '',
            email: data.profile.email || '',
            planType: data.profile.plan_type || 'Gratis'
          });
        }
      } catch (error) {
        console.error('Failed to fetch profile:', error);
      } finally {
        setLoading(false);
      }
    }
    fetchProfile();
  }, []);

  const handleSave = async (e) => {
    e.preventDefault();
    setSaving(true);
    try {
      const res = await fetch('/api/user/profile', {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          fullName: profile.fullName,
          businessName: profile.businessName
        })
      });
      const data = await res.json();
      if (data.success) {
        setSuccess(true);
        setTimeout(() => setSuccess(false), 3000);
      }
    } catch (error) {
      console.error('Failed to update profile:', error);
    } finally {
      setSaving(false);
    }
  };

  const handleDeleteAccount = async () => {
    if (deleteConfirm !== 'ELIMINAR') return;
    setDeleting(true);
    setDeleteError('');
    try {
      const res = await fetch('/api/user/profile', {
        method: 'DELETE',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ reason: deleteReason }),
      });
      const data = await res.json();
      if (data.success) {
        await signOut({ callbackUrl: '/' });
      } else {
        setDeleteError(data.error || 'No se pudo eliminar la cuenta.');
        setDeleting(false);
      }
    } catch {
      setDeleteError('Error de conexión. Intenta de nuevo.');
      setDeleting(false);
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-[#F5F5F7] flex items-center justify-center">
        <div className="text-center">
          <div className="w-16 h-16 border-4 border-primary border-t-transparent rounded-full animate-spin mx-auto mb-4"></div>
          <p className="text-[10px] font-black uppercase tracking-[0.3em] text-secondary/30 italic">Cargando Identidad...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-[#F5F5F7]">
      {/* Premium Header Accent */}
      <div className="h-[30vh] bg-[#0E2244] relative flex items-center pt-10">
        <div className="container mx-auto px-8 relative z-10 flex flex-col md:flex-row items-center justify-between gap-6">
          <div className="flex items-center gap-6">
            <Link 
              href="/dashboard"
              className="w-12 h-12 rounded-full bg-white/5 border border-white/10 flex items-center justify-center text-white hover:bg-primary hover:text-secondary transition-all"
            >
              <ArrowLeft size={20} />
            </Link>
            <div>
              <h1 className="text-4xl font-black text-white italic tracking-tighter">Mi Perfil</h1>
              <p className="text-white/40 text-[10px] font-black uppercase tracking-widest mt-1 italic">Gestión de Identidad Comercial</p>
            </div>
          </div>

          <div className="flex items-center gap-3 bg-primary py-2 px-6 rounded-full shadow-2xl shadow-primary/20">
            <Gem size={16} className="text-secondary" />
            <span className="text-xs font-black text-secondary uppercase tracking-widest">Plan {profile.planType}</span>
          </div>
        </div>
        <div className="absolute inset-0 bg-gradient-to-b from-[#0E2244] to-[#0E2244]/80 backdrop-blur-sm pointer-events-none" />
      </div>

      <main className="max-w-4xl mx-auto px-8 -mt-16 relative z-20 pb-20">
        <motion.div 
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          className="bg-white rounded-[3.5rem] shadow-2xl shadow-secondary/5 border border-white p-10 md:p-16 relative overflow-hidden"
        >
          {/* Subtle decoration */}
          <div className="absolute top-0 right-0 w-64 h-64 bg-primary/5 rounded-full blur-3xl -translate-y-1/2 translate-x-1/2 pointer-events-none" />

          <form onSubmit={handleSave} className="space-y-12">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-10">
              
              {/* Profile Image & Status */}
              <div className="space-y-8">
                <div className="relative w-32 h-32 mx-auto md:mx-0 group">
                  <div className="w-full h-full rounded-[2.5rem] bg-gradient-to-tr from-primary to-amber-200 p-1 shadow-2xl">
                    <div className="w-full h-full rounded-[2.2rem] bg-white flex items-center justify-center text-secondary">
                      <User size={48} strokeWidth={1.5} />
                    </div>
                  </div>
                  <div className="absolute -bottom-2 -right-2 w-10 h-10 bg-secondary text-white rounded-2xl flex items-center justify-center shadow-lg border-4 border-white">
                    <Sparkles size={16} className="text-primary" />
                  </div>
                </div>

                <div className="space-y-2">
                  <label className="text-[10px] font-black text-secondary/30 uppercase tracking-[0.2em] ml-4 italic">Email de Acceso</label>
                  <div className="relative group">
                    <input 
                      type="email" 
                      value={profile.email} 
                      readOnly 
                      className="w-full h-16 bg-muted/20 border border-border/40 rounded-3xl px-6 pl-14 font-bold text-secondary/40 outline-none cursor-not-allowed italic"
                    />
                    <Mail size={18} className="absolute left-6 top-1/2 -translate-y-1/2 text-secondary/20" />
                  </div>
                  <p className="text-[9px] font-bold text-secondary/20 ml-4 italic">El email no puede ser cambiado por seguridad.</p>
                </div>
              </div>

              {/* Form Fields */}
              <div className="space-y-8">
                <div className="space-y-2">
                  <label className="text-[10px] font-black text-secondary/40 uppercase tracking-[0.2em] ml-4 italic">Nombre Completo</label>
                  <div className="relative group">
                    <input 
                      type="text" 
                      value={profile.fullName}
                      onChange={(e) => setProfile({...profile, fullName: e.target.value})}
                      required
                      placeholder="Tu nombre"
                      className="w-full h-16 bg-white border border-border rounded-3xl px-6 pl-14 font-black text-secondary outline-none focus:border-primary focus:ring-4 focus:ring-primary/5 transition-all shadow-sm italic"
                    />
                    <User size={18} className="absolute left-6 top-1/2 -translate-y-1/2 text-primary" />
                  </div>
                </div>

                <div className="space-y-2">
                  <label className="text-[10px] font-black text-secondary/40 uppercase tracking-[0.2em] ml-4 italic">Nombre del Negocio</label>
                  <div className="relative group">
                    <input 
                      type="text" 
                      value={profile.businessName}
                      onChange={(e) => setProfile({...profile, businessName: e.target.value})}
                      placeholder="Tu marca comercial"
                      className="w-full h-16 bg-white border border-border rounded-3xl px-6 pl-14 font-black text-secondary outline-none focus:border-primary focus:ring-4 focus:ring-primary/5 transition-all shadow-sm italic"
                    />
                    <Building2 size={18} className="absolute left-6 top-1/2 -translate-y-1/2 text-primary" />
                  </div>
                </div>
              </div>
            </div>

            <div className="pt-10 flex flex-col items-center gap-6 border-t border-border/30">
              <AnimatePresence>
                {success && (
                  <motion.div 
                    initial={{ opacity: 0, scale: 0.9 }}
                    animate={{ opacity: 1, scale: 1 }}
                    exit={{ opacity: 0, scale: 0.9 }}
                    className="flex items-center gap-3 bg-emerald-50 text-emerald-600 px-8 py-3 rounded-2xl border border-emerald-100 font-black text-xs uppercase italic"
                  >
                    <CheckCircle2 size={16} /> Perfil actualizado con éxito
                  </motion.div>
                )}
              </AnimatePresence>

              <button 
                type="submit"
                disabled={saving}
                className={cn(
                  "w-full md:w-[300px] h-16 bg-secondary text-white rounded-3xl font-black uppercase tracking-widest text-xs flex items-center justify-center gap-3 hover:bg-primary hover:text-secondary shadow-2xl shadow-secondary/20 transition-all active:scale-95",
                  saving && "opacity-50 pointer-events-none"
                )}
              >
                {saving ? 'Guardando...' : (
                  <>
                    Guardar Cambios <Save size={20} />
                  </>
                )}
              </button>
            </div>
          </form>
        </motion.div>

        {/* Account Info Bar */}
        <div className="mt-12 flex flex-wrap justify-center gap-10">
           <div className="flex items-center gap-3">
              <ShieldCheck size={20} className="text-secondary/20" />
              <p className="text-[10px] font-black text-secondary/30 uppercase tracking-widest italic tracking-tightest">Cuenta Verificada por KLICUS</p>
           </div>
           <p className="text-[10px] text-secondary/10 font-black uppercase tracking-widest italic tracking-tightest">Miembro desde 2026</p>
        </div>

        {/* Danger Zone */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2 }}
          className="mt-10 border-2 border-red-200 rounded-[3rem] p-10 bg-white"
        >
          <div className="flex items-center gap-4 mb-6">
            <div className="w-10 h-10 rounded-2xl bg-red-100 flex items-center justify-center shrink-0">
              <AlertTriangle size={20} className="text-red-500" />
            </div>
            <div>
              <h3 className="text-sm font-black text-secondary uppercase tracking-widest">Zona de Peligro</h3>
              <p className="text-[10px] font-bold text-secondary/40 mt-0.5">Acciones irreversibles sobre tu cuenta</p>
            </div>
          </div>

          <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-6 p-6 rounded-2xl bg-red-50 border border-red-100">
            <div>
              <p className="text-sm font-black text-secondary">Eliminar mi cuenta</p>
              <p className="text-[11px] text-secondary/50 font-medium mt-1 max-w-sm">
                Se eliminarán permanentemente tu perfil, anuncios, historial de pagos y todos tus datos. Esta acción no se puede deshacer.
              </p>
            </div>
            <button
              type="button"
              onClick={() => { setShowDeleteModal(true); setDeleteConfirm(''); setDeleteReason(''); setDeleteError(''); }}
              className="shrink-0 px-6 py-3 rounded-2xl border-2 border-red-500 text-red-500 font-black text-xs uppercase tracking-widest hover:bg-red-500 hover:text-white transition-all flex items-center gap-2"
            >
              <Trash2 size={14} /> Eliminar cuenta
            </button>
          </div>
        </motion.div>
      </main>

      {/* Delete Account Modal */}
      <AnimatePresence>
        {showDeleteModal && (
          <div className="fixed inset-0 z-[100] flex items-center justify-center p-6">
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              onClick={() => !deleting && setShowDeleteModal(false)}
              className="absolute inset-0 bg-secondary/80 backdrop-blur-xl"
            />

            <motion.div
              initial={{ opacity: 0, scale: 0.9, y: 20 }}
              animate={{ opacity: 1, scale: 1, y: 0 }}
              exit={{ opacity: 0, scale: 0.9, y: 20 }}
              className="relative bg-white rounded-[3rem] p-10 max-w-md w-full shadow-2xl overflow-hidden"
            >
              <div className="absolute top-0 right-0 w-40 h-40 bg-red-500/5 rounded-full blur-3xl -translate-y-1/2 translate-x-1/2 pointer-events-none" />

              <div className="flex flex-col items-center text-center gap-6">
                <div className="w-20 h-20 rounded-3xl bg-red-100 flex items-center justify-center text-red-500">
                  <Trash2 size={36} />
                </div>

                <div>
                  <h3 className="text-2xl font-black italic tracking-tighter text-secondary mb-2">¿Eliminar tu cuenta?</h3>
                  <p className="text-sm text-secondary/50 font-medium leading-relaxed">
                    Esta acción es <span className="text-red-500 font-black">permanente e irreversible</span>. Se eliminarán tu perfil, todos tus anuncios y tu historial completo.
                  </p>
                </div>

                <div className="w-full space-y-4 text-left">
                  <div>
                    <label className="text-[10px] font-black text-secondary/40 uppercase tracking-widest block mb-2">
                      Motivo (opcional)
                    </label>
                    <textarea
                      value={deleteReason}
                      onChange={(e) => setDeleteReason(e.target.value)}
                      disabled={deleting}
                      rows={2}
                      placeholder="¿Por qué eliminás tu cuenta?"
                      className="w-full p-4 rounded-2xl bg-[#F5F5F7] border border-border/40 focus:border-red-400 outline-none font-medium text-sm resize-none"
                    />
                  </div>

                  <div>
                    <label className="text-[10px] font-black text-secondary/40 uppercase tracking-widest block mb-2">
                      Escribe <span className="text-red-500">ELIMINAR</span> para confirmar
                    </label>
                    <input
                      type="text"
                      value={deleteConfirm}
                      onChange={(e) => setDeleteConfirm(e.target.value)}
                      disabled={deleting}
                      placeholder="ELIMINAR"
                      className="w-full h-12 px-4 rounded-2xl bg-[#F5F5F7] border border-border/40 focus:border-red-400 outline-none font-black tracking-widest text-sm"
                    />
                  </div>

                  {deleteError && (
                    <p className="text-xs text-red-500 font-bold text-center">{deleteError}</p>
                  )}
                </div>

                <div className="grid grid-cols-2 gap-4 w-full">
                  <button
                    type="button"
                    onClick={() => setShowDeleteModal(false)}
                    disabled={deleting}
                    className="py-4 rounded-2xl bg-[#F5F5F7] text-secondary font-black text-[10px] uppercase tracking-widest hover:bg-secondary hover:text-white transition-all"
                  >
                    Cancelar
                  </button>
                  <button
                    type="button"
                    onClick={handleDeleteAccount}
                    disabled={deleteConfirm !== 'ELIMINAR' || deleting}
                    className={cn(
                      "py-4 rounded-2xl font-black text-[10px] uppercase tracking-widest transition-all flex items-center justify-center gap-2",
                      deleteConfirm === 'ELIMINAR' && !deleting
                        ? "bg-red-500 text-white hover:bg-red-600 shadow-xl shadow-red-500/20"
                        : "bg-red-100 text-red-300 cursor-not-allowed"
                    )}
                  >
                    {deleting ? 'Eliminando...' : <><Trash2 size={12} /> Confirmar</>}
                  </button>
                </div>
              </div>
            </motion.div>
          </div>
        )}
      </AnimatePresence>
    </div>
  );
}
