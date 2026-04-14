/**
 * KLICUS Ad Creation Form
 * Multi-step client component for advertisement submission.
 * Handles: Basic Data -> Tier Selection & Tax -> Confirmation.
 */

'use client';

import { useState } from 'react';
import { Camera, Send, ShieldCheck, CheckCircle2 } from 'lucide-react';

export default function AdCreationForm({ categories }) {
  // Navigation step state
  const [step, setStep] = useState(1);
  
  // Centralized form storage
  const [formData, setFormData] = useState({
    title: '',
    description: '',
    categoryId: '',
    location: '',
    priceRange: '',
    priority: 'basic',
    includeIVA: false
  });
  
  // File storage for images (max 5)
  const [images, setImages] = useState([]);
  const [loading, setLoading] = useState(false);

  /**
   * Handles local image selection and validation.
   */
  const handleImageChange = (e) => {
    const files = Array.from(e.target.files);
    if (files.length + images.length > 5) {
      alert('Máximo 5 imágenes por anuncio');
      return;
    }
    setImages([...images, ...files]);
  };

  /**
   * Submits form data and images to the API endpoint.
   */
  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    const data = new FormData();
    Object.keys(formData).forEach(key => data.append(key, formData[key]));
    images.forEach(img => data.append('images', img));

    const res = await fetch('/api/pautas/nueva', {
      method: 'POST',
      body: data
    });

    const result = await res.json();

    if (result.success) {
      setStep(3); // Success step
    } else {
      alert('Error al crear anuncio');
    }
    setLoading(false);
  };

  return (
    <div className="glass" style={{
      maxWidth: '800px',
      margin: '0 auto',
      padding: '2.5rem',
      borderRadius: 'var(--radius-lg)'
    }}>
      {/* Step 1: Basic Information */}
      {step === 1 && (
        <form onSubmit={() => setStep(2)} className="fade-in">
          <h2 style={{ marginBottom: '1.5rem' }}>Información del Anuncio</h2>
          <div style={{ display: 'grid', gap: '1.5rem' }}>
            <div>
              <label style={{ display: 'block', marginBottom: '0.5rem', fontWeight: '600' }}>Título de la Pauta</label>
              <input 
                type="text" 
                required 
                className="input-field" 
                value={formData.title}
                onChange={(e) => setFormData({...formData, title: e.target.value})}
                placeholder="Ej: Odontología Especializada" 
              />
            </div>
            
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem' }}>
              <div>
                <label style={{ display: 'block', marginBottom: '0.5rem', fontWeight: '600' }}>Categoría</label>
                <select 
                  required 
                  className="input-field"
                  value={formData.categoryId}
                  onChange={(e) => setFormData({...formData, categoryId: e.target.value})}
                >
                  <option value="">Seleccionar...</option>
                  {categories.map(cat => <option key={cat.id} value={cat.id}>{cat.name}</option>)}
                </select>
              </div>
              <div>
                <label style={{ display: 'block', marginBottom: '0.5rem', fontWeight: '600' }}>Ubicación (Ciudad/Sector)</label>
                <input 
                  type="text" 
                  required 
                  className="input-field" 
                  value={formData.location}
                  onChange={(e) => setFormData({...formData, location: e.target.value})}
                  placeholder="Ej: Bogotá, Chapinero" 
                />
              </div>
            </div>

            <div>
              <label style={{ display: 'block', marginBottom: '0.5rem', fontWeight: '600' }}>Descripción</label>
              <textarea 
                rows="4" 
                required 
                className="input-field" 
                value={formData.description}
                onChange={(e) => setFormData({...formData, description: e.target.value})}
                placeholder="Cuéntanos más sobre tus servicios..."
              ></textarea>
            </div>

            <div>
              <label style={{ display: 'block', marginBottom: '0.5rem', fontWeight: '600' }}>Fotos (Máx 5 - Formato optimizado WebP)</label>
              <div style={{
                border: '2px dashed var(--border)',
                borderRadius: 'var(--radius)',
                padding: '2rem',
                textAlign: 'center',
                cursor: 'pointer',
                position: 'relative'
              }}>
                <input 
                  type="file" 
                  multiple 
                  accept="image/*" 
                  onChange={handleImageChange}
                  style={{ position: 'absolute', inset: 0, opacity: 0, cursor: 'pointer' }}
                />
                <Camera size={32} color="var(--muted-foreground)" style={{ marginBottom: '1rem' }} />
                <p style={{ color: 'var(--muted-foreground)' }}>Haz clic para subir o arrastra tus imágenes</p>
                {images.length > 0 && <p style={{ color: 'var(--primary)', fontWeight: '700', marginTop: '0.5rem' }}>{images.length} archivos seleccionados</p>}
              </div>
            </div>

            <button type="button" onClick={() => setStep(2)} className="btn-primary" style={{ alignSelf: 'flex-end' }}>
              Siguiente Paso
            </button>
          </div>
        </form>
      )}

      {/* Step 2: Tier Selection & Payments */}
      {step === 2 && (
        <div className="fade-in">
          <h2 style={{ marginBottom: '1.5rem' }}>Selecciona tu Nivel de Prioridad</h2>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', gap: '1.5rem', marginBottom: '2rem' }}>
            {/* Tier Selection Cards */}
            {['basic', 'pro', 'diamond'].map((tier) => (
              <div 
                key={tier}
                onClick={() => setFormData({...formData, priority: tier})}
                style={{
                  padding: '1.5rem',
                  borderRadius: 'var(--radius-lg)',
                  border: formData.priority === tier ? '2px solid var(--primary)' : '1px solid var(--border)',
                  cursor: 'pointer',
                  background: formData.priority === tier ? 'var(--muted)' : 'var(--card)',
                  textAlign: 'center'
                }}
              >
                <h3 style={{ textTransform: 'uppercase', fontSize: '1rem' }}>{tier}</h3>
                <p style={{ fontSize: '1.5rem', fontWeight: '800', margin: '1rem 0' }}>
                  {tier === 'basic' ? 'Gratis' : tier === 'pro' ? '$49k' : '$99k'}
                </p>
                <ul style={{ padding: 0, listStyle: 'none', fontSize: '0.8rem', textAlign: 'left', color: 'var(--muted-foreground)' }}>
                  <li>✓ Fotos: {tier === 'basic' ? '1' : '5'}</li>
                  <li>✓ Visibilidad: {tier === 'basic' ? 'Baja' : tier === 'pro' ? 'Media' : 'Máxima'}</li>
                </ul>
              </div>
            ))}
          </div>

          <div style={{ 
            background: 'var(--muted)', 
            padding: '1rem', 
            borderRadius: 'var(--radius)', 
            marginBottom: '2rem',
            display: 'flex',
            alignItems: 'center',
            gap: '1rem'
          }}>
            <input 
              type="checkbox" 
              id="iva" 
              checked={formData.includeIVA}
              onChange={(e) => setFormData({...formData, includeIVA: e.target.checked})}
              style={{ width: '20px', height: '20px' }}
            />
            <label htmlFor="iva" style={{ fontWeight: '600' }}>Incluir IVA (19%) en el cobro</label>
          </div>

          <div style={{ display: 'flex', justifyContent: 'space-between' }}>
            <button type="button" onClick={() => setStep(1)} className="btn-secondary">Atrás</button>
            <button onClick={handleSubmit} className="btn-primary" disabled={loading}>
              {loading ? 'Procesando...' : 'Finalizar y Pagar'} <Send size={18} />
            </button>
          </div>
        </div>
      )}

      {/* Step 3: Success Confirmation */}
      {step === 3 && (
        <div style={{ textAlign: 'center', padding: '3rem 0' }} className="fade-in">
          <CheckCircle2 size={80} color="#10b981" style={{ marginBottom: '1.5rem' }} />
          <h1>¡Solicitud Enviada!</h1>
          <p style={{ color: 'var(--muted-foreground)', marginBottom: '2rem' }}>
            Tu pauta ha sido creada exitosamente. Ahora está en revisión por nuestro equipo administrativo. 
            Te notificaremos cuando esté activa.
          </p>
          <button onClick={() => window.location.href = '/'} className="btn-primary">
            Ir al Inicio
          </button>
        </div>
      )}

      <style jsx>{`
        .input-field {
          width: 100%;
          padding: 0.75rem 1rem;
          border-radius: var(--radius);
          border: 1px solid var(--border);
          background: var(--background);
          font-size: 1rem;
        }
        .btn-secondary {
          padding: 0.75rem 1.5rem;
          border-radius: var(--radius);
          border: 1px solid var(--border);
          font-weight: 600;
        }
      `}</style>
    </div>
  );
}
