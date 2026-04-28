'use client';

import { useState } from 'react';
import { Check, X } from 'lucide-react';

export default function AdActionButtons({ adId, adTitle }) {
  const [loading, setLoading] = useState(false);
  const [done, setDone] = useState(false);
  const [error, setError] = useState(null);

  const handleAction = async (status) => {
    let reason = null;
    if (status === 'rejected') {
      reason = window.prompt(`Motivo de rechazo para "${adTitle}":`);
      if (reason === null) return; // canceló el prompt
    }

    setLoading(true);
    setError(null);
    try {
      const res = await fetch('/api/admin/approve-ad', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ adId, status, reason }),
      });
      const data = await res.json();
      if (data.success) {
        setDone(status);
      } else {
        setError(data.error || 'Error desconocido');
      }
    } catch {
      setError('Error de conexión');
    }
    setLoading(false);
  };

  if (done === 'active') {
    return <span className="px-6 py-3 rounded-2xl bg-emerald-100 text-emerald-700 font-black text-sm">Activado</span>;
  }
  if (done === 'rejected') {
    return <span className="px-6 py-3 rounded-2xl bg-red-100 text-red-600 font-black text-sm">Rechazado</span>;
  }

  return (
    <div className="flex items-center gap-3">
      {error && <span className="text-xs text-red-500 font-bold">{error}</span>}
      <button
        disabled={loading}
        onClick={() => handleAction('rejected')}
        className="h-12 w-12 flex items-center justify-center rounded-2xl bg-red-50 text-red-600 hover:bg-red-100 transition-colors shadow-sm disabled:opacity-50"
        title="Rechazar"
      >
        <X size={20} strokeWidth={3} />
      </button>
      <button
        disabled={loading}
        onClick={() => handleAction('active')}
        className="h-12 px-8 flex items-center justify-center rounded-2xl bg-emerald-500 text-white font-black shadow-lg shadow-emerald-500/20 hover:opacity-90 transition-all gap-2 disabled:opacity-50"
        title="Aprobar"
      >
        <Check size={20} strokeWidth={3} /> {loading ? 'Procesando...' : 'Activar Pauta'}
      </button>
    </div>
  );
}
