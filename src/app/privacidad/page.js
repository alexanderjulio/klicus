import { Shield, Lock, Eye, FileText, ChevronRight } from 'lucide-react';
import Link from 'next/link';

export const metadata = {
  title: "Política de Privacidad | KLICUS",
  description: "Conoce cómo protegemos tus datos y tu privacidad en KLICUS.",
};

export default function PrivacidadPage() {
  return (
    <div className="min-h-screen bg-[#F5F5F7] pt-32 pb-24">
      <div className="container mx-auto px-6 max-w-4xl">
        {/* Header Section */}
        <div className="text-center mb-16 animate-in fade-in slide-in-from-top-4 duration-1000">
          <div className="inline-flex items-center gap-2 px-4 py-2 bg-primary/10 text-secondary rounded-full text-[10px] font-black uppercase tracking-[0.2em] mb-6 border border-primary/20">
            <Shield size={14} className="text-primary" /> Privacidad y Seguridad
          </div>
          <h1 className="text-4xl md:text-5xl font-black text-secondary tracking-tighter mb-4">
            Política de Privacidad
          </h1>
          <p className="text-muted-foreground font-medium text-lg italic">
            Tu confianza es nuestro activo más valioso.
          </p>
        </div>

        {/* Content Section */}
        <div className="bg-white rounded-[3rem] p-8 md:p-16 shadow-2xl shadow-black/5 border border-border animate-in fade-in duration-1000 delay-500">
          <div className="prose prose-slate max-w-none space-y-12">
            <section>
              <div className="flex items-center gap-4 mb-6">
                <div className="w-10 h-10 rounded-xl bg-primary/20 flex items-center justify-center text-secondary">
                  <Eye size={20} />
                </div>
                <h2 className="text-2xl font-black text-secondary m-0">1. Información que Recopilamos</h2>
              </div>
              <p className="text-muted-foreground font-medium leading-relaxed">
                En KLICUS recopilamos información básica para proporcionarte un mejor servicio. Esto incluye tu nombre, correo electrónico y número de contacto cuando te registras o publicas un anuncio. También recopilamos datos de navegación de forma anónima para mejorar la experiencia de usuario.
              </p>
            </section>

            <section>
              <div className="flex items-center gap-4 mb-6">
                <div className="w-10 h-10 rounded-xl bg-primary/20 flex items-center justify-center text-secondary">
                  <Lock size={20} />
                </div>
                <h2 className="text-2xl font-black text-secondary m-0">2. Uso de la Información</h2>
              </div>
              <p className="text-muted-foreground font-medium leading-relaxed">
                Utilizamos tus datos para:
              </p>
              <ul className="list-none space-y-3 mt-4">
                {[
                  "Facilitar la publicación y gestión de tus anuncios.",
                  "Permitir que compradores potenciales te contacten directamente.",
                  "Enviarte notificaciones importantes sobre tu cuenta y el servicio.",
                  "Prevenir actividades fraudulentas y mantener la seguridad de la plataforma."
                ].map((item, i) => (
                  <li key={i} className="flex items-start gap-3 text-muted-foreground font-medium">
                    <ChevronRight size={16} className="text-primary mt-1 shrink-0" />
                    {item}
                  </li>
                ))}
              </ul>
            </section>

            <section>
              <div className="flex items-center gap-4 mb-6">
                <div className="w-10 h-10 rounded-xl bg-primary/20 flex items-center justify-center text-secondary">
                  <Shield size={20} />
                </div>
                <h2 className="text-2xl font-black text-secondary m-0">3. Protección de Datos</h2>
              </div>
              <p className="text-muted-foreground font-medium leading-relaxed">
                Implementamos medidas de seguridad técnicas y organizativas para proteger tu información personal contra acceso no autorizado, alteración, divulgación o destrucción. Tus datos sensibles están encriptados y almacenados en servidores seguros.
              </p>
            </section>

            <section>
              <div className="flex items-center gap-4 mb-6">
                <div className="w-10 h-10 rounded-xl bg-primary/20 flex items-center justify-center text-secondary">
                  <FileText size={20} />
                </div>
                <h2 className="text-2xl font-black text-secondary m-0">4. Tus Derechos</h2>
              </div>
              <p className="text-muted-foreground font-medium leading-relaxed">
                Tienes derecho a acceder, rectificar o eliminar tus datos personales en cualquier momento desde tu panel de configuración o contactando con nuestro soporte técnico.
              </p>
            </section>
          </div>

          <div className="mt-16 pt-8 border-t border-border flex flex-col md:flex-row justify-between items-center gap-6">
            <p className="text-sm text-muted-foreground font-medium">
              Última actualización: 25 de abril, 2026
            </p>
            <Link href="/ayuda">
              <button className="text-secondary font-black text-sm flex items-center gap-2 hover:gap-4 transition-all">
                ¿Tienes dudas? Visita nuestro centro de ayuda <ChevronRight size={16} />
              </button>
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}
