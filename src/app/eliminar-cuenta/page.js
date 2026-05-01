import { Trash2, ShieldCheck, Clock, AlertTriangle, ChevronRight, Smartphone, Mail, CheckCircle2 } from 'lucide-react';
import Link from 'next/link';

export const metadata = {
  title: "Eliminación de cuenta | KLICUS App",
  description: "Cómo solicitar la eliminación de tu cuenta en la app KLICUS, qué datos se eliminan, cuáles se conservan y por cuánto tiempo.",
};

export default function EliminarCuentaPage() {
  return (
    <div className="min-h-screen bg-[#F5F5F7] pt-32 pb-24">
      <div className="container mx-auto px-6 max-w-4xl">

        {/* Header */}
        <div className="text-center mb-16 animate-in fade-in slide-in-from-top-4 duration-1000">
          <div className="inline-flex items-center gap-2 px-4 py-2 bg-red-50 text-red-700 rounded-full text-[10px] font-black uppercase tracking-[0.2em] mb-6 border border-red-200">
            <Trash2 size={14} /> Eliminación de cuenta
          </div>
          <h1 className="text-4xl md:text-5xl font-black text-[#0E2244] tracking-tighter mb-4">
            Elimina tu cuenta de <span className="text-[#E2E000] bg-[#0E2244] px-3 rounded-xl">KLICUS</span>
          </h1>
          <p className="text-gray-500 font-medium text-lg max-w-2xl mx-auto leading-relaxed mt-6">
            Esta página explica cómo los usuarios de la aplicación <strong>KLICUS</strong> —
            marketplace de publicidad local — pueden solicitar la eliminación permanente
            de su cuenta y datos personales.
          </p>
        </div>

        <div className="space-y-8 animate-in fade-in duration-1000 delay-300">

          {/* ── 1. Cómo solicitar la eliminación ── */}
          <div className="bg-white rounded-[2.5rem] p-8 md:p-12 shadow-xl shadow-black/5 border border-gray-100">
            <div className="flex items-center gap-4 mb-8">
              <div className="w-12 h-12 rounded-2xl bg-[#E2E000] flex items-center justify-center flex-shrink-0">
                <Smartphone size={22} className="text-[#0E2244]" />
              </div>
              <div>
                <h2 className="text-2xl font-black text-[#0E2244]">Cómo solicitar la eliminación</h2>
                <p className="text-sm text-gray-400 font-medium mt-0.5">Aplicación KLICUS — Android &amp; iOS</p>
              </div>
            </div>

            {/* Opción A — desde la app */}
            <div className="mb-8">
              <span className="inline-block px-3 py-1 bg-[#0E2244] text-[#E2E000] text-xs font-black rounded-full uppercase tracking-widest mb-5">
                Opción A · Desde la app
              </span>
              <ol className="space-y-4">
                {[
                  'Abre la aplicación KLICUS en tu dispositivo.',
                  'Dirígete a la pestaña Perfil (ícono de persona, esquina inferior derecha).',
                  'Toca el menú Privacidad y Seguridad.',
                  'Selecciona Eliminar mi cuenta.',
                  'Confirma la acción introduciendo tu contraseña.',
                  'Tu solicitud se procesará de inmediato y recibirás confirmación por correo electrónico.',
                ].map((text, i) => (
                  <li key={i} className="flex items-start gap-4">
                    <span className="flex-shrink-0 w-8 h-8 rounded-full bg-[#E2E000] flex items-center justify-center text-[#0E2244] font-black text-sm">
                      {i + 1}
                    </span>
                    <p className="text-gray-600 font-medium pt-1 leading-relaxed">{text}</p>
                  </li>
                ))}
              </ol>
            </div>

            {/* Opción B — por correo */}
            <div className="p-6 bg-[#F5F5F7] rounded-2xl border border-gray-200">
              <span className="inline-block px-3 py-1 bg-[#0E2244] text-[#E2E000] text-xs font-black rounded-full uppercase tracking-widest mb-4">
                Opción B · Por correo electrónico
              </span>
              <div className="flex items-start gap-3">
                <Mail size={18} className="text-[#0E2244] mt-0.5 flex-shrink-0" />
                <p className="text-gray-600 font-medium text-sm leading-relaxed">
                  Envía un correo a{' '}
                  <a href="mailto:info@klicus.com.co" className="text-[#0E2244] font-black underline underline-offset-2">
                    info@klicus.com.co
                  </a>{' '}
                  desde la dirección registrada en tu cuenta KLICUS, con el asunto{' '}
                  <span className="font-black">"Solicitud de eliminación de cuenta"</span>.
                  Responderemos y procesaremos la solicitud en un plazo máximo de <strong>5 días hábiles</strong>.
                </p>
              </div>
            </div>
          </div>

          {/* ── 2. Datos eliminados vs conservados ── */}
          <div className="bg-white rounded-[2.5rem] p-8 md:p-12 shadow-xl shadow-black/5 border border-gray-100">
            <div className="flex items-center gap-4 mb-8">
              <div className="w-12 h-12 rounded-2xl bg-[#E2E000] flex items-center justify-center flex-shrink-0">
                <ShieldCheck size={22} className="text-[#0E2244]" />
              </div>
              <h2 className="text-2xl font-black text-[#0E2244]">Qué datos se eliminan y cuáles se conservan</h2>
            </div>

            {/* Tabla datos eliminados */}
            <div className="mb-8">
              <h3 className="text-sm font-black text-[#0E2244] uppercase tracking-widest mb-4 flex items-center gap-2">
                <span className="w-2 h-2 rounded-full bg-red-500 inline-block" /> Eliminados permanentemente
              </h3>
              <div className="overflow-x-auto">
                <table className="w-full text-sm">
                  <thead>
                    <tr className="border-b border-gray-100">
                      <th className="text-left py-3 px-4 font-black text-[#0E2244] text-xs uppercase tracking-wider">Tipo de dato</th>
                      <th className="text-left py-3 px-4 font-black text-[#0E2244] text-xs uppercase tracking-wider">Cuándo se elimina</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-50">
                    {[
                      ['Nombre, correo electrónico y contraseña', 'Inmediatamente al confirmar'],
                      ['Número de teléfono y datos de perfil', 'Inmediatamente al confirmar'],
                      ['Foto de perfil', 'En las siguientes 24 horas'],
                      ['Todos los anuncios publicados', 'Inmediatamente (dejan de ser visibles al público)'],
                      ['Imágenes de anuncios (almacenamiento en la nube)', 'En las siguientes 24 horas'],
                      ['Historial de conversaciones y mensajes de chat', 'En las siguientes 24 horas'],
                      ['Favoritos guardados', 'Inmediatamente al confirmar'],
                      ['Preferencias de notificaciones', 'Inmediatamente al confirmar'],
                      ['Token de sesión y credenciales de autenticación', 'Inmediatamente al confirmar'],
                    ].map(([dato, cuando]) => (
                      <tr key={dato} className="hover:bg-gray-50/50">
                        <td className="py-3 px-4 text-gray-600 font-medium">{dato}</td>
                        <td className="py-3 px-4 text-gray-500 font-medium">{cuando}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>

            {/* Tabla datos conservados */}
            <div>
              <h3 className="text-sm font-black text-[#0E2244] uppercase tracking-widest mb-4 flex items-center gap-2">
                <span className="w-2 h-2 rounded-full bg-amber-500 inline-block" /> Conservados temporalmente
              </h3>
              <div className="overflow-x-auto">
                <table className="w-full text-sm">
                  <thead>
                    <tr className="border-b border-gray-100">
                      <th className="text-left py-3 px-4 font-black text-[#0E2244] text-xs uppercase tracking-wider">Tipo de dato</th>
                      <th className="text-left py-3 px-4 font-black text-[#0E2244] text-xs uppercase tracking-wider">Periodo de retención</th>
                      <th className="text-left py-3 px-4 font-black text-[#0E2244] text-xs uppercase tracking-wider">Motivo</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-50">
                    {[
                      ['Copias de seguridad cifradas del sistema', 'Máximo 30 días', 'Continuidad operativa del servicio'],
                      ['Estadísticas de uso agregadas y anonimizadas', 'Indefinido', 'Sin identificación personal; solo datos agregados'],
                      ['Registros de transacciones (si aplica)', 'Hasta 5 años', 'Obligación legal contable y fiscal'],
                    ].map(([dato, periodo, motivo]) => (
                      <tr key={dato} className="hover:bg-amber-50/30">
                        <td className="py-3 px-4 text-gray-600 font-medium">{dato}</td>
                        <td className="py-3 px-4 font-black text-amber-700 text-xs">{periodo}</td>
                        <td className="py-3 px-4 text-gray-500 font-medium text-xs">{motivo}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          </div>

          {/* ── 3. Plazos del proceso ── */}
          <div className="bg-white rounded-[2.5rem] p-8 md:p-12 shadow-xl shadow-black/5 border border-gray-100">
            <div className="flex items-center gap-4 mb-8">
              <div className="w-12 h-12 rounded-2xl bg-[#E2E000] flex items-center justify-center flex-shrink-0">
                <Clock size={22} className="text-[#0E2244]" />
              </div>
              <h2 className="text-2xl font-black text-[#0E2244]">Plazos del proceso de eliminación</h2>
            </div>

            <div className="space-y-4">
              {[
                {
                  color: 'bg-green-500',
                  label: 'Inmediato',
                  title: 'Acceso bloqueado y anuncios despublicados',
                  desc: 'Al confirmar la solicitud, tu sesión se cierra automáticamente, no podrás volver a iniciar sesión y tus anuncios dejan de ser visibles al público de forma inmediata.',
                },
                {
                  color: 'bg-amber-500',
                  label: '≤ 24 horas',
                  title: 'Perfil, anuncios e imágenes eliminados',
                  desc: 'Todos tus datos personales, anuncios publicados e imágenes asociadas son eliminados de la base de datos y del almacenamiento en la nube dentro de las 24 horas siguientes a la solicitud.',
                },
                {
                  color: 'bg-[#0E2244]',
                  label: '≤ 30 días',
                  title: 'Copias de seguridad purgadas',
                  desc: 'Los datos pueden permanecer en copias de seguridad cifradas durante un máximo de 30 días naturales, tras los cuales son eliminados definitivamente de todos los sistemas de KLICUS.',
                },
              ].map(({ color, label, title, desc }) => (
                <div key={title} className="flex items-start gap-5 p-5 rounded-2xl bg-gray-50 border border-gray-100">
                  <div className={`w-10 h-10 rounded-xl ${color} flex items-center justify-center flex-shrink-0`}>
                    <span className="text-white font-black text-[10px] text-center leading-tight">{label}</span>
                  </div>
                  <div>
                    <p className="font-black text-[#0E2244] mb-1">{title}</p>
                    <p className="text-gray-500 font-medium text-sm leading-relaxed">{desc}</p>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* ── Advertencia final ── */}
          <div className="bg-[#0E2244] rounded-[2.5rem] p-8 md:p-10">
            <div className="flex items-start gap-4">
              <div className="w-10 h-10 rounded-xl bg-[#E2E000] flex items-center justify-center flex-shrink-0 mt-1">
                <AlertTriangle size={18} className="text-[#0E2244]" />
              </div>
              <div>
                <h3 className="text-white font-black text-lg mb-2">
                  La eliminación de cuenta en KLICUS es permanente e irreversible
                </h3>
                <p className="text-white/70 font-medium leading-relaxed text-sm">
                  Una vez completado el proceso no podrás recuperar tus anuncios, mensajes ni historial.
                  Si tienes dudas, considera simplemente cerrar sesión. Para cualquier consulta antes
                  de tomar esta decisión, nuestro equipo de soporte está disponible.
                </p>
                <div className="flex flex-wrap gap-3 mt-6">
                  <a
                    href="mailto:info@klicus.com.co"
                    className="inline-flex items-center gap-2 px-5 py-2.5 bg-[#E2E000] text-[#0E2244] font-black text-sm rounded-full hover:bg-yellow-300 transition-colors"
                  >
                    <Mail size={14} /> info@klicus.com.co
                  </a>
                </div>
              </div>
            </div>
          </div>

          {/* Links relacionados */}
          <div className="flex flex-wrap gap-6 justify-center pt-2">
            <Link href="/privacidad" className="inline-flex items-center gap-1.5 text-[#0E2244] font-black text-sm hover:underline underline-offset-4">
              <ChevronRight size={14} /> Política de Privacidad
            </Link>
            <Link href="/terminos" className="inline-flex items-center gap-1.5 text-[#0E2244] font-black text-sm hover:underline underline-offset-4">
              <ChevronRight size={14} /> Términos y Condiciones
            </Link>
            <Link href="/contacto" className="inline-flex items-center gap-1.5 text-[#0E2244] font-black text-sm hover:underline underline-offset-4">
              <ChevronRight size={14} /> Contacto
            </Link>
          </div>

        </div>
      </div>
    </div>
  );
}
