'use client';

import { useState, useEffect } from 'react';
import { 
  Users, FileText, CreditCard, Activity, 
  TrendingUp, ArrowUpRight, Check, X, Clock,
  LayoutDashboard, Settings, LogOut, Bell,
  Search, Filter, Shield, MoreHorizontal, Mail, PlusSquare,
  Plus, Trash2, Edit3, Palette, ShieldCheck, PlusCircle,
  QrCode, MessageCircle, BarChart3, ExternalLink, Send
} from 'lucide-react';

import { motion, AnimatePresence } from 'framer-motion';
import AdminChart from '@/components/admin/AdminChart';
import AnalyticsDashboard from '@/components/dashboard/AnalyticsDashboard';
import NotificationCenter from '@/components/NotificationCenter';
import { cn } from '@/lib/utils';
import Link from 'next/link';
import { useSession, signOut } from 'next-auth/react';
import { useToast } from '@/context/ToastContext';

export default function AdminDashboard() {
  const { showToast } = useToast();
  const { data: session } = useSession();

  const [data, setData] = useState(null);
  const [users, setUsers] = useState([]);
  const [roles, setRoles] = useState([]);
  const [loading, setLoading] = useState(true);
  const [activeTab, setActiveTab] = useState('overview');

  const [actionLoading, setActionLoading] = useState(null);
  const [plans, setPlans] = useState([]);
  const [savingPlan, setSavingPlan] = useState(null);
  
  // Modals State
  const [selectedUser, setSelectedUser] = useState(null);
  const [showCreateUser, setShowCreateUser] = useState(false);
  const [newUserData, setNewUserData] = useState({ full_name: '', email: '', password: '', role: 'cliente' });
  const [editingRole, setEditingRole] = useState(null);
  const [showRoleForm, setShowRoleForm] = useState(false);
  const [selectedAd, setSelectedAd] = useState(null);
  const [manualPayments, setManualPayments] = useState([]);
  const [isSettingsLoading, setIsSettingsLoading] = useState(false);
  const [uploadingQR, setUploadingQR] = useState(null); 
  const [selectedAdAnalytics, setSelectedAdAnalytics] = useState(null);
  const [isAnalyticsLoading, setIsAnalyticsLoading] = useState(false);
  const [rankings, setRankings] = useState([]);
  const [metricsLoading, setMetricsLoading] = useState(false);
  const [metricsSearch, setMetricsSearch] = useState('');

  // Custom Modal States
  const [rejectionModal, setRejectionModal] = useState({ isOpen: false, adId: null, reason: '' });
  const [confirmModal, setConfirmModal] = useState({ 
    isOpen: false, 
    targetId: null, 
    type: null, 
    title: '', 
    message: '', 
    onConfirm: null 
  });
  const [broadcastData, setBroadcastData] = useState({ title: '', message: '', image: '' });
  const [isBroadcasting, setIsBroadcasting] = useState(false);

  const fetchStats = async () => {
    try {
      const res = await fetch('/api/admin/stats');
      const result = await res.json();
      setData(result.data);
    } catch (error) {
      console.error('Fetch Stats Error:', error);
      showToast('Error al cargar estadísticas', 'error');
    }
  };

  const fetchSettings = async () => {
    setIsSettingsLoading(true);
    try {
      const res = await fetch('/api/admin/settings');
      const result = await res.json();
      setManualPayments(result.manualPayments || []);
    } catch (error) {
      console.error('Fetch Settings Error:', error);
      showToast('Error al cargar configuración de pagos', 'error');
    }
    setIsSettingsLoading(false);
  };

  const fetchRankings = async () => {
    setMetricsLoading(true);
    try {
      showToast('Sincronizando métricas...', 'info');
      const res = await fetch('/api/admin/metrics/ranking');
      const json = await res.json();
      
      if (res.ok) {
        const list = json.rankings || [];
        setRankings(list);
        if (list.length > 0) {
            showToast(`Se cargaron ${list.length} pautas activas`, 'success');
        } else {
            showToast('No se encontraron pautas activas', 'warning');
        }
      } else {
        showToast(json.error || 'Error al obtener métricas', 'error');
        setRankings([]);
      }
    } catch (error) {
       console.error('Failed to fetch rankings:', error);
       showToast('Error de conexión con el servidor de métricas', 'error');
       setRankings([]);
    }
    setMetricsLoading(false);
  };

  const fetchUsers = async () => {
    try {
      const res = await fetch('/api/admin/users');
      const json = await res.json();
      setUsers(json.users || []);
    } catch (error) {
      console.error('Failed to fetch users:', error);
    }
  };

  const fetchRoles = async () => {
    try {
      const res = await fetch('/api/admin/roles');
      const json = await res.json();
      setRoles(json.roles || []);
    } catch (error) {
      console.error('Failed to fetch roles:', error);
    }
  };

  const fetchPlans = async () => {
    try {
      const res = await fetch('/api/admin/plans');
      const json = await res.json();
      setPlans(json.plans || []);
    } catch (error) {
      console.error('Failed to fetch plans:', error);
    }
  };

  useEffect(() => {
    async function init() {
      setLoading(true);
      await Promise.all([fetchStats(), fetchPlans(), fetchRoles(), fetchSettings()]);
      setLoading(false);
    }
    init();
  }, []);

  useEffect(() => {
    if (activeTab === 'usuarios') {
      fetchUsers();
    } else if (activeTab === 'metrics') {
      fetchRankings();
    }
  }, [activeTab]);

  const handleAdAction = async (adId, status, manualReason = null) => {
    let reason = manualReason;
    
    if (status === 'rejected' && !manualReason) {
      setRejectionModal({ isOpen: true, adId, reason: '' });
      return;
    }

    setRejectionModal({ isOpen: false, adId: null, reason: '' });
    setActionLoading(adId);
    try {
      const res = await fetch('/api/admin/approve-ad', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ adId, status, reason })
      });
      
        if (res.ok) {
        showToast(status === 'active' ? 'Pauta aprobada con éxito' : 'Pauta actualizada', 'success');
        
        // Refresh EVERYTHING "in hot" to ensure UI consistency
        fetchStats();
        if (activeTab === 'metrics') {
            fetchRankings();
        }
      } else {
        const err = await res.json();
        showToast(err.error || 'Error al procesar la pauta', 'error');
        fetchStats(); // Rollback if error
      }
    } catch (error) {
      console.error('Action failed:', error);
      showToast('Error de conexión al procesar pauta', 'error');
    } finally {
      setActionLoading(null);
    }
  };

  const handleUserAction = async (targetUserId, action, value = null) => {
    if (action === 'delete') {
      setConfirmModal({
        isOpen: true,
        targetId: targetUserId,
        type: 'user',
        title: 'Eliminar Usuario',
        message: '¿Estás seguro de que deseas eliminar permanentemente a este usuario? Esta acción no se puede deshacer.',
        onConfirm: () => executeUserAction(targetUserId, 'delete')
      });
      return;
    }
    executeUserAction(targetUserId, action, value);
  };

  const executeUserAction = async (targetUserId, action, value = null) => {
    setConfirmModal({ ...confirmModal, isOpen: false });
    setActionLoading(targetUserId);
    try {
      const res = await fetch('/api/admin/users/action', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ targetUserId, action, value })
      });

      if (res.ok) {
        showToast('Acción completada con éxito', 'success');
        
        // Optimistic State Update for Users Table
        if (action === 'delete') {
          setUsers(prev => prev.filter(u => u.id !== targetUserId));
        } else if (action === 'role_change') {
          setUsers(prev => prev.map(u => u.id === targetUserId ? { ...u, role: value } : u));
        } else {
          fetchUsers(); // Fallback for complex actions
        }
      } else {
        const error = await res.json();
        showToast(error.error || 'Error procesando la acción', 'error');
      }
    } catch (error) {
      console.error('User action failed:', error);
    } finally {
      setActionLoading(null);
    }
  };

  const handleCreateUser = async (e) => {
    e.preventDefault();
    setActionLoading('creating');
    try {
      const res = await fetch('/api/admin/users/create', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(newUserData)
      });
      if (res.ok) {
        const result = await res.json();
        showToast('Usuario creado con éxito', 'success');
        setShowCreateUser(false);
        setNewUserData({ full_name: '', email: '', password: '', role: 'cliente' });
        
        // Inject new user locally for instant update
        if (result.user) {
            setUsers(prev => [result.user, ...prev]);
        } else {
            fetchUsers();
        }
      } else {
        const err = await res.json();
        showToast(err.error, 'error');
      }
    } catch (error) {
      showToast('Error al crear usuario', 'error');
    } finally {
      setActionLoading(null);
    }
  };

  const handleSaveRole = async (e) => {
    e.preventDefault();
    try {
      const res = await fetch('/api/admin/roles', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(editingRole)
      });
      if (res.ok) {
        showToast('Rol guardado correctamente', 'success');
        setShowRoleForm(false);
        
        // Update roles state locally
        if (editingRole.id) {
           setRoles(prev => prev.map(r => r.id === editingRole.id ? editingRole : r));
        } else {
           fetchRoles(); // If new role, fetch to get the ID
        }
      }
    } catch (error) {
      showToast('Error al guardar rol', 'error');
    }
  };

  const handleDeleteRole = async (id) => {
    setConfirmModal({
      isOpen: true,
      targetId: id,
      type: 'role',
      title: 'Eliminar Rol',
      message: '¿Estás seguro de que deseas eliminar este rol? Los usuarios con este rol quedarán sin privilegios de acceso.',
      onConfirm: async () => {
        setConfirmModal(prev => ({ ...prev, isOpen: false }));
        try {
          const res = await fetch(`/api/admin/roles?id=${id}`, { method: 'DELETE' });
          if (res.ok) {
            showToast('Rol eliminado', 'success');
            fetchRoles();
          } else {
            const err = await res.json();
            showToast(err.error, 'error');
          }
        } catch (error) {
          showToast('Error al eliminar', 'error');
        }
      }
    });
  };

  const handleUpdatePlan = async (plan) => {
    setSavingPlan(plan.plan_name);
    try {
      const res = await fetch('/api/admin/plans', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(plan)
      });
      if (res.ok) {
        showToast(`Plan ${plan.plan_name} actualizado correctamente.`, 'success');
        
        // Update plans locally for instant feedback
        setPlans(prev => prev.map(p => p.id === plan.id ? { ...p, ...plan } : p));
      }
    } catch (error) {
      console.error('Plan update failed:', error);
    } finally {
      setSavingPlan(null);
    }
  };

  const handleSaveSettings = async (e) => {
    if (e) e.preventDefault();
    setActionLoading('saving-settings');
    try {
      const res = await fetch('/api/admin/settings', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ manualPayments })
      });
      const result = await res.json();
      if (result.success) {
        showToast('Configuración de pagos guardada', 'success');
      } else {
        showToast(result.error || 'Error al guardar', 'error');
      }
    } catch (error) {
      showToast('Error de conexión', 'error');
    }
    setActionLoading(null);
  };

  const addPaymentMethod = () => {
    const newMethod = {
      id: Date.now().toString(),
      name: 'Nuevo Método',
      type: 'Ahorros',
      number: '',
      owner: '',
      qr_enabled: false,
      qr_image: '/assets/qr-pago-klicus.png',
      whatsapp_number: '',
      whatsapp_message: 'He realizado el pago.'
    };
    setManualPayments([...manualPayments, newMethod]);
  };

  const updatePaymentMethod = (id, field, value) => {
    setManualPayments(manualPayments.map(m => m.id === id ? { ...m, [field]: value } : m));
  };

  const deletePaymentMethod = (id) => {
    setConfirmModal({
      isOpen: true,
      targetId: id,
      type: 'payment',
      title: 'Eliminar Método',
      message: '¿Deseas remover este método de pago? Tendrás que configurarlo de nuevo si lo eliminas.',
      onConfirm: () => {
        setManualPayments(manualPayments.filter(m => m.id !== id));
        setConfirmModal(prev => ({ ...prev, isOpen: false }));
        showToast('Método removido localmente. Recuerda Guardar Cambios.', 'info');
      }
    });
  };

  const handleQRUpload = async (methodId, file) => {
    if (!file) return;
    setUploadingQR(methodId);
    
    const formData = new FormData();
    formData.append('file', file);

    try {
      const res = await fetch('/api/admin/settings/upload-qr', {
        method: 'POST',
        body: formData
      });
      const result = await res.json();
      
      if (result.success) {
        updatePaymentMethod(methodId, 'qr_image', result.url);
        showToast('Código QR subido con éxito', 'success');
      } else {
        showToast(result.error || 'Error al subir QR', 'error');
      }
    } catch (error) {
      showToast('Error de conexión al subir QR', 'error');
    }
    setUploadingQR(null);
  };

  const fetchAdAnalytics = async (adId, startDate = '', endDate = '') => {
    setIsAnalyticsLoading(true);
    // Keep ID if opening for the first time
    setSelectedAdAnalytics(prev => (prev?.id === adId ? prev : { id: adId })); 

    try {
      let url = `/api/admin/analytics/${adId}`;
      if (startDate && endDate) {
        url += `?startDate=${startDate}&endDate=${endDate}`;
      }
      
      const res = await fetch(url);
      const result = await res.json();
      if (result.success) {
        setSelectedAdAnalytics(prev => ({ ...result, id: adId }));
      } else {
        showToast(result.error, 'error');
        setSelectedAdAnalytics(null);
      }
    } catch (error) {
      showToast('Error al cargar analítica', 'error');
      setSelectedAdAnalytics(null);
    }
    setIsAnalyticsLoading(false);
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-[#F8F9FA] dark:bg-zinc-950 flex items-center justify-center">
        <div className="text-center">
          <div className="w-16 h-16 border-4 border-primary border-t-transparent rounded-full animate-spin mx-auto mb-4"></div>
          <p className="text-secondary dark:text-white font-black uppercase tracking-widest text-xs">Cargando KLICUS Admin...</p>
        </div>
      </div>
    );
  }

  const statCards = [
    { label: 'Usuarios Totales', value: data?.stats?.users || '0', icon: <Users size={20} />, trend: '+12%', color: 'from-blue-500 to-cyan-500', tab: 'usuarios' },
    { label: 'Pautas Activas', value: data?.stats?.activeAds || '0', icon: <FileText size={20} />, trend: '+5%', color: 'from-amber-500 to-orange-500', tab: 'pautas' },
    { label: 'Ingresos Mes', value: `$${(data?.stats?.revenue || 0).toLocaleString()}`, icon: <CreditCard size={20} />, trend: '+18%', color: 'from-emerald-500 to-teal-500', tab: 'config' },
    { label: 'Pautas Pendientes', value: data?.stats?.pendingAds || '0', icon: <Clock size={20} />, trend: 'Pendiente', color: 'from-indigo-500 to-purple-500', tab: 'pautas' },
  ];

  return (
    <div className="min-h-screen bg-[#F8F9FA] dark:bg-zinc-950 transition-colors duration-500">
      <nav className="fixed top-0 left-0 right-0 z-[60] bg-[#0E2244] border-b border-white/10 py-3 px-6 flex items-center justify-between shadow-2xl">
        <div className="flex items-center gap-6">
          <Link href="/" className="text-lg font-black italic tracking-tighter text-white shrink-0">
            KLICUS<span className="text-primary">.</span>ADMIN
          </Link>
          <div className="flex items-center gap-1 bg-white/5 p-1 rounded-xl overflow-x-auto no-scrollbar">
            {[
              { key: 'overview',   label: 'General' },
              { key: 'pautas',     label: 'Pautas' },
              { key: 'metrics',    label: 'Métricas' },
              { key: 'mensajeria', label: 'Mensajería' },
              { key: 'usuarios',   label: 'Usuarios' },
              { key: 'config',     label: 'Ajustes' },
              { key: 'perfil',     label: 'Yo' },
            ].map(({ key, label }) => (
              <button
                key={key}
                onClick={() => setActiveTab(key)}
                className={cn(
                  "px-4 py-1.5 rounded-lg text-[10px] font-black transition-all uppercase tracking-widest whitespace-nowrap",
                  activeTab === key || (key === 'usuarios' && activeTab === 'roles')
                    ? "bg-primary text-secondary shadow-sm"
                    : "text-white/50 hover:text-white"
                )}
              >
                {label}
              </button>
            ))}
          </div>
        </div>
        <div className="flex items-center gap-3 shrink-0">
          <NotificationCenter />
          <button onClick={() => signOut({ callbackUrl: '/' })} className="p-2 rounded-full bg-red-500/20 text-red-400 hover:bg-red-500 hover:text-white transition-all" title="Cerrar sesión">
            <LogOut size={18} />
          </button>
          <div className="w-9 h-9 rounded-full bg-gradient-to-tr from-primary to-amber-300 flex items-center justify-center text-secondary font-black text-xs uppercase shadow-lg">
            {session?.user?.name?.charAt(0) || 'A'}
          </div>
        </div>
      </nav>

      <main className="container mx-auto px-6 pt-32 pb-24">
        {activeTab === 'overview' && (
          <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }}>
            <header className="mb-12">
              <div className="flex flex-col md:flex-row md:items-end justify-between gap-6">
                <div>
                  <h1 className="text-5xl font-black text-secondary dark:text-white tracking-tighter leading-none mb-2 italic">Dashboard <span className="text-primary">Master</span></h1>
                  <p className="text-muted-foreground font-medium text-lg italic">Control absoluto de la red KLICUS.</p>
                </div>
                <div className="flex gap-3">
                   <div className="px-6 h-14 bg-white dark:bg-zinc-900 border border-border dark:border-white/5 rounded-2xl flex items-center gap-3 text-sm font-black text-secondary dark:text-white">
                      <Clock size={18} className="text-primary" /> {new Date().toLocaleDateString()}
                   </div>
                </div>
              </div>
            </header>

            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-12">
              {statCards.map((stat, i) => (
                <button 
                  key={i} 
                  onClick={() => setActiveTab(stat.tab)}
                  className="group text-left bg-white dark:bg-zinc-900/50 backdrop-blur-sm p-8 rounded-[2.5rem] border border-border/50 dark:border-white/5 shadow-sm hover:shadow-2xl transition-all duration-500 relative overflow-hidden"
                >
                  <div className="flex justify-between items-start mb-8 relative z-10">
                    <div className={cn("p-4 rounded-2xl bg-gradient-to-br text-white shadow-lg", stat.color)}>{stat.icon}</div>
                    <div className="flex items-center gap-1 text-emerald-600 dark:text-emerald-400 bg-emerald-50 dark:bg-emerald-500/10 px-3 py-1 rounded-full text-[10px] font-black tracking-tighter uppercase"><ArrowUpRight size={12} /> {stat.trend}</div>
                  </div>
                  <div className="relative z-10">
                    <div className="text-4xl font-black text-secondary dark:text-white tracking-tighter leading-none mb-1">{stat.value}</div>
                    <div className="text-[10px] font-black text-muted-foreground uppercase tracking-widest">{stat.label}</div>
                  </div>
                </button>
              ))}
            </div>

            <div className="bg-white dark:bg-zinc-900 rounded-[3rem] p-10 border border-border/50 dark:border-white/5 shadow-xl mb-12">
               <h2 className="text-2xl font-black text-secondary dark:text-white flex items-center gap-3 italic mb-10"><TrendingUp size={28} className="text-primary" /> Rendimiento Global</h2>
               <AdminChart data={data?.chartData || []} />
            </div>
          </motion.div>
        )}

        {activeTab === 'pautas' && (
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }}>
             <div className="bg-white dark:bg-zinc-900 rounded-[3rem] p-12 border border-border/50 dark:border-white/5 shadow-2xl">
                <div className="flex flex-col md:flex-row md:items-center justify-between gap-6 mb-12">
                  <div>
                    <h2 className="text-3xl font-black text-secondary dark:text-white italic tracking-tighter flex items-center gap-4"><LayoutDashboard size={32} className="text-primary" /> Cola de Aprobaciones</h2>
                    <p className="text-muted-foreground font-medium mt-2">Valida las pautas pendientes de activación.</p>
                  </div>
                  <div className="px-6 py-3 bg-primary/10 text-primary rounded-xl font-black text-xs uppercase tracking-widest border border-primary/20">{data?.queue?.length || 0} Pendientes</div>
                </div>
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                  <AnimatePresence>
                    {data?.queue?.length > 0 ? (
                      data.queue.map((ad) => (
                        <motion.div key={ad.id} layout initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }} exit={{ opacity: 0, scale: 0.9 }} className="bg-[#F8F9FA] dark:bg-white/5 p-8 rounded-[2.5rem] border border-border/50 dark:border-white/5 flex flex-col group hover:border-primary transition-all duration-500 hover:shadow-2xl">
                           <div className="flex justify-between items-start mb-6">
                              <div className="w-16 h-16 rounded-3xl bg-white dark:bg-zinc-800 shadow-xl flex items-center justify-center text-primary group-hover:scale-110 transition-transform"><FileText size={32} strokeWidth={1.5} /></div>
                              <span className="px-4 py-1.5 bg-yellow-400/10 text-yellow-600 rounded-full text-[9px] font-black uppercase tracking-widest border border-yellow-400/20">{ad.plan_type?.toUpperCase() || 'BASIC'}</span>
                           </div>
                           <h3 className="text-xl font-black text-secondary dark:text-white italic leading-tight mb-2 truncate">{ad.title}</h3>
                           <p className="text-xs text-muted-foreground font-medium mb-8">De {ad.owner_name || 'Anunciante'}</p>
                           <div className="flex flex-col gap-3 mt-auto">
                              <div className="flex gap-2">
                                 <button onClick={() => setSelectedAd(ad)} className="flex-1 h-12 bg-muted/20 hover:bg-muted/40 text-secondary dark:text-white rounded-2xl font-black text-[10px] uppercase tracking-widest transition-all">Ver Detalles</button>
                                 <button onClick={() => fetchAdAnalytics(ad.id)} className="w-12 h-12 bg-primary/20 text-primary rounded-2xl flex items-center justify-center hover:bg-primary hover:text-secondary transition-all shadow-sm" title="Ver Analítica"><BarChart3 size={18} /></button>
                              </div>
                              <div className="flex gap-4">
                                 <button onClick={() => handleAdAction(ad.id, 'active')} className="flex-1 h-14 bg-emerald-500 text-white rounded-2xl font-black text-xs uppercase tracking-widest hover:bg-emerald-600 transition-all flex items-center justify-center gap-2 shadow-lg shadow-emerald-500/20 disabled:opacity-50">{actionLoading === ad.id ? <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" /> : <><Check size={18} /> Aprobar</>}</button>
                                 <button onClick={() => handleAdAction(ad.id, 'rejected')} disabled={actionLoading === ad.id} className="h-14 w-14 bg-red-500/10 text-red-500 rounded-2xl font-black hover:bg-red-500 hover:text-white transition-all flex items-center justify-center shadow-lg shadow-red-500/5 disabled:opacity-50"><X size={20} /></button>
                              </div>
                           </div>
                        </motion.div>
                      ))
                    ) : (
                      <div className="col-span-full py-20 text-center bg-muted/20 rounded-[3rem] border-2 border-dashed border-border/40"><Check size={48} className="text-emerald-500 mx-auto mb-4 opacity-50" /><p className="text-xl font-black text-muted-foreground italic">¡Sin pendientes!</p></div>
                    )}
                  </AnimatePresence>
                </div>
             </div>
          </motion.div>
        )}
        {activeTab === 'metrics' && (
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="space-y-12">
             <div className="bg-white dark:bg-zinc-900 rounded-[3.5rem] p-12 border border-border/50 dark:border-white/5 shadow-2xl">
                <div className="flex flex-col md:flex-row md:items-center justify-between gap-6 mb-12">
                   <div>
                      <h2 className="text-3xl font-black text-secondary dark:text-white italic tracking-tighter flex items-center gap-4"><BarChart3 size={32} className="text-primary" /> Inteligencia de Tráfico</h2>
                      <p className="text-muted-foreground font-medium mt-2">Seguimiento detallado de audiencia y rendimiento comercial.</p>
                   </div>
                   <div className="flex items-center gap-3">
                      <div className="relative group">
                         <Search className="absolute left-4 top-1/2 -translate-y-1/2 text-muted-foreground" size={16} />
                         <input 
                           type="text" 
                           placeholder="Buscar pauta..." 
                           value={metricsSearch}
                           onChange={(e) => setMetricsSearch(e.target.value)}
                           className="h-12 pl-12 pr-6 bg-muted/20 dark:bg-white/5 rounded-2xl outline-none focus:ring-2 focus:ring-primary/20 border border-transparent focus:border-primary/30 transition-all font-bold text-[10px] uppercase tracking-widest w-64"
                         />
                      </div>
                      <button 
                        onClick={fetchRankings}
                        className="h-12 w-12 bg-muted/20 dark:bg-white/5 rounded-2xl flex items-center justify-center text-secondary dark:text-white hover:bg-primary hover:text-secondary transition-all"
                      >
                         <Activity size={18} className={metricsLoading ? 'animate-spin' : ''} />
                      </button>
                   </div>
                </div>

                <div className="overflow-x-auto pb-8">
                   <table className="w-full text-left">
                      <thead>
                         <tr className="border-b border-border/40 dark:border-white/5">
                            <th className="pb-6 text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground px-4">Pauta</th>
                            <th className="pb-6 text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground px-4 text-center">Vistas</th>
                            <th className="pb-6 text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground px-4 text-center">Clicks</th>
                            <th className="pb-6 text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground px-4 text-center">Contactos</th>
                            <th className="pb-6 text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground px-4 text-center">CTR</th>
                            <th className="pb-6 text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground px-4 text-right">Acción</th>
                         </tr>
                      </thead>
                      <tbody className="divide-y divide-border/20 dark:divide-white/5">
                         {rankings
                           .filter(r => r.title.toLowerCase().includes(metricsSearch.toLowerCase()))
                           .map((ad) => {
                             const ctr = ad.views > 0 ? ((ad.clicks / ad.views) * 100).toFixed(1) : '0.0';
                             return (
                               <tr key={ad.id} className="group hover:bg-muted/10 dark:hover:bg-white/5 transition-colors">
                                  <td className="py-6 px-4">
                                     <div className="flex flex-col">
                                        <span className="font-black text-secondary dark:text-white italic">{ad.title}</span>
                                        <span className="text-[10px] text-muted-foreground font-medium uppercase tracking-widest">{ad.owner_name}</span>
                                     </div>
                                  </td>
                                  <td className="py-6 px-4 text-center text-sm font-black text-secondary dark:text-white">{ad.views}</td>
                                  <td className="py-6 px-4 text-center text-sm font-black text-primary">{ad.clicks}</td>
                                  <td className="py-6 px-4 text-center text-sm font-black text-emerald-500">{ad.contacts}</td>
                                  <td className="py-6 px-4 text-center">
                                     <span className={cn("px-3 py-1 rounded-full text-[10px] font-black tracking-tighter", parseFloat(ctr) > 5 ? "bg-emerald-500/10 text-emerald-500" : "bg-muted/20 text-muted-foreground")}>
                                        {ctr}%
                                     </span>
                                  </td>
                                  <td className="py-6 px-4 text-right">
                                     <button 
                                       onClick={() => fetchAdAnalytics(ad.id)}
                                       className="px-6 py-2.5 rounded-2xl bg-secondary text-white text-[10px] font-black uppercase tracking-widest hover:bg-primary hover:text-secondary transition-all shadow-lg flex items-center gap-2"
                                     >
                                        <BarChart3 size={14} /> Analítica
                                     </button>
                                  </td>
                               </tr>
                             );
                           })}
                      </tbody>
                   </table>
                   {rankings.length === 0 && !metricsLoading && (
                      <div className="py-20 text-center opacity-40 italic font-black uppercase text-xs tracking-widest">No hay datos de rendimiento disponibles todavía.</div>
                   )}
                </div>
             </div>
             
             <div className="bg-white dark:bg-zinc-900 rounded-[3.5rem] p-12 border border-border/50 dark:border-white/5 shadow-2xl">
                <div className="flex items-center justify-between mb-10">
                   <h2 className="text-2xl font-black text-secondary dark:text-white flex items-center gap-3 italic"><TrendingUp size={28} className="text-primary" /> Tendencia de Crecimiento Global</h2>
                   <button 
                    onClick={() => {
                        // Using the existing AnalyticsDashboard for global context
                        setSelectedAdAnalytics({
                            adTitle: 'Reporte Global de Rendimiento',
                            totals: {
                                views: data?.chartData?.reduce((acc, curr) => acc + curr.vistas, 0) || 0,
                                clicks: data?.chartData?.reduce((acc, curr) => acc + curr.click, 0) || 0,
                                contacts: data?.chartData?.reduce((acc, curr) => acc + curr.contactos, 0) || 0,
                                ctr: 0.0,
                                conversionRate: 0.0
                            },
                            timeSeries: data?.chartData?.map(d => ({
                                date: d.date,
                                views: d.vistas,
                                clicks: d.click,
                                contacts: d.contactos
                            })) || [],
                            devices: [
                                { name: 'Mobile', value: 75, color: '#1C1C1C' },
                                { name: 'Desktop', value: 25, color: '#FFD700' }
                            ]
                        });
                    }}
                    className="h-10 px-6 bg-secondary text-white rounded-xl font-black text-[10px] uppercase tracking-widest flex items-center gap-3 hover:bg-primary hover:text-secondary transition-all"
                   >
                      <ExternalLink size={16} /> Ver Reporte Completo
                   </button>
                </div>
                <AdminChart data={data?.chartData || []} />
             </div>
          </motion.div>
        )}
        
        {activeTab === 'mensajeria' && (
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="max-w-4xl mx-auto">
             <div className="bg-white dark:bg-zinc-900 rounded-[3.5rem] p-12 border border-border/50 dark:border-white/5 shadow-2xl relative overflow-hidden">
                <div className="absolute top-0 right-0 w-64 h-64 bg-primary/5 rounded-full blur-3xl -translate-y-1/2 translate-x-1/2" />
                
                <div className="mb-12">
                   <h2 className="text-3xl font-black text-secondary dark:text-white italic tracking-tighter flex items-center gap-4"><Bell size={32} className="text-primary" /> Mensajería Global Push</h2>
                   <p className="text-muted-foreground font-medium mt-2">Envía notificaciones instantáneas a todos los usuarios que tengan instalada la App.</p>
                </div>

                <form 
                  onSubmit={async (e) => {
                    e.preventDefault();
                    setIsBroadcasting(true);
                    try {
                      const res = await fetch('/api/admin/broadcast', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify(broadcastData)
                      });
                      const json = await res.json();
                      if (json.success) {
                        showToast('📢 Notificación enviada correctamente', 'success');
                        setBroadcastData({ title: '', message: '', image: '' });
                      } else {
                        showToast(json.error || 'Error al enviar broadcast', 'error');
                      }
                    } catch (error) {
                      showToast('Error de conexión', 'error');
                    } finally {
                      setIsBroadcasting(false);
                    }
                  }}
                  className="space-y-8"
                >
                   <div className="group">
                      <label className="text-[10px] font-black uppercase tracking-[0.2em] text-secondary/30 ml-2 mb-3 block group-focus-within:text-primary transition-colors">Título de la Notificación</label>
                      <input 
                        type="text" 
                        required
                        value={broadcastData.title}
                        onChange={(e) => setBroadcastData({...broadcastData, title: e.target.value})}
                        placeholder="Ej: ¡Gran Bazar KLICUS Mañana!"
                        className="w-full h-14 px-6 rounded-xl bg-muted/20 dark:bg-white/5 border border-transparent focus:border-primary/40 outline-none font-bold text-secondary dark:text-white"
                      />
                   </div>

                   <div className="group">
                      <label className="text-[10px] font-black uppercase tracking-[0.2em] text-secondary/30 ml-2 mb-3 block group-focus-within:text-primary transition-colors">Mensaje (Cuerpo)</label>
                      <textarea 
                        required
                        rows={4}
                        value={broadcastData.message}
                        onChange={(e) => setBroadcastData({...broadcastData, message: e.target.value})}
                        placeholder="Escribe aquí el contenido que verán los usuarios..."
                        className="w-full p-6 rounded-xl bg-muted/20 dark:bg-white/5 border border-transparent focus:border-primary/40 outline-none font-bold text-secondary dark:text-white resize-none"
                      />
                   </div>

                   <div className="group">
                      <label className="text-[10px] font-black uppercase tracking-[0.2em] text-secondary/30 ml-2 mb-3 block group-focus-within:text-primary transition-colors">Media URL (Opcional)</label>
                      <input 
                        type="text" 
                        value={broadcastData.image}
                        onChange={(e) => setBroadcastData({...broadcastData, image: e.target.value})}
                        placeholder="https://tudominio.com/imagen.jpg"
                        className="w-full h-14 px-6 rounded-xl bg-muted/20 dark:bg-white/5 border border-transparent focus:border-primary/40 outline-none font-bold text-secondary dark:text-white"
                      />
                   </div>

                   <div className="pt-4">
                      <button 
                        type="submit"
                        disabled={isBroadcasting}
                        className={cn(
                          "w-full h-16 bg-secondary text-white rounded-2xl font-black uppercase text-xs tracking-[0.2em] flex items-center justify-center gap-4 hover:bg-primary hover:text-secondary transition-all shadow-2xl shadow-secondary/20 active:scale-95",
                          isBroadcasting && "opacity-50 animate-pulse"
                        )}
                      >
                        {isBroadcasting ? 'Transmitiendo...' : <><Send size={18} /> Lanzar Notificación Global</>}
                      </button>
                   </div>
                </form>

                <div className="mt-12 p-6 bg-primary/5 rounded-2xl border border-primary/10">
                   <p className="text-[10px] font-bold text-primary flex items-center gap-2 italic">
                      <Bell size={12} /> Nota: Esta mensaje llegará a todos los usuarios con la App móvil instalada que hayan aceptado la recepción de notificaciones.
                   </p>
                </div>
             </div>
          </motion.div>
        )}

        {activeTab === 'usuarios' && (
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }}>
             <div className="bg-white dark:bg-zinc-900 rounded-[3.5rem] p-12 border border-border/50 dark:border-white/5 shadow-2xl relative overflow-hidden">
                <div className="flex flex-col md:flex-row md:items-center justify-between gap-6 mb-12">
                   <div>
                      <h2 className="text-3xl font-black text-secondary dark:text-white italic tracking-tighter flex items-center gap-4"><Users size={32} className="text-primary" /> Gestión de Comunidad</h2>
                      <div className="flex gap-2 mt-2">
                        <button onClick={() => setActiveTab('usuarios')} className="text-[10px] font-black uppercase text-primary border-b-2 border-primary pb-1">Lista de Usuarios</button>
                        <button onClick={() => setActiveTab('roles')} className="text-[10px] font-black uppercase text-muted-foreground hover:text-secondary px-4 pb-1">Jerarquía de Roles</button>
                      </div>
                   </div>
                   <div className="flex items-center gap-4">
                      <button onClick={() => setShowCreateUser(true)} className="h-14 px-8 bg-secondary text-white rounded-2xl font-black text-xs uppercase tracking-widest flex items-center gap-2 hover:bg-primary hover:text-secondary transition-all shadow-xl shadow-secondary/10"><Plus size={18} /> Nuevo Usuario</button>
                      <div className="relative group"><Search className="absolute left-4 top-1/2 -translate-y-1/2 text-muted-foreground transition-colors group-focus-within:text-primary" size={18} /><input type="text" placeholder="Buscar..." className="h-14 pl-12 pr-6 bg-muted/20 dark:bg-white/5 rounded-2xl outline-none focus:ring-2 focus:ring-primary/20 border border-transparent focus:border-primary/30 transition-all font-bold text-sm w-48 md:w-64" /></div>
                   </div>
                </div>

                <div className="overflow-x-auto pb-8">
                   <table className="w-full text-left">
                      <thead>
                         <tr className="border-b border-border/40 dark:border-white/5">
                            <th className="pb-6 text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground px-4">Usuario</th>
                            <th className="pb-6 text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground px-4 text-center">Rol</th>
                            <th className="pb-6 text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground px-4 text-center">Anuncios</th>
                            <th className="pb-6 text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground px-4 text-center">Plan</th>
                            <th className="pb-6 text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground px-4 text-right">Acciones</th>
                         </tr>
                      </thead>
                      <tbody className="divide-y divide-border/20 dark:divide-white/5">
                         {users.map((user) => {
                            const roleData = roles.find(r => r.id === user.role) || { name: user.role, color: '#94A3B8' };
                            return (
                               <tr key={user.id} className="group hover:bg-muted/10 dark:hover:bg-white/5 transition-colors">
                                  <td className="py-6 px-4"><div className="flex items-center gap-4 font-black text-secondary dark:text-white italic"><div className="w-12 h-12 rounded-2xl bg-primary/20 flex items-center justify-center text-primary uppercase text-sm">{user.full_name?.charAt(0)}</div><div className="flex flex-col"><span>{user.full_name}</span><span className="text-[10px] text-muted-foreground lowercase not-italic font-medium font-sans">{user.email}</span></div></div></td>
                                  <td className="py-6 px-4 text-center"><span style={{ backgroundColor: roleData.color + '20', color: roleData.color, borderColor: roleData.color + '30' }} className="px-3 py-1 rounded-full text-[9px] font-black uppercase tracking-widest border">{roleData.name}</span></td>
                                  <td className="py-6 px-4 text-center text-sm font-black text-secondary dark:text-white">{user.ad_count}</td>
                                  <td className="py-6 px-4 text-center font-black text-[10px] text-muted-foreground">{user.plan_type || 'Gratis'}</td>
                                  <td className="py-6 px-4 text-right"><button onClick={() => setSelectedUser(user)} className="px-6 py-2.5 rounded-2xl bg-secondary text-white text-[10px] font-black uppercase tracking-widest hover:bg-primary hover:text-secondary transition-all shadow-lg active:scale-95 whitespace-nowrap">Gestionar</button></td>
                               </tr>
                            );
                         })}
                      </tbody>
                   </table>
                </div>
             </div>
          </motion.div>
        )}

        {activeTab === 'roles' && (
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }}>
             <div className="bg-white dark:bg-zinc-900 rounded-[3.5rem] p-12 border border-border/50 dark:border-white/5 shadow-2xl">
                <div className="flex flex-col md:flex-row md:items-center justify-between gap-6 mb-12">
                   <div>
                      <h2 className="text-3xl font-black text-secondary dark:text-white italic tracking-tighter flex items-center gap-4"><ShieldCheck size={32} className="text-primary" /> Jerarquía de Roles</h2>
                      <div className="flex gap-2 mt-2">
                        <button onClick={() => setActiveTab('usuarios')} className="text-[10px] font-black uppercase text-muted-foreground hover:text-secondary pb-1">Lista de Usuarios</button>
                        <button onClick={() => setActiveTab('roles')} className="text-[10px] font-black uppercase text-primary border-b-2 border-primary px-4 pb-1">Jerarquía de Roles</button>
                      </div>
                   </div>
                   <button onClick={() => { setEditingRole({ id: '', name: '', color: '#94A3B8', description: '' }); setShowRoleForm(true); }} className="h-14 px-8 bg-secondary text-white rounded-2xl font-black text-xs uppercase tracking-widest flex items-center gap-2 hover:bg-primary hover:text-secondary transition-all shadow-xl shadow-secondary/10"><PlusSquare size={18} /> Crear Nuevo Rol</button>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                   {roles.map((role) => (
                     <div key={role.id} className="bg-muted/10 dark:bg-white/5 rounded-[2.5rem] p-8 border border-border/40 dark:border-white/5 relative overflow-hidden group">
                        <div className="flex items-center justify-between mb-6">
                           <div style={{ color: role.color }} className="p-3 bg-white dark:bg-zinc-800 rounded-2xl shadow-xl"><Shield size={24} /></div>
                           <div className="flex gap-2">
                              <button onClick={() => { setEditingRole(role); setShowRoleForm(true); }} className="p-2.5 rounded-xl bg-white dark:bg-zinc-800 text-muted-foreground hover:text-primary transition-all"><Edit3 size={16} /></button>
                              {!['admin', 'anunciante', 'cliente'].includes(role.id) && (
                                <button onClick={() => handleDeleteRole(role.id)} className="p-2.5 rounded-xl bg-white dark:bg-zinc-800 text-muted-foreground hover:text-red-500 transition-all"><Trash2 size={16} /></button>
                              )}
                           </div>
                        </div>
                        <h3 className="text-xl font-black text-secondary dark:text-white italic mb-1">{role.name}</h3>
                        <p className="text-[10px] font-black uppercase tracking-widest text-muted-foreground mb-4">ID: {role.id}</p>
                        <p className="text-xs text-muted-foreground font-medium h-12 overflow-hidden">{role.description || 'Sin descripción'}</p>
                        <div className="mt-6 flex items-center justify-between">
                           <div className="flex items-center gap-2 text-[10px] font-black text-secondary dark:text-white uppercase"><Palette size={14} /> Color: <span style={{ backgroundColor: role.color }} className="w-3 h-3 rounded-full" /></div>
                           <span className="text-[10px] font-black text-muted-foreground uppercase">{users.filter(u => u.role === role.id).length} Usuarios</span>
                        </div>
                     </div>
                   ))}
                </div>
             </div>
          </motion.div>
        )}

        {activeTab === 'config' && (
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }}>
             <div className="bg-white dark:bg-zinc-900 rounded-[3rem] p-12 border border-border/50 dark:border-white/5 shadow-2xl">
                <div className="mb-12"><h2 className="text-3xl font-black text-secondary dark:text-white italic tracking-tighter flex items-center gap-4"><Settings size={32} className="text-primary" /> Configuración de Planes</h2><p className="text-muted-foreground font-medium mt-2">Reglas comerciales globales.</p></div>
                <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mb-12">
                   {plans.map((plan) => (
                     <div key={plan.plan_name} className="bg-muted/10 dark:bg-white/5 rounded-3xl p-8 border border-border/40 dark:border-white/5 space-y-8 relative overflow-hidden group">
                        <div className="flex items-center justify-between"><h3 className="text-2xl font-black italic text-secondary dark:text-white">{plan.plan_name}</h3><div className={cn("w-3 h-3 rounded-full animate-pulse shadow-lg", plan.badge_color === 'amber' ? "bg-amber-500" : "bg-blue-500")} /></div>
                        <div className="space-y-6">
                           <div><p className="text-[10px] font-black uppercase tracking-widest text-muted-foreground mb-3 flex items-center gap-2"><PlusSquare size={12} /> Máximo de Imágenes</p><div className="flex items-center gap-4"><input type="number" value={isNaN(plan.max_images) || plan.max_images === null ? '' : plan.max_images} onChange={(e) => { const val = parseInt(e.target.value); const newPlans = plans.map(p => p.plan_name === plan.plan_name ? {...p, max_images: isNaN(val) ? 0 : val} : p); setPlans(newPlans); }} className="w-full h-12 bg-white dark:bg-zinc-800 rounded-xl px-4 font-bold text-secondary dark:text-white outline-none border border-transparent focus:border-primary/40 transition-all font-sans" /></div></div>
                           <div><p className="text-[10px] font-black uppercase tracking-widest text-muted-foreground mb-3 flex items-center gap-2"><Clock size={12} /> Vigencia (Días)</p><div className="flex items-center gap-4"><input type="number" value={isNaN(plan.duration_days) || plan.duration_days === null ? '' : plan.duration_days} onChange={(e) => { const val = parseInt(e.target.value); const newPlans = plans.map(p => p.plan_name === plan.plan_name ? {...p, duration_days: isNaN(val) ? 0 : val} : p); setPlans(newPlans); }} className="w-full h-12 bg-white dark:bg-zinc-800 rounded-xl px-4 font-bold text-secondary dark:text-white outline-none border border-transparent focus:border-primary/40 transition-all font-sans" /></div></div>
                        </div>
                        <button onClick={() => handleUpdatePlan(plan)} disabled={savingPlan === plan.plan_name} className="w-full h-14 bg-secondary dark:bg-zinc-800 text-white rounded-2xl font-black text-xs uppercase tracking-widest hover:bg-primary hover:text-secondary transition-all disabled:opacity-50">{savingPlan === plan.plan_name ? 'Guardando...' : 'Guardar Cambios'}</button>
                     </div>
                   ))}
                </div>

                <div className="bg-white dark:bg-zinc-900 rounded-[3rem] p-10 border border-border/50 dark:border-white/5 shadow-xl mb-12">
                 <div className="flex items-center justify-between mb-10">
                    <div>
                       <h2 className="text-2xl font-black text-secondary dark:text-white flex items-center gap-3 italic"><CreditCard size={28} className="text-primary" /> Métodos de Pago Alternativos</h2>
                       <p className="text-muted-foreground text-xs font-medium mt-1">Configura las opciones de transferencia manual (Nequi, Bancolombia, etc.)</p>
                    </div>
                    <button onClick={addPaymentMethod} className="h-10 px-4 bg-primary/20 text-primary rounded-xl font-black text-[10px] uppercase tracking-widest hover:bg-primary hover:text-secondary transition-all flex items-center gap-2">
                       <PlusCircle size={14} /> Añadir Método
                    </button>
                 </div>

                 {isSettingsLoading ? (
                    <div className="py-20 text-center opacity-40"><div className="w-8 h-8 border-4 border-primary border-t-transparent rounded-full animate-spin mx-auto mb-4" /><p className="text-[10px] font-black uppercase tracking-widest">Cargando Métodos...</p></div>
                 ) : (
                    <form onSubmit={handleSaveSettings}>
                       <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-10">
                          {manualPayments.map((method, idx) => (
                             <div key={method.id} className="p-8 bg-muted/20 dark:bg-white/5 rounded-[2rem] border border-border/40 relative group">
                                <button type="button" onClick={() => deletePaymentMethod(method.id)} className="absolute top-6 right-6 p-2 text-red-500 opacity-0 group-hover:opacity-100 transition-all hover:bg-red-500/10 rounded-xl"><Trash2 size={16} /></button>
                                
                                <div className="grid grid-cols-2 gap-4 mb-6">
                                   <div className="space-y-1">
                                      <label className="text-[9px] font-black uppercase text-muted-foreground ml-2 text-primary">Nombre Banco / App</label>
                                      <input type="text" value={method.name} onChange={e => updatePaymentMethod(method.id, 'name', e.target.value)} className="w-full h-11 bg-white dark:bg-zinc-800 text-secondary dark:text-white rounded-xl px-4 font-bold text-xs outline-none border border-transparent focus:border-primary/40" />
                                   </div>
                                   <div className="space-y-1">
                                      <label className="text-[9px] font-black uppercase text-muted-foreground ml-2">Tipo Cuenta</label>
                                      <input type="text" value={method.type} onChange={e => updatePaymentMethod(method.id, 'type', e.target.value)} className="w-full h-11 bg-white dark:bg-zinc-800 text-secondary dark:text-white rounded-xl px-4 font-bold text-xs outline-none border border-transparent focus:border-primary/40" />
                                   </div>
                                </div>

                                <div className="space-y-4 mb-6">
                                   <div className="space-y-1">
                                      <label className="text-[9px] font-black uppercase text-muted-foreground ml-2">Número de Cuenta</label>
                                      <input type="text" value={method.number} onChange={e => updatePaymentMethod(method.id, 'number', e.target.value)} className="w-full h-11 bg-white dark:bg-zinc-800 text-secondary dark:text-white rounded-xl px-4 font-bold text-xs outline-none border border-transparent focus:border-primary/40" />
                                   </div>
                                   <div className="space-y-1">
                                      <label className="text-[9px] font-black uppercase text-muted-foreground ml-2">Nombre del Titular</label>
                                      <input type="text" value={method.owner} onChange={e => updatePaymentMethod(method.id, 'owner', e.target.value)} className="w-full h-11 bg-white dark:bg-zinc-800 text-secondary dark:text-white rounded-xl px-4 font-bold text-xs outline-none border border-transparent focus:border-primary/40" />
                                   </div>
                                </div>

                                <div className="bg-primary/5 p-4 rounded-2xl mb-6">
                                   <div className="flex items-center justify-between mb-4">
                                      <div className="flex items-center gap-2">
                                         <QrCode size={14} className="text-primary" />
                                         <span className="text-[9px] font-black uppercase tracking-widest text-secondary">Configuración QR</span>
                                      </div>
                                      <div className="flex items-center gap-2">
                                         <span className="text-[8px] font-black uppercase text-muted-foreground">{method.qr_enabled ? 'Activado' : 'Desactivado'}</span>
                                         <input type="checkbox" checked={method.qr_enabled} onChange={e => updatePaymentMethod(method.id, 'qr_enabled', e.target.checked)} className="w-4 h-4 accent-primary" />
                                      </div>
                                   </div>
                                   {method.qr_enabled && (
                                      <div className="space-y-4">
                                         <div className="space-y-1">
                                            <label className="text-[8px] font-black uppercase text-muted-foreground ml-2">Ruta de Imagen QR</label>
                                            <div className="flex gap-2">
                                               <input type="text" value={method.qr_image} onChange={e => updatePaymentMethod(method.id, 'qr_image', e.target.value)} placeholder="/assets/qr-metodo.png" className="flex-1 h-9 bg-white dark:bg-zinc-800 text-secondary dark:text-white rounded-lg px-4 font-bold text-[10px] outline-none border border-transparent focus:border-primary/40" />
                                               <button 
                                                  type="button"
                                                  onClick={() => document.getElementById(`qr-upload-${method.id}`).click()}
                                                  disabled={uploadingQR === method.id}
                                                  className="h-9 px-4 bg-secondary text-white rounded-lg font-black text-[9px] uppercase tracking-widest hover:bg-primary hover:text-secondary transition-all flex items-center gap-2"
                                               >
                                                  {uploadingQR === method.id ? 'Subiendo...' : 'Subir QR'}
                                               </button>
                                               <input 
                                                  id={`qr-upload-${method.id}`}
                                                  type="file"
                                                  accept="image/*"
                                                  className="hidden"
                                                  onChange={(e) => handleQRUpload(method.id, e.target.files[0])}
                                               />
                                            </div>
                                         </div>
                                         
                                         {method.qr_image && (
                                            <div className="w-20 h-20 bg-white dark:bg-zinc-800 rounded-xl border border-border/40 overflow-hidden flex items-center justify-center p-2">
                                               <img src={method.qr_image} alt="Preview QR" className="w-full h-full object-contain" />
                                            </div>
                                         )}
                                      </div>
                                   )}
                                </div>

                                <div className="space-y-2">
                                   <div className="flex items-center gap-2 mb-1">
                                      <MessageCircle size={14} className="text-emerald-500" />
                                      <span className="text-[9px] font-black uppercase tracking-widest text-secondary">WhatsApp de Soporte</span>
                                   </div>
                                   <input type="text" value={method.whatsapp_number} onChange={e => updatePaymentMethod(method.id, 'whatsapp_number', e.target.value)} placeholder="57313..." className="w-full h-11 bg-white dark:bg-zinc-800 text-secondary dark:text-white rounded-xl px-4 font-bold text-xs outline-none border border-transparent focus:border-primary/40" />
                                </div>
                             </div>
                          ))}
                       </div>

                       <div className="flex justify-end pt-6 border-t border-border/40">
                          <button type="submit" disabled={actionLoading === 'saving-settings'} className="h-14 px-12 bg-secondary text-white rounded-2xl font-black text-xs uppercase tracking-widest hover:bg-primary hover:text-secondary transition-all shadow-xl shadow-secondary/20">
                             {actionLoading === 'saving-settings' ? 'Guardando...' : 'Guardar Todos los Métodos'}
                          </button>
                       </div>
                    </form>
                 )}
              </div>
             </div>
          </motion.div>
        )}

        {activeTab === 'perfil' && (
          <motion.div initial={{ opacity: 0, scale: 0.98 }} animate={{ opacity: 1, scale: 1 }}>
             <div className="grid grid-cols-1 lg:grid-cols-12 gap-8">
                {/* Profile Identity Card */}
                <div className="lg:col-span-4 space-y-8">
                   <div className="bg-white dark:bg-zinc-900 rounded-[3.5rem] p-12 border border-border/50 dark:border-white/5 shadow-2xl relative overflow-hidden group">
                      <div className="absolute top-0 right-0 w-32 h-32 bg-primary/5 rounded-full blur-3xl" />
                      <div className="flex flex-col items-center relative z-10">
                         <div className="w-32 h-32 rounded-[2.5rem] bg-gradient-to-tr from-primary to-amber-300 border-4 border-white dark:border-zinc-800 shadow-2xl flex items-center justify-center text-secondary text-5xl font-black italic mb-8">
                           {session?.user?.name?.charAt(0) || 'A'}
                         </div>
                         <h2 className="text-3xl font-black text-secondary dark:text-white italic tracking-tighter mb-2 text-center">{session?.user?.name || 'Administrador Master'}</h2>
                         <span className="px-5 py-1.5 bg-secondary text-primary text-[10px] font-black uppercase tracking-[0.3em] rounded-full mb-8">Socio KLICUS</span>
                         
                         <div className="w-full space-y-4 pt-8 border-t border-border/40">
                            <div className="flex items-center justify-between text-xs font-bold">
                               <span className="text-muted-foreground uppercase tracking-widest text-[9px]">ID de Acceso</span>
                               <span className="text-secondary dark:text-white truncate max-w-[120px] font-mono opacity-50">{session?.user?.id?.slice(0,8)}...</span>
                            </div>
                            <div className="flex items-center justify-between text-xs font-bold">
                               <span className="text-muted-foreground uppercase tracking-widest text-[9px]">Estado de Cuenta</span>
                               <span className="text-emerald-500 flex items-center gap-1"><Shield size={12} fill="currentColor" /> Verificada</span>
                            </div>
                         </div>
                      </div>
                   </div>

                   <button 
                     onClick={() => signOut({ callbackUrl: '/' })}
                     className="w-full h-16 bg-red-50 dark:bg-red-500/10 text-red-600 rounded-[1.5rem] font-black uppercase text-[10px] tracking-widest flex items-center justify-center gap-3 hover:bg-red-600 hover:text-white transition-all shadow-xl shadow-red-500/5 group"
                   >
                     <LogOut size={18} className="group-hover:-translate-x-1 transition-transform" /> Cerrar Sesión Segura
                   </button>
                </div>

                {/* Profile Stats & Actions */}
                <div className="lg:col-span-8 space-y-8">
                   <div className="bg-white dark:bg-zinc-900 rounded-[3.5rem] p-12 border border-border/50 dark:border-white/5 shadow-2xl h-full">
                      <h3 className="text-2xl font-black text-secondary dark:text-white italic tracking-tighter mb-10 flex items-center gap-4">
                        <Activity size={28} className="text-primary" /> Actividad de Gestión
                      </h3>

                      <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
                         <div className="p-8 rounded-[2.5rem] bg-muted/20 dark:bg-white/5 border border-border/40 dark:border-white/5">
                            <p className="text-[10px] font-black uppercase tracking-widest text-muted-foreground mb-4">Usuarios registrados bajo tu mando</p>
                            <div className="text-5xl font-black text-secondary dark:text-white italic tracking-tighter">{users.length}</div>
                            <p className="text-xs font-medium text-muted-foreground mt-2">Crecimiento orgánico de la red.</p>
                         </div>
                         <div className="p-8 rounded-[2.5rem] bg-muted/20 dark:bg-white/5 border border-border/40 dark:border-white/5">
                            <p className="text-[10px] font-black uppercase tracking-widest text-muted-foreground mb-4">Jerarquía de privilegios activa</p>
                            <div className="text-5xl font-black text-secondary dark:text-white italic tracking-tighter">{roles.length}</div>
                            <p className="text-xs font-medium text-muted-foreground mt-2">Niveles de acceso configurados.</p>
                         </div>
                      </div>

                      <div className="mt-12 p-8 rounded-[2.5rem] bg-[#0E2244] text-white relative overflow-hidden group">
                         <div className="relative z-10">
                            <h4 className="text-xl font-black italic mb-2 tracking-tight">Atención Premium</h4>
                            <p className="text-white/60 text-sm font-medium leading-relaxed mb-6 italic">Como Socio KLICUS, tienes acceso directo al motor de soporte avanzado para optimizaciones de red.</p>
                            <button className="px-8 h-12 bg-primary text-secondary rounded-xl font-black uppercase text-[9px] tracking-widest hover:scale-[1.05] transition-all">Contactar Soporte Master</button>
                         </div>
                         <div className="absolute -bottom-10 -right-10 w-32 h-32 bg-primary/20 rounded-full blur-3xl pointer-events-none group-hover:scale-150 transition-transform" />
                      </div>
                   </div>
                </div>
             </div>
          </motion.div>
        )}
      
      {/* MODALS */}
      <AnimatePresence>
        {/* Create User Modal */}
        {showCreateUser && (
          <div className="fixed inset-0 z-[100] flex items-center justify-center p-4">
             <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }} onClick={() => setShowCreateUser(false)} className="absolute inset-0 bg-black/80 backdrop-blur-md" />
             <motion.div initial={{ opacity: 0, scale: 0.9, y: 20 }} animate={{ opacity: 1, scale: 1, y: 0 }} exit={{ opacity: 0, scale: 0.9, y: 20 }} className="relative w-full max-w-sm bg-white dark:bg-zinc-900 rounded-[3rem] p-10 shadow-2xl border border-border/50">
                <h3 className="text-2xl font-black text-secondary dark:text-white italic tracking-tighter mb-8">Nuevo Usuario</h3>
                <form onSubmit={handleCreateUser} className="space-y-4">
                   <div className="space-y-1"><label className="text-[10px] font-black uppercase text-muted-foreground ml-2">Nombre Completo</label><input required type="text" value={newUserData.full_name} onChange={e => setNewUserData({...newUserData, full_name: e.target.value})} className="w-full h-12 bg-muted/20 dark:bg-white/5 text-secondary dark:text-white rounded-2xl px-4 font-bold text-sm outline-none border border-transparent focus:border-primary/40 transition-all" /></div>
                   <div className="space-y-1"><label className="text-[10px] font-black uppercase text-muted-foreground ml-2">Email</label><input required type="email" value={newUserData.email} onChange={e => setNewUserData({...newUserData, email: e.target.value})} className="w-full h-12 bg-muted/20 dark:bg-white/5 text-secondary dark:text-white rounded-2xl px-4 font-bold text-sm outline-none border border-transparent focus:border-primary/40 transition-all" /></div>
                   <div className="space-y-1"><label className="text-[10px] font-black uppercase text-muted-foreground ml-2">Contraseña</label><input required type="password" value={newUserData.password} onChange={e => setNewUserData({...newUserData, password: e.target.value})} className="w-full h-12 bg-muted/20 dark:bg-white/5 text-secondary dark:text-white rounded-2xl px-4 font-bold text-sm outline-none border border-transparent focus:border-primary/40 transition-all" /></div>
                   <div className="space-y-1">
                      <label className="text-[10px] font-black uppercase text-muted-foreground ml-2">Rol Inicial</label>
                      <select value={newUserData.role} onChange={e => setNewUserData({...newUserData, role: e.target.value})} className="w-full h-12 bg-muted/20 dark:bg-white/5 text-secondary dark:text-white rounded-2xl px-4 font-bold text-sm outline-none border border-transparent focus:border-primary/40 transition-all appearance-none">
                         {roles.map(r => <option key={r.id} value={r.id} className="text-secondary">{r.name}</option>)}
                      </select>
                   </div>
                   <button type="submit" disabled={actionLoading === 'creating'} className="w-full h-14 bg-secondary text-white rounded-2xl font-black text-xs uppercase tracking-widest hover:bg-primary hover:text-secondary transition-all mt-4">{actionLoading === 'creating' ? 'Creando...' : 'Crear Usuario'}</button>
                </form>
             </motion.div>
          </div>
        )}

        {/* Role Form Modal */}
        {showRoleForm && (
          <div className="fixed inset-0 z-[100] flex items-center justify-center p-4">
             <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }} onClick={() => setShowRoleForm(false)} className="absolute inset-0 bg-black/80 backdrop-blur-md" />
             <motion.div initial={{ opacity: 0, scale: 0.9, y: 20 }} animate={{ opacity: 1, scale: 1, y: 0 }} exit={{ opacity: 0, scale: 0.9, y: 20 }} className="relative w-full max-w-sm bg-white dark:bg-zinc-900 rounded-[3rem] p-10 shadow-2xl border border-border/50">
                <h3 className="text-2xl font-black text-secondary dark:text-white italic tracking-tighter mb-8">Definir Rol</h3>
                <form onSubmit={handleSaveRole} className="space-y-4">
                   <div className="space-y-1"><label className="text-[10px] font-black uppercase text-muted-foreground ml-2">ID Único (Minúsculas)</label><input required type="text" disabled={!!editingRole.created_at} value={editingRole.id} onChange={e => setEditingRole({...editingRole, id: e.target.value.toLowerCase().replace(/\s+/g,'_')})} className="w-full h-12 bg-muted/20 dark:bg-white/5 text-secondary dark:text-white rounded-2xl px-4 font-bold text-sm outline-none border border-transparent focus:border-primary/40 transition-all disabled:opacity-50" /></div>
                   <div className="space-y-1"><label className="text-[10px] font-black uppercase text-muted-foreground ml-2">Nombre Visual</label><input required type="text" value={editingRole.name} onChange={e => setEditingRole({...editingRole, name: e.target.value})} className="w-full h-12 bg-muted/20 dark:bg-white/5 text-secondary dark:text-white rounded-2xl px-4 font-bold text-sm outline-none border border-transparent focus:border-primary/40 transition-all" /></div>
                   <div className="space-y-1"><label className="text-[10px] font-black uppercase text-muted-foreground ml-2">Color Representativo</label><input type="color" value={editingRole.color} onChange={e => setEditingRole({...editingRole, color: e.target.value})} className="w-full h-12 bg-muted/20 dark:bg-white/5 text-secondary dark:text-white rounded-2xl px-2 outline-none border border-transparent focus:border-primary/40 transition-all cursor-pointer" /></div>
                   <div className="space-y-1"><label className="text-[10px] font-black uppercase text-muted-foreground ml-2">Descripción</label><textarea value={editingRole.description} onChange={e => setEditingRole({...editingRole, description: e.target.value})} className="w-full h-24 bg-muted/20 dark:bg-white/5 text-secondary dark:text-white rounded-2xl p-4 font-medium text-xs outline-none border border-transparent focus:border-primary/40 transition-all resize-none" /></div>
                   <button type="submit" className="w-full h-14 bg-secondary text-white rounded-2xl font-black text-xs uppercase tracking-widest hover:bg-primary hover:text-secondary transition-all mt-4">Guardar Configuración</button>
                </form>
             </motion.div>
          </div>
        )}

        {/* User Manage Modal (Dynamic Roles) */}
        {selectedUser && (
          <div className="fixed inset-0 z-[100] flex items-center justify-center p-4">
             <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }} onClick={() => setSelectedUser(null)} className="absolute inset-0 bg-black/80 backdrop-blur-md" />
             <motion.div initial={{ opacity: 0, scale: 0.9, y: 20 }} animate={{ opacity: 1, scale: 1, y: 0 }} exit={{ opacity: 0, scale: 0.9, y: 20 }} className="relative w-full max-w-sm bg-white dark:bg-zinc-900 rounded-[3rem] p-10 shadow-2xl border border-border/50">
                <div className="flex flex-col items-center mb-8">
                   <div className="w-16 h-16 rounded-[1.5rem] bg-primary/20 flex items-center justify-center text-primary text-2xl font-black uppercase mb-4">{selectedUser.full_name?.charAt(0)}</div>
                   <h3 className="text-xl font-black text-secondary dark:text-white italic">{selectedUser.full_name}</h3>
                   <span className="text-[10px] font-black uppercase text-muted-foreground">{selectedUser.email}</span>
                </div>
                <div className="space-y-3">
                   <label className="text-[10px] font-black uppercase text-muted-foreground ml-2">Asignar Nuevo Rol</label>
                   <div className="grid grid-cols-1 gap-2">
                      {roles.map(r => (
                        <button key={r.id} onClick={() => { handleUserAction(selectedUser.id, 'update_role', r.id); setSelectedUser(null); }} className={cn("w-full py-3.5 px-6 rounded-2xl text-[10px] font-black uppercase tracking-widest border transition-all flex items-center justify-between group", selectedUser.role === r.id ? "bg-primary border-primary text-secondary" : "bg-muted/10 border-transparent text-muted-foreground hover:border-primary hover:text-primary")}>
                           {r.name}
                           {selectedUser.role === r.id ? <ShieldCheck size={14} /> : <div className="w-2 h-2 rounded-full" style={{ backgroundColor: r.color }} />}
                        </button>
                      ))}
                   </div>
                   <div className="h-px bg-border/40 my-4" />
                   <button onClick={() => { handleUserAction(selectedUser.id, 'delete'); setSelectedUser(null); }} className="w-full py-4 rounded-2xl text-red-500 font-black uppercase text-[10px] tracking-widest hover:bg-red-500 hover:text-white transition-all border border-red-500/20"><Trash2 size={16} className="inline mr-2" /> Eliminar Usuario</button>
                   <button onClick={() => setSelectedUser(null)} className="w-full py-4 text-muted-foreground font-black uppercase text-[10px]">Cerrar</button>
                </div>
             </motion.div>
          </div>
        )}
        {/* Ad Detail Modal */}
        {selectedAd && (
          <div className="fixed inset-0 z-[101] flex items-center justify-center p-4">
             <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }} onClick={() => setSelectedAd(null)} className="absolute inset-0 bg-black/90 backdrop-blur-xl" />
             <motion.div initial={{ opacity: 0, scale: 0.9, y: 30 }} animate={{ opacity: 1, scale: 1, y: 0 }} exit={{ opacity: 0, scale: 0.9, y: 30 }} className="relative w-full max-w-2xl bg-white dark:bg-zinc-900 rounded-[3rem] overflow-hidden shadow-2xl border border-border/50">
                <div className="flex flex-col md:flex-row h-full max-h-[85vh] overflow-y-auto">
                   {/* Left side: Images (or placeholder) */}
                   <div className="w-full md:w-1/2 bg-muted/20 dark:bg-white/5 border-r border-border/20">
                      {selectedAd.image_urls && selectedAd.image_urls.length > 0 ? (
                         <div className="grid grid-cols-1 gap-1 p-2">
                           <img src={selectedAd.image_urls[0]} alt={selectedAd.title} className="w-full h-auto aspect-square object-cover rounded-3xl" />
                           {selectedAd.image_urls.length > 1 && (
                             <div className="grid grid-cols-2 gap-1 mt-1">
                               {selectedAd.image_urls.slice(1, 4).map((img, i) => (
                                 <img key={i} src={img} alt="" className="w-full h-24 object-cover rounded-2xl" />
                               ))}
                             </div>
                           )}
                         </div>
                      ) : (
                         <div className="flex flex-col items-center justify-center h-full min-h-[300px] text-muted-foreground opacity-30 italic">
                            <FileText size={64} className="mb-4" />
                            <p className="text-xs uppercase font-black tracking-widest">Sin Imágenes</p>
                         </div>
                      )}
                   </div>
                   
                   {/* Right side: Info */}
                   <div className="w-full md:w-1/2 p-10 flex flex-col">
                      <div className="flex items-center justify-between mb-8">
                         <span className="px-5 py-1.5 bg-primary/20 text-primary border border-primary/30 rounded-full text-[9px] font-black uppercase tracking-widest">{selectedAd.plan_type || 'Basic'}</span>
                         <button onClick={() => setSelectedAd(null)} className="p-2.5 rounded-2xl hover:bg-muted/30 text-muted-foreground transition-all"><X size={20} /></button>
                      </div>
                      
                      <p className="text-[10px] font-black uppercase tracking-widest text-primary mb-2">Solicitante: <span className="text-secondary dark:text-white italic">{selectedAd.owner_name}</span></p>
                      <h3 className="text-3xl font-black text-secondary dark:text-white italic tracking-tighter mb-4 leading-tight">{selectedAd.title}</h3>
                      
                      <div className="space-y-4 mb-8">
                         <div className="flex items-center gap-3 text-muted-foreground text-xs font-medium">
                            <Activity size={16} className="text-emerald-500" />
                            <span>Presupuesto: <strong className="text-secondary dark:text-white font-black">{selectedAd.price_range || 'No especificado'}</strong></span>
                         </div>
                         <div className="flex items-center gap-3 text-muted-foreground text-xs font-medium">
                            <Filter size={16} className="text-blue-500" />
                            <span>Ubicación: <strong className="text-secondary dark:text-white font-black">{selectedAd.location}</strong></span>
                         </div>
                      </div>

                      <div className="bg-muted/10 dark:bg-white/5 rounded-2xl p-6 mb-10 overflow-auto max-h-[150px]">
                         <p className="text-xs text-muted-foreground font-medium italic leading-relaxed">{selectedAd.description}</p>
                      </div>

                      <div className="flex gap-4 mt-auto">
                         <button 
                           onClick={() => { handleAdAction(selectedAd.id, 'active'); setSelectedAd(null); }} 
                           className="flex-1 h-16 bg-emerald-500 text-white rounded-2xl font-black text-xs uppercase tracking-widest hover:bg-emerald-600 transition-all flex items-center justify-center gap-2 shadow-lg shadow-emerald-500/20"
                         >
                            <Check size={18} /> Aprobar
                         </button>
                         <button 
                           onClick={() => { handleAdAction(selectedAd.id, 'rejected'); setSelectedAd(null); }} 
                           className="h-16 w-16 bg-red-500 text-white rounded-2xl font-black hover:bg-red-600 transition-all flex items-center justify-center shadow-lg shadow-red-500/20"
                         >
                            <X size={20} />
                         </button>
                      </div>
                   </div>
                </div>
             </motion.div>
          </div>
        )}
        
        {/* Ad Detail Analytics Modal */}
        {selectedAdAnalytics && (
              <div className="fixed inset-0 z-[100] flex items-center justify-center p-4 md:p-8 text-secondary dark:text-white">
                 <motion.div 
                    initial={{ opacity: 0 }} 
                    animate={{ opacity: 1 }} 
                    exit={{ opacity: 0 }}
                    onClick={() => setSelectedAdAnalytics(null)}
                    className="absolute inset-0 bg-secondary/80 backdrop-blur-md" 
                 />
                 <motion.div 
                    initial={{ opacity: 0, scale: 0.9, y: 20 }} 
                    animate={{ opacity: 1, scale: 1, y: 0 }}
                    exit={{ opacity: 0, scale: 0.9, y: 20 }}
                    className="relative w-full max-w-6xl max-h-[90vh] bg-[#F8F9FA] dark:bg-zinc-950 rounded-[3.5rem] shadow-2xl overflow-hidden flex flex-col"
                 >
                    <div className="p-8 md:p-12 overflow-y-auto custom-scrollbar">
                       <button 
                          onClick={() => setSelectedAdAnalytics(null)}
                          className="absolute top-8 right-8 w-12 h-12 bg-white dark:bg-zinc-900 rounded-full flex items-center justify-center text-secondary dark:text-white hover:bg-primary hover:text-secondary transition-all z-10 shadow-lg"
                       >
                          <X size={20} />
                       </button>
                       
                       {isAnalyticsLoading ? (
                          <div className="py-40 text-center">
                             <div className="w-12 h-12 border-4 border-primary border-t-transparent rounded-full animate-spin mx-auto mb-6" />
                             <p className="text-[10px] font-black uppercase tracking-[0.3em] text-secondary/30 italic">Consultando Inteligencia de Datos...</p>
                          </div>
                       ) : (
                          <AnalyticsDashboard 
                            data={selectedAdAnalytics} 
                            title="Métricas de Pauta Seleccionada" 
                            onDateChange={(start, end) => fetchAdAnalytics(selectedAdAnalytics.id, start, end)}
                          />
                       )}
                    </div>
                 </motion.div>
              </div>
           )}
        </AnimatePresence>
      </main>

      {/* --- PREMIUM ADMINISTRATIVE MODALS --- */}
      <AnimatePresence>
        {/* 1. Rejection Reason Modal */}
        {rejectionModal.isOpen && (
          <div className="fixed inset-0 z-[120] flex items-center justify-center p-6 text-secondary dark:text-white">
            <motion.div 
              initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}
              onClick={() => setRejectionModal({ ...rejectionModal, isOpen: false })}
              className="absolute inset-0 bg-secondary/80 backdrop-blur-xl"
            />
            <motion.div 
              initial={{ opacity: 0, scale: 0.9, y: 20 }}
              animate={{ opacity: 1, scale: 1, y: 0 }}
              exit={{ opacity: 0, scale: 0.9, y: 20 }}
              className="relative bg-white dark:bg-zinc-900 rounded-[3rem] p-10 max-w-lg w-full shadow-2xl border border-border dark:border-white/5 overflow-hidden"
            >
              <div className="mb-8 flex items-center gap-4">
                <div className="w-12 h-12 rounded-2xl bg-red-100 dark:bg-red-500/10 text-red-600 flex items-center justify-center shadow-inner">
                  <X size={24} />
                </div>
                <div>
                  <h3 className="text-xl font-black uppercase tracking-tighter italic">Rechazar Pauta</h3>
                  <p className="text-[10px] font-black text-muted-foreground uppercase tracking-widest italic">Informa el motivo al anunciante</p>
                </div>
              </div>

              <div className="space-y-6">
                <textarea 
                  value={rejectionModal.reason}
                  onChange={(e) => setRejectionModal({ ...rejectionModal, reason: e.target.value })}
                  placeholder="Ej: La imagen principal no cumple con los términos de calidad..."
                  className="w-full h-40 bg-zinc-50 dark:bg-white/5 border border-border dark:border-white/10 rounded-[2rem] p-6 text-sm font-medium outline-none focus:border-red-500 transition-all resize-none shadow-inner"
                />

                <div className="flex gap-4">
                  <button 
                    onClick={() => setRejectionModal({ ...rejectionModal, isOpen: false })}
                    className="flex-1 h-14 rounded-2xl border border-border dark:border-white/10 text-[10px] font-black uppercase tracking-widest text-muted-foreground hover:bg-zinc-100 dark:hover:bg-white/5 transition-all"
                  >
                    Cancelar
                  </button>
                  <button 
                    onClick={() => {
                      if (!rejectionModal.reason.trim()) {
                        showToast('Debes ingresar un motivo', 'error');
                        return;
                      }
                      handleAdAction(rejectionModal.adId, 'rejected', rejectionModal.reason);
                    }}
                    className="flex-1 h-14 rounded-2xl bg-red-600 text-white text-[10px] font-black uppercase tracking-widest shadow-xl shadow-red-600/20 hover:scale-105 active:scale-95 transition-all"
                  >
                    Confirmar Rechazo
                  </button>
                </div>
              </div>
            </motion.div>
          </div>
        )}

        {/* 2. Universal Confirmation Modal (Deletions etc) */}
        {confirmModal.isOpen && (
          <div className="fixed inset-0 z-[120] flex items-center justify-center p-6 text-secondary dark:text-white">
            <motion.div 
              initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}
              onClick={() => setConfirmModal({ ...confirmModal, isOpen: false })}
              className="absolute inset-0 bg-secondary/80 backdrop-blur-xl"
            />
            <motion.div 
              initial={{ opacity: 0, scale: 0.9, y: 20 }}
              animate={{ opacity: 1, scale: 1, y: 0 }}
              exit={{ opacity: 0, scale: 0.9, y: 20 }}
              className="relative bg-white dark:bg-zinc-900 rounded-[3rem] p-10 max-w-md w-full shadow-2xl border border-border dark:border-white/5 text-center"
            >
              <div className="w-16 h-16 rounded-[2rem] bg-amber-100 dark:bg-amber-500/10 text-amber-600 flex items-center justify-center mx-auto mb-6 shadow-inner animate-pulse">
                <Trash2 size={32} />
              </div>
              <h3 className="text-2xl font-black uppercase tracking-tighter italic mb-4">{confirmModal.title}</h3>
              <p className="text-sm font-medium text-muted-foreground mb-10 leading-relaxed italic">{confirmModal.message}</p>

              <div className="flex gap-4">
                <button 
                  onClick={() => setConfirmModal({ ...confirmModal, isOpen: false })}
                  className="flex-1 h-14 rounded-2xl border border-border dark:border-white/10 text-[10px] font-black uppercase tracking-widest text-muted-foreground hover:bg-zinc-100 dark:hover:bg-white/5 transition-all"
                >
                  Regresar
                </button>
                <button 
                  onClick={confirmModal.onConfirm}
                  className="flex-1 h-14 rounded-2xl bg-red-600 text-white text-[10px] font-black uppercase tracking-widest shadow-xl shadow-red-600/20 hover:scale-105 active:scale-95 transition-all"
                >
                  Efectuar
                </button>
              </div>
            </motion.div>
          </div>
        )}
      </AnimatePresence>
    </div>
  );
}
