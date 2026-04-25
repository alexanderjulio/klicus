import { Mail, Phone, MessageCircle, MapPin, Send, Globe, Users, AtSign } from 'lucide-react';

export const metadata = {
  title: "Contacto | KLICUS",
  description: "Ponte en contacto con el equipo de KLICUS. Estamos aquí para ayudarte.",
};

export default function ContactoPage() {
  return (
    <div className="min-h-screen bg-[#F5F5F7] pt-32 pb-24">
      <div className="container mx-auto px-6">
        {/* Header Section */}
        <div className="text-center mb-16 max-w-2xl mx-auto animate-in fade-in slide-in-from-top-4 duration-1000">
          <div className="inline-flex items-center gap-2 px-4 py-2 bg-primary/10 text-secondary rounded-full text-[10px] font-black uppercase tracking-[0.2em] mb-6 border border-primary/20">
            <MessageCircle size={14} className="text-primary" /> Canales Oficiales
          </div>
          <h1 className="text-4xl md:text-5xl font-black text-secondary tracking-tighter mb-4">
            Estamos a un clic <br /> de distancia
          </h1>
          <p className="text-muted-foreground font-medium text-lg italic">
            Ya sea que necesites soporte técnico o quieras anunciar con nosotros, estamos listos para escucharte.
          </p>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-12 max-w-6xl mx-auto">
          {/* Contact Info Cards */}
          <div className="lg:col-span-1 space-y-6">
            {[
              { 
                icon: Phone, 
                title: "Llamadas", 
                value: "+57 313 532 8897", 
                desc: "Lunes a Viernes, 8am - 6pm",
                color: "bg-blue-500" 
              },
              { 
                icon: Mail, 
                title: "Correo Electrónico", 
                value: "info@klicus.com.co", 
                desc: "Respuesta en menos de 24h",
                color: "bg-primary" 
              },
              { 
                icon: MapPin, 
                title: "Ubicación", 
                value: "Bucaramanga, Santander", 
                desc: "Colombia",
                color: "bg-secondary" 
              }
            ].map((item, i) => (
              <div key={i} className="bg-white p-8 rounded-[2rem] shadow-xl shadow-black/5 border border-black/5 hover:scale-[1.02] transition-all group">
                <div className={`w-12 h-12 ${item.color} rounded-xl flex items-center justify-center text-white mb-6 shadow-lg rotate-3 group-hover:rotate-0 transition-transform`}>
                  <item.icon size={24} />
                </div>
                <h3 className="text-lg font-black text-secondary mb-1">{item.title}</h3>
                <p className="text-secondary font-bold mb-1">{item.value}</p>
                <p className="text-xs text-muted-foreground font-medium uppercase tracking-widest">{item.desc}</p>
              </div>
            ))}

            {/* Social Media */}
            <div className="bg-secondary rounded-[2rem] p-8 text-white">
              <h3 className="text-lg font-black mb-6">Síguenos</h3>
              <div className="flex gap-4">
                {[Globe, Users, AtSign].map((Icon, i) => (
                  <button key={i} className="w-12 h-12 rounded-xl bg-white/10 flex items-center justify-center hover:bg-primary hover:text-secondary transition-all">
                    <Icon size={20} />
                  </button>
                ))}
              </div>
            </div>
          </div>

          {/* Contact Form */}
          <div className="lg:col-span-2 bg-white rounded-[3rem] p-8 md:p-12 shadow-2xl shadow-black/5 border border-border">
            <h2 className="text-3xl font-black text-secondary tracking-tighter mb-8">Envíanos un mensaje</h2>
            <form className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="space-y-2">
                <label className="text-[10px] font-black text-secondary uppercase tracking-widest">Nombre Completo</label>
                <input 
                  type="text" 
                  placeholder="Tu nombre aquí"
                  className="w-full bg-[#F5F5F7] border-none rounded-2xl px-6 py-4 outline-none focus:ring-2 focus:ring-primary/50 transition-all font-medium text-secondary"
                />
              </div>
              <div className="space-y-2">
                <label className="text-[10px] font-black text-secondary uppercase tracking-widest">Correo Electrónico</label>
                <input 
                  type="email" 
                  placeholder="tu@email.com"
                  className="w-full bg-[#F5F5F7] border-none rounded-2xl px-6 py-4 outline-none focus:ring-2 focus:ring-primary/50 transition-all font-medium text-secondary"
                />
              </div>
              <div className="md:col-span-2 space-y-2">
                <label className="text-[10px] font-black text-secondary uppercase tracking-widest">Asunto</label>
                <input 
                  type="text" 
                  placeholder="¿En qué podemos ayudarte?"
                  className="w-full bg-[#F5F5F7] border-none rounded-2xl px-6 py-4 outline-none focus:ring-2 focus:ring-primary/50 transition-all font-medium text-secondary"
                />
              </div>
              <div className="md:col-span-2 space-y-2">
                <label className="text-[10px] font-black text-secondary uppercase tracking-widest">Mensaje</label>
                <textarea 
                  rows="5"
                  placeholder="Escribe tu mensaje detallado..."
                  className="w-full bg-[#F5F5F7] border-none rounded-2xl px-6 py-4 outline-none focus:ring-2 focus:ring-primary/50 transition-all font-medium text-secondary resize-none"
                ></textarea>
              </div>
              <div className="md:col-span-2 pt-4">
                <button className="w-full md:w-auto bg-primary text-secondary px-12 py-5 rounded-2xl font-black shadow-2xl shadow-primary/30 hover:scale-105 active:scale-95 transition-all flex items-center justify-center gap-3">
                  <Send size={20} /> Enviar Mensaje
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  );
}
