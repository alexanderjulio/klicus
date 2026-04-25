import { FileText, CheckCircle, AlertTriangle, Scale, ChevronRight } from 'lucide-react';
import Link from 'next/link';

export const metadata = {
  title: "Términos de Servicio | KLICUS",
  description: "Lee los términos y condiciones de uso de la plataforma KLICUS.",
};

export default function TerminosPage() {
  return (
    <div className="min-h-screen bg-[#F5F5F7] pt-32 pb-24">
      <div className="container mx-auto px-6 max-w-4xl">
        {/* Header Section */}
        <div className="text-center mb-16 animate-in fade-in slide-in-from-top-4 duration-1000">
          <div className="inline-flex items-center gap-2 px-4 py-2 bg-primary/10 text-secondary rounded-full text-[10px] font-black uppercase tracking-[0.2em] mb-6 border border-primary/20">
            <Scale size={14} className="text-primary" /> Marco Legal
          </div>
          <h1 className="text-4xl md:text-5xl font-black text-secondary tracking-tighter mb-4">
            Términos de Servicio
          </h1>
          <p className="text-muted-foreground font-medium text-lg italic">
            Reglas claras para una comunidad confiable.
          </p>
        </div>

        {/* Content Section */}
        <div className="bg-white rounded-[3rem] p-8 md:p-16 shadow-2xl shadow-black/5 border border-border animate-in fade-in duration-1000 delay-500">
          <div className="prose prose-slate max-w-none space-y-12">
            <section>
              <div className="flex items-center gap-4 mb-6">
                <div className="w-10 h-10 rounded-xl bg-primary/20 flex items-center justify-center text-secondary">
                  <CheckCircle size={20} />
                </div>
                <h2 className="text-2xl font-black text-secondary m-0">1. Aceptación de los Términos</h2>
              </div>
              <p className="text-muted-foreground font-medium leading-relaxed">
                Al acceder y utilizar KLICUS, aceptas cumplir con estos términos de servicio. Nuestra plataforma es un marketplace publicitario que facilita la conexión entre vendedores y compradores locales.
              </p>
            </section>

            <section>
              <div className="flex items-center gap-4 mb-6">
                <div className="w-10 h-10 rounded-xl bg-primary/20 flex items-center justify-center text-secondary">
                  <FileText size={20} />
                </div>
                <h2 className="text-2xl font-black text-secondary m-0">2. Responsabilidad de los Anuncios</h2>
              </div>
              <p className="text-muted-foreground font-medium leading-relaxed">
                Los usuarios son los únicos responsables de la veracidad y legalidad de los anuncios que publican. KLICUS no garantiza la calidad, seguridad o legalidad de los artículos o servicios anunciados, ni la veracidad de la información proporcionada por los usuarios.
              </p>
            </section>

            <section>
              <div className="flex items-center gap-4 mb-6">
                <div className="w-10 h-10 rounded-xl bg-primary/20 flex items-center justify-center text-secondary">
                  <AlertTriangle size={20} />
                </div>
                <h2 className="text-2xl font-black text-secondary m-0">3. Usos Prohibidos</h2>
              </div>
              <p className="text-muted-foreground font-medium leading-relaxed">
                Queda estrictamente prohibida la publicación de:
              </p>
              <ul className="list-none space-y-3 mt-4">
                {[
                  "Contenido ilegal o fraudulento.",
                  "Artículos robados o falsificados.",
                  "Material ofensivo, difamatorio o que incite al odio.",
                  "Servicios o productos que requieran licencias especiales sin poseerlas."
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
                  <Scale size={20} />
                </div>
                <h2 className="text-2xl font-black text-secondary m-0">4. Limitación de Responsabilidad</h2>
              </div>
              <p className="text-muted-foreground font-medium leading-relaxed">
                KLICUS no se hace responsable de daños directos o indirectos resultantes del uso de la plataforma o de las transacciones realizadas entre usuarios. Recomendamos siempre tomar precauciones de seguridad al concretar ventas de forma presencial.
              </p>
            </section>
          </div>

          <div className="mt-16 pt-8 border-t border-border flex flex-col md:flex-row justify-between items-center gap-6">
            <p className="text-sm text-muted-foreground font-medium">
              Última actualización: 25 de abril, 2026
            </p>
            <Link href="/ayuda">
              <button className="text-secondary font-black text-sm flex items-center gap-2 hover:gap-4 transition-all">
                ¿Necesitas ayuda? <ChevronRight size={16} />
              </button>
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}
