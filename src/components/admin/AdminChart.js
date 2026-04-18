'use client';

import { 
  AreaChart, 
  Area, 
  XAxis, 
  YAxis, 
  CartesianGrid, 
  Tooltip, 
  ResponsiveContainer 
} from 'recharts';

export default function AdminChart({ data }) {
  return (
    <div className="w-full h-[350px] mt-6">
      <ResponsiveContainer width="100%" height="100%">
        <AreaChart
          data={data}
          margin={{ top: 10, right: 10, left: -20, bottom: 0 }}
        >
          <defs>
            <linearGradient id="colorAds" x1="0" y1="0" x2="0" y2="1">
              <stop offset="5%" stopColor="#E2E000" stopOpacity={0.3} />
              <stop offset="95%" stopColor="#E2E000" stopOpacity={0} />
            </linearGradient>
            <linearGradient id="colorUsers" x1="0" y1="0" x2="0" y2="1">
              <stop offset="5%" stopColor="#0ea5e9" stopOpacity={0.2} />
              <stop offset="95%" stopColor="#0ea5e9" stopOpacity={0} />
            </linearGradient>
            <linearGradient id="colorTraffic" x1="0" y1="0" x2="0" y2="1">
              <stop offset="5%" stopColor="#10b981" stopOpacity={0.2} />
              <stop offset="95%" stopColor="#10b981" stopOpacity={0} />
            </linearGradient>
          </defs>
          <CartesianGrid 
            strokeDasharray="3 3" 
            vertical={false} 
            stroke="currentColor" 
            className="text-border/30" 
          />
          <XAxis 
            dataKey="date" 
            axisLine={false}
            tickLine={false}
            tick={{ fontSize: 10, fontWeight: 'bold' }}
            dy={10}
            className="text-muted-foreground"
          />
          <YAxis 
            axisLine={false}
            tickLine={false}
            tick={{ fontSize: 10, fontWeight: 'bold' }}
            className="text-muted-foreground"
          />
          <Tooltip 
            contentStyle={{ 
              backgroundColor: 'rgba(255, 255, 255, 0.9)', 
              borderRadius: '20px', 
              border: 'none',
              boxShadow: '0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04)',
              backdropFilter: 'blur(10px)',
              padding: '16px'
            }}
            itemStyle={{ fontWeight: 'bold', fontSize: '11px', textTransform: 'uppercase', letterSpacing: '0.05em' }}
            cursor={{ stroke: '#E2E000', strokeWidth: 2, strokeDasharray: '4 4' }}
          />
          <Area
            type="monotone"
            dataKey="usuarios"
            name="Nuevos Usuarios"
            stroke="#0ea5e9"
            strokeWidth={3}
            fillOpacity={1}
            fill="url(#colorUsers)"
            animationDuration={1500}
          />
          <Area
            type="monotone"
            dataKey="anuncios"
            name="Anuncios Publicados"
            stroke="#E2E000"
            strokeWidth={4}
            fillOpacity={1}
            fill="url(#colorAds)"
            animationDuration={1500}
          />
          <Area
            type="monotone"
            dataKey="vistas"
            name="Vistas Totales"
            stroke="#94a3b8"
            strokeWidth={2}
            fill="transparent"
            animationDuration={1500}
          />
          <Area
            type="monotone"
            dataKey="click"
            name="Clicks"
            stroke="#1c1c1c"
            strokeWidth={2}
            fill="transparent"
            animationDuration={1500}
          />
          <Area
            type="monotone"
            dataKey="contactos"
            name="Contactos (WA)"
            stroke="#10b981"
            strokeWidth={4}
            fillOpacity={1}
            fill="url(#colorTraffic)"
            animationDuration={1500}
          />

        </AreaChart>
      </ResponsiveContainer>
    </div>
  );
}
