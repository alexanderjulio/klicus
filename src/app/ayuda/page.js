import { HelpCircle, Book, Shield, MessageSquare, ArrowRight, Zap, Target, Star } from 'lucide-react';

export const metadata = {
  title: "Ayuda y Soporte | KLICUS",
  description: "Todo lo que necesitas saber para vender y comprar en KLICUS.",
};

export default function AyudaPage() {
  const faqs = [
    {
      q: "¿Cómo publico un anuncio en KLICUS?",
      a: "Es muy sencillo. Solo debes registrarte, pulsar el botón de 'Vender' en la barra de navegación y completar los 4 pasos del formulario: Categoría, Información Visual, Contacto y Selección de Plan."
    },
    {
      q: "¿Qué beneficios tienen los planes Pro y Diamante?",
      a: "Estos planes otorgan prioridad de visualización (apareces antes que otros), te permiten subir más fotografías (hasta 5) y habilitan funciones premium como el marcado de 'Ofertas Destacadas' y visibilidad en banners principales."
    },
    {
      q: "¿Cómo contacto a un anunciante?",
      a: "Dentro de cada anuncio encontrarás botones directos de WhatsApp, llamada telefónica y redes sociales. KLICUS facilita el contacto directo, no somos intermediarios en la transacción."
    },
    {
      q: "¿Es seguro comprar en KLICUS?",
      a: "KLICUS es una vitrina publicitaria. Recomendamos siempre verificar la identidad del vendedor, no realizar pagos por adelantado a personas desconocidas y preferir encuentros en lugares públicos o comercios establecidos."
    }
  ];

  return (
    <div className="min-h-screen bg-[#F5F5F7] pt-32 pb-24">
      <div className="container mx-auto px-6">
        {/* Header Section */}
        <div className="text-center mb-16 max-w-2xl mx-auto animate-in fade-in slide-in-from-top-4 duration-1000">
          <div className="inline-flex items-center gap-2 px-4 py-2 bg-primary/10 text-secondary rounded-full text-[10px] font-black uppercase tracking-[0.2em] mb-6 border border-primary/20">
            <HelpCircle size={14} className="text-primary" /> Centro de Soporte
          </div>
          <h1 className="text-4xl md:text-5xl font-black text-secondary tracking-tighter mb-4">
            ¿Cómo podemos ayudarte hoy?
          </h1>
          <p className="text-muted-foreground font-medium text-lg italic">
            Estamos aquí para que tu experiencia en KLICUS sea extraordinaria.
          </p>
        </div>

        {/* Feature Cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mb-20 animate-in fade-in slide-in-from-bottom-8 duration-1000 delay-200">
          {[
            { icon: Book, title: "Guías de Usuario", desc: "Aprende a navegar y gestionar tu perfil paso a paso.", color: "bg-blue-500" },
            { icon: Zap, title: "Planes Premium", desc: "Maximiza tu alcance con nuestras opciones Pro y Diamante.", color: "bg-yellow-500" },
            { icon: Shield, title: "Seguridad", desc: "Consejos prácticos para comprar y vender con total confianza.", color: "bg-green-500" }
          ].map((item, i) => (
            <div key={i} className="bg-white p-8 rounded-[2.5rem] shadow-xl shadow-black/5 border border-black/5 hover:scale-[1.03] transition-all group cursor-pointer">
              <div className={`w-14 h-14 ${item.color} rounded-2xl flex items-center justify-center text-white mb-6 shadow-lg rotate-3 group-hover:rotate-0 transition-transform`}>
                <item.icon size={28} />
              </div>
              <h3 className="text-xl font-black text-secondary mb-3">{item.title}</h3>
              <p className="text-sm text-muted-foreground font-medium mb-6 leading-relaxed">{item.desc}</p>
              <div className="flex items-center gap-2 text-[10px] font-black uppercase tracking-widest text-[#0E2244] opacity-50 group-hover:opacity-100 transition-opacity">
                Más información <ArrowRight size={14} />
              </div>
            </div>
          ))}
        </div>

        {/* FAQs */}
        <div className="bg-white rounded-[3rem] p-8 md:p-16 shadow-2xl shadow-black/5 border border-border animate-in fade-in duration-1000 delay-500">
          <h2 className="text-3xl font-black text-secondary tracking-tighter mb-12 text-center">Preguntas Frecuentes</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-12">
            {faqs.map((faq, i) => (
              <div key={i} className="space-y-4">
                <div className="flex gap-4">
                  <div className="w-8 h-8 rounded-full bg-primary/20 text-[#0E2244] flex items-center justify-center shrink-0 font-black text-sm">
                    {i + 1}
                  </div>
                  <div>
                    <h4 className="text-lg font-black text-secondary mb-2 leading-tight">{faq.q}</h4>
                    <p className="text-sm text-muted-foreground font-medium leading-relaxed">{faq.a}</p>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Contact Banner */}
        <div className="mt-20 bg-secondary rounded-[3rem] p-12 text-center text-white relative overflow-hidden">
          <div className="absolute top-0 right-0 w-64 h-64 bg-primary/20 rounded-full -translate-y-1/2 translate-x-1/2 blur-3xl" />
          <h2 className="text-3xl font-black tracking-tight mb-4 italic">¿No encuentras lo que buscas?</h2>
          <p className="text-white/70 font-medium mb-8 max-w-lg mx-auto leading-relaxed">
            Nuestro equipo de satisfacción al cliente está listo para atenderte por nuestros canales oficiales.
          </p>
          <button className="bg-primary text-secondary px-10 py-4 rounded-2xl font-black shadow-2xl shadow-primary/30 hover:scale-105 transition-all flex items-center gap-3 mx-auto">
            <MessageSquare size={20} /> Hablar con un asesor
          </button>
        </div>
      </div>
    </div>
  );
}
