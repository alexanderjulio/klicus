import { Users, FileText, CreditCard, Activity, TrendingUp } from 'lucide-react';

export default function AdminDashboard() {
  const stats = [
    { label: 'Usuarios Activos', value: '1,240', icon: <Users size={20} />, trend: '+12%' },
    { label: 'Pautas Vigentes', value: '450', icon: <FileText size={20} />, trend: '+5%' },
    { label: 'Recaudado (Mes)', value: '$12.5M', icon: <CreditCard size={20} />, trend: '+18%' },
    { label: 'Clics Totales', value: '8.2k', icon: <Activity size={20} />, trend: '+25%' },
  ];

  return (
    <div className="admin-container" style={{ padding: '2rem' }}>
      <header style={{ marginBottom: '2.5rem' }}>
        <h1 style={{ fontSize: '2rem' }}>Panel de Administración</h1>
        <p style={{ color: 'var(--muted-foreground)' }}>Vista general de métricas y rendimiento de KLICUS.</p>
      </header>

      <div style={{ 
        display: 'grid', 
        gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))', 
        gap: '1.5rem',
        marginBottom: '3rem'
      }}>
        {stats.map((stat, i) => (
          <div key={i} className="glass" style={{
            padding: '1.5rem',
            borderRadius: 'var(--radius-lg)',
            display: 'flex',
            flexDirection: 'column',
            gap: '1rem'
          }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', color: 'var(--muted-foreground)' }}>
              {stat.icon}
              <span style={{ fontSize: '0.875rem', color: 'green', fontWeight: 'bold' }}>{stat.trend}</span>
            </div>
            <div>
              <div style={{ fontSize: '1.75rem', fontWeight: '800' }}>{stat.value}</div>
              <div style={{ fontSize: '0.875rem', color: 'var(--muted-foreground)' }}>{stat.label}</div>
            </div>
          </div>
        ))}
      </div>

      <div className="glass" style={{
        padding: '2rem',
        borderRadius: 'var(--radius-lg)',
        minHeight: '300px'
      }}>
        <h2 style={{ marginBottom: '1.5rem', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
          <TrendingUp size={24} color="var(--primary)" /> Rendimiento Semanal
        </h2>
        <div style={{ 
          height: '250px', 
          background: 'var(--muted)', 
          borderRadius: 'var(--radius)', 
          display: 'flex', 
          alignItems: 'center', 
          justifyContent: 'center',
          color: 'var(--muted-foreground)'
        }}>
          [Gráfico de Recharts cargando aquí...]
        </div>
      </div>
    </div>
  );
}
