'use client';

import { useState } from 'react';
import {
  Camera, Send, ShieldCheck, CheckCircle2, MapPin, Tag, ArrowRight, ArrowLeft,
  Clock, Phone, Smartphone, Mail, Globe, MessageSquare, Truck, Info, PlusCircle,
  Share2, DollarSign
} from 'lucide-react';
import { cn } from '@/lib/utils';
import Button from './ui/Button';
import { motion, AnimatePresence } from 'framer-motion';
import { getPlanById, PLAN_LIST } from '@/config/plans';
import { useToast } from '@/context/ToastContext';

// UNIVERSAL COLOMBIA CITIES DATABASE
const COLOMBIA_DATABASE = [
  {"d":"Amazonas","c":["Leticia","Puerto Nariño"]},
  {"d":"Antioquia","c":["Abejorral","Abriaquí","Alejandría","Amagá","Amalfi","Andes","Angelópolis","Angostura","Anorí","Anzá","Apartadó","Arboletes","Argelia","Armenia","Barbosa","Bello","Belmira","Betania","Betulia","Briceño","Buriticá","Cáceres","Caicedo","Caldas","Campamento","Cañasgordas","Caracolí","Caramanta","Carepa","Carolina del Príncipe","Caucasia","Chigorodó","Cisneros","Ciudad Bolívar","Cocorná","Concepción","Concordia","Copacabana","Dabeiba","Donmatías","Ebéjico","El Bagre","El Carmen de Viboral","El Peñol","El Retiro","El Santuario","Entrerríos","Envigado","Fredonia","Frontino","Giraldo","Girardota","Gómez Plata","Granada","Guadalupe","Guarne","Guatapé","Heliconia","Hispania","Itagüí","Ituango","Jardín","Jericó","La Ceja","La Estrella","La Pintada","La Union","Liborina","Maceo","Marinilla","Medellín","Montebello","Murindó","Mutatá","Nariño","Nechí","Necoclí","Olaya","Peque","Pueblorrico","Puerto Berrío","Puerto Nare","Puerto Triunfo","Remedios","Rionegro","Sabanalarga","Sabaneta","Salgar","San Andrés de Cuerquia","San Carlos","San Francisco","San Jerónimo","San José de la Montaña","San Juan de Urabá","San Luis","San Pedro de Urabá","San Pedro de los Milagros","San Rafael","San Roque","San Vicente","Santa Bárbara","Santa Fe de Antioquia","Santa Rosa de Osos","Santo Domingo","Segovia","Sonsón","Sopetrán","Támesis","Tarazá","Tarso","Titiribí","Toledo","Turbo","Uramita","Urrao","Valdivia","Valparaíso","Vegachí","Venecia","Vigía del Fuerte","Yalí","Yarumal","Yolombó","Yondó","Zaragoza"]},
  {"d":"Arauca","c":["Arauca","Arauquita","Cravo Norte","Fortul","Puerto Rondón","Saravena","Tame"]},
  {"d":"Atlántico","c":["Baranoa","Barranquilla","Campo de la Cruz","Candelaria","Galapa","Juan de Acosta","Luruaco","Malambo","Manatí","Palmar de Varela","Piojó","Polonuevo","Ponedera","Puerto Colombia","Repelón","Sabanagrande","Sabanalarga","Santa Lucía","Santo Tomás","Soledad","Suán","Tubará","Usiacurí"]},
  {"d":"Bolívar","c":["Achí","Altos del Rosario","Arenal","Arjona","Arroyohondo","Barranco de Loba","Brazuelo de Papayal","Calamar","Cantagallo","Cartagena de Indias","Cicuco","Clemencia","Córdoba","El Carmen de Bolívar","El Guamo","El Peñón","Hatillo de Loba","Magangué","Mahates","Margarita","María la Baja","Mompós","Montecristo","Morales","Norosí","Pinillos","Regidor","Río Viejo","San Cristóbal","San Estanislao","San Fernando","San Jacinto del Cauca","San Jacinto","San Juan Nepomuceno","San Martín de Loba","San Pablo","Santa Catalina","Santa Rosa","Santa Rosa del Sur","Simití","Soplaviento","Talaigua Nuevo","Tiquisio","Turbaco","Turbaná","Villanueva","Zambrano"]},
  {"d":"Boyacá","c":["Almeida","Aquitania","Arcabuco","Belén","Berbeo","Betéitiva","Boavita","Boyacá","Briceño","Buenavista","Busbanzá","Caldas","Campohermoso","Cerinza","Chinavita","Chiquinquirá","Chíquiza","Chiscas","Chita","Chitaraque","Chivatá","Chivor","Ciénega","Cómbita","Coper","Corrales","Covarachía","Cubará","Cucaita","Cuítiva","Duitama","El Cocuy","El Espino","Firavitoba","Floresta","Gachantivá","Gámeza","Garagoa","Guacamayas","Guateque","Guayatá","Güicán","Iza","Jenesano","Jericó","La Capilla","La Uvita","La Victoria","Labranzagrande","Macanal","Maripí","Miraflores","Mongua","Monguí","Moniquirá","Motavita","Muzo","Nobsa","Nuevo Colón","Oicatá","Otanche","Pachavita","Páez","Paipa","Pajarito","Panqueba","Pauna","Paya","Paz del Río","Pesca","Pisba","Puerto Boyacá","Quípama","Ramiriquí","Ráquira","Rondón","Saboyá","Sáchica","Samacá","San Eduardo","San José de Pare","San Luis de Gaceno","San Mateo","San Miguel de Sema","San Pablo de Borbur","Santa María","Santa Rosa de Viterbo","Santa Sofía","Santana","Sativanorte","Sativasur","Siachoque","Soatá","Socha","Socotá","Sogamoso","Somondoco","Sora","Soracá","Sotaquirá","Susacón","Sutamarchán","Sutatenza","Tasco","Tenza","Tibaná","Tibasosa","Tinjacá","Tipacoque","Toca","Togüí","Tópaga","Tota","Tunja","Tununguá","Turmequé","Tuta","Tutazá","Úmbita","Ventaquemada","Villa de Leyva","Viracachá","Zetaquira"]},
  {"d":"Caldas","c":["Aguadas","Anserma","Aranzazu","Belalcázar","Chinchiná","Filadelfia","La Dorada","La Merced","Manizales","Manzanares","Marmato","Marquetalia","Marulanda","Neira","Norcasia","Pácora","Palestina","Pensilvania","Riosucio","Risaralda","Salamina","Samaná","San José","Supía","Victoria","Villamaría","Viterbo"]},
  {"d":"Caquetá","c":["Albania","Belén de los Andaquíes","Cartagena del Chairá","Curillo","El Doncello","El Paujil","Florencia","La Montañita","Milán","Morelia","Puerto Rico","San José del Fragua","San Vicente del Caguán","Solano","Solita","Valparaíso"]},
  {"d":"Casanare","c":["Aguazul","Chámeza","Hato Corozal","La Salina","Maní","Monterrey","Nunchía","Orocué","Paz de Ariporo","Pore","Recetor","Sabanalarga","Sácama","San Luis de Palenque","Támara","Tauramena","Trinidad","Villanueva","Yopal"]},
  {"d":"Cauca","c":["Almaguer","Argelia","Balboa","Bolívar","Buenos Aires","Cajibío","Caldono","Caloto","Corinto","El Tambo","Florencia","Guachené","Guapí","Inzá","Jambaló","La Sierra","La Vega","López de Micay","Mercaderes","Miranda","Morales","Padilla","Páez","Patía","Piamonte","Piendamó","Popayán","Puerto Tejada","Puracé","Rosas","San Sebastián","Santa Rosa","Santander de Quilichao","Silvia","Sotará","Suárez","Sucre","Timbío","Timbiquí","Toribío","Totoró","Villa Rica"]},
  {"d":"Cesar","c":["Aguachica","Agustín Codazzi","Astrea","Becerril","Bosconia","Chimichagua","Chiriguaná","Curumaní","El Copey","El Paso","Gamarra","González","La Gloria (Cesar)","La Jagua de Ibirico","La Paz","Manaure Balcón del Cesar","Pailitas","Pelaya","Pueblo Bello","Río de Oro","San Alberto","San Diego","San Martín","Tamalameque","Valledupar"]},
  {"d":"Chocó","c":["Acandí","Alto Baudó","Bagadó","Bahía Solano","Bajo Baudó","Bojayá","Cantón de San Pablo","Cértegui","Condoto","El Atrato","El Carmen de Atrato","El Carmen del Darién","Istmina","Juradó","Litoral de San Juan","Lloró","Medio Atrato","Medio Baudó","Medio San Juan","Nóvita","Nuquí","Quibdó","Río Iró","Río Quito","Riosucio","San José del Palmar","Sipí","Tadó","Unión Panamericana","Unguía"]},
  {"d":"Cundinamarca","c":["Agua de Dios","Albán","Anapoima","Anolaima","Apulo","Arbeláez","Beltrán","Bituima","Bogotá","Bojacá","Cabrera","Cachipay","Cajicá","Caparrapí","Cáqueza","Carmen de Carupa","Chaguaní","Chía","Chipaque","Choachí","Chocontá","Cogua","Cota","Cucunubá","El Colegio","El Peñón","El Rosal","Facatativá","Fómeque","Fosca","Funza","Fúquene","Fusagasugá","Gachalá","Gachancipá","Gachetá","Gama","Girardot","Granada","Guachetá","Guaduas","Guasca","Guataquí","Guatavita","Guayabal de Síquima","Guayabetal","Gutiérrez","Jerusalén","Junín","La Calera","La Mesa","La Palma","La Peña","La Vega","Lenguazaque","Machetá","Madrid","Manta","Medina","Mosquera","Nariño","Nemocón","Nilo","Nimaima","Nocaima","Pacho","Paime","Pandi","Paratebueno","Pasca","Puerto Salgar","Pulí","Quebradanegra","Quetame","Quipile","Ricaurte","San Antonio del Tequendama","San Bernardo","San Cayetano","San Francisco","San Juan de Rioseco","Sasaima","Sesquilé","Sibaté","Silvania","Simijaca","Soacha","Sopó","Subachoque","Suesca","Supatá","Susa","Sutatausa","Tabio","Tausa","Tena","Tenjo","Tibacuy","Tibirita","Tocaima","Tocancipá","Topaipí","Ubalá","Ubaque","Ubaté","Une","Útica","Venecia","Vergara","Vianí","Villagómez","Villapinzón","Villeta","Viotá","Yacopí","Zipacón","Zipaquirá"]},
  {"d":"Córdoba","c":["Ayapel","Buenavista","Canalete","Cereté","Chimá","Chinú","Ciénaga de Oro","Cotorra","La Apartada","Lorica","Los Córdobas","Momil","Montelíbano","Montería","Moñitos","Planeta Rica","Pueblo Nuevo","Puerto Escondido","Puerto Libertador","Purísima","Sahagún","San Andrés de Sotavento","San Antero","San Bernardo del Viento","San Carlos","San Jos\u00e9 de Ur\u00e9","San Pelayo","Tierralta","Tuchín","Valencia"]},
  {"d":"Guainía","c":["Inírida"]},
  {"d":"Guaviare","c":["Calamar","El Retorno","Miraflores","San José del Guaviare"]},
  {"d":"Huila","c":["Acevedo","Agrado","Aipe","Algeciras","Altamira","Baraya","Campoalegre","Colombia","El Pital","Elías","Garzón","Gigante","Guadalupe","Hobo","Íquira","Isnos","La Argentina","La Plata","Nátaga","Neiva","Oporapa","Paicol","Palermo","Palestina","Pitalito","Rivera","Saladoblanco","San Agustín","Santa María","Suaza","Tarqui","Tello","Teruel","Tesalia","Timaná","Villavieja","Yaguará"]},
  {"d":"La Guajira","c":["Albania","Barrancas","Dibulla","Distracción","El Molino","Fonseca","Hatonuevo","La Jagua del Pilar","Maicao","Manaure","Riohacha","San Juan del Cesar","Uribia","Urumita","Villanueva"]},
  {"d":"Magdalena","c":["Algarrobo","Aracataca","Ariguaní","Cerro de San Antonio","Chibolo","Ciénaga","Concordia","El Banco","El Piñón","El Retén","Fundación","Guamal","Nueva Granada","Pedraza","Pijiño del Carmen","Pivijay","Plato","Pueblo Viejo","Remolino","Sabanas de San Ángel","Salamina","San Sebastián de Buenavista","San Zenón","Santa Ana","Santa Bárbara de Pinto","Santa Marta","Sitionuevo","Tenerife","Zapayán","Zona Bananera"]},
  {"d":"Meta","c":["Acacías","Barranca de Upía","Cabuyaro","Castilla la Nueva","Cubarral","Cumaral","El Calvario","El Castillo","El Dorado","Fuente de Oro","Granada","Guamal","La Macarena","La Uribe","Lejanías","Mapiripán","Mesetas","Puerto Concordia","Puerto Gaitán","Puerto Lleras","Puerto López","Puerto Rico","Restrepo","San Carlos de Guaroa","San Juan de Arama","San Juanito","San Martín","Villavicencio","Vista Hermosa"]},
  {"d":"Nariño","c":["Aldana","Ancuya","Arboleda","Barbacoas","Belén","Buesaco","Chachagüí","Colón","Consacá","Contadero","Córdoba","Cuaspud","Cumbal","Cumbitara","El Charco","El Peñol","El Rosario","El Tablón de Gómez","El Tambo","Francisco Pizarro","Funes","Guachucal","Guaitarilla","Gualmatán","Iles","Imués","Ipiales","La Cruz","La Florida","La Llanada","La Tola","La Unión","Leiva","Linares","Los Andes","Magüí Payán","Mallama","Mosquera","Nariño","Olaya Herrera","Ospina","Pasto","Policarpa","Potosí","Puerres","Pupiales","Ricaurte","Roberto Payán","Samaniego","San Bernardo","San Lorenzo","San Pablo","San Pedro de Cartago","Sandoná","Santa Bárbara","Santacruz","Sapuyes","Taminango","Tangua","Tumaco","Túquerres","Yacuanquer"]},
  {"d":"Norte de Santander","c":["Ábrego","Arboledas","Bochalema","Bucarasica","Cáchira","Cácota","Chinácota","Chitagá","Convención","Cúcuta","Cucutilla","Durania","El Carmen","El Tarra","El Zulia","Gramalote","Hacarí","Herrán","La Esperanza","La Playa de Belén","Labateca","Lourdes","Mutiscua","Ocaña","Pamplona","Pamplonita","Puerto Santander","Ragonvalia","Salazar de Las Palmas","San Calixto","San Cayetano","Santiago","Santo Domingo de Silos","Sardinata","Teorama","Tibú","Toledo","Villa Caro","Villa del Rosario"]},
  {"d":"Putumayo","c":["Colón","Mocoa","Orito","Puerto Asís","Puerto Caicedo","Puerto Guzmán","Puerto Leguízamo","San Francisco","San Miguel","Santiago","Sibundoy","Valle del Guamuez","Villagarzón"]},
  {"d":"Quindío","c":["Armenia","Buenavista","Calarcá","Circasia","Filandia","Génova","La Tebaida","Montenegro","Pijao","Quimbaya","Quindío","Salento"]},
  {"d":"Risaralda","c":["Apía","Balboa","Belén de Umbría","Dosquebradas","Guática","La Celia","La Virginia","Marsella","Mistrató","Pereira","Pueblo Rico","Quinchía","Santa Rosa de Cabal","Santuario"]},
  {"d":"San Andrés y Providencia","c":["Providencia y Santa Catalina Islas","San Andrés"]},
  {"d":"Santander","c":["Aguada","Albania","Aratoca","Barbosa","Barichara","Barrancabermeja","Betulia","Bolívar","Bucaramanga","Cabrera","California","Capitanejo","Carcasí","Cepitá","Cerrito","Charalá","Charta","Chima","Chipatá","Cimitarra","Concepción","Confines","Contratación","Coromoro","Curití","El Carmen de Chucurí","El Guacamayo","El Peñón","El Playón","Encino","Enciso","Florián","Floridablanca","Galán","Gámbita","Girón","Guaca","Guadalupe","Guapotá","Guavatá","Güepsa","Hato","Jesús María","Jordán","La Belleza","La Paz","Landázuri","Lebrija","Los Santos","Macaravita","Málaga","Matanza","Mogotes","Molagavita","Ocamonte","Oiba","Onzaga","Palmar","Palmas del Socorro","Páramo","Piedecuesta","Pinchote","Puente Nacional","Puerto Parra","Puerto Wilches","Rionegro","Sabana de Torres","San Andrés","San Benito","San Gil","San Joaquín","San José de Miranda","San Miguel","San Vicente de Chucurí","Santa Bárbara","Santa Helena del Opón","Simacota","Socorro","Suaita","Sucre","Suratá","Tona","Valle de San José","Vélez","Vetas","Villanueva","Zapatoca"]},
  {"d":"Sucre","c":["Buenavista","Caimito","Chalán","Colosó","Corozal","Coveñas","El Roble","Galeras","Guaranda","La Unión","Los Palmitos","Majagual","Morroa","Ovejas","Palmito","Sampués","San Benito Abad","San Juan de Betulia","San Marcos","San Onofre","San Pedro","Sincé","Sincelejo","Sucre","Tolú","Toluviejo"]},
  {"d":"Tolima","c":["Alpujarra","Alvarado","Ambalema","Anzoátegui","Armero Guayabal","Ataco","Cajamarca","Carmen de Apicalá","Casabianca","Chaparral","Coello","Coyaima","Cunday","Dolores","Espinal","Falan","Flandes","Fresno","Guamo","Herveo","Honda","Ibagué","Icononzo","Lérida","Líbano","Mariquita","Melgar","Murillo","Natagaima","Ortega","Palocabildo","Piedras","Planadas","Prado","Purificación","Rioblanco","Roncesvalles","Rovira","Saldaña","San Antonio","San Luis","Santa Isabel","Suárez","Valle de San Juan","Venadillo","Villahermosa","Villarrica"]},
  {"d":"Valle del Cauca","c":["Alcalá","Andalucía","Ansermanuevo","Argelia","Bolívar","Buenaventura","Buga","Bugalagrande","Caicedonia","Cali","Calima","Candelaria","Cartago","Dagua","El Cairo","El Cerrito","El Dovio","Florida","Ginebra","Guacarí","Jamunfí","La Cumbre","La Unión","La Victoria","Obando","Palmira","Pradera","Restrepo","Riofrío","Roldanillo","San Pedro","Sevilla","Toro","Trujillo","Tuluá","Ulloa","Versalles","Vijes","Yotoco","Yumbo","Zarzal"]},
  {"d":"Vaupés","c":["Carurú","Mitú","Taraira"]},
  {"d":"Vichada","c":["Cumaribo","La Primavera","Puerto Carreño","Santa Rosalía"]}
];

const ALL_CITIES_FLAT = COLOMBIA_DATABASE.flatMap(dept => 
  dept.c.map(city => `${city}, ${dept.d}`)
);

const normalizeText = (text) => 
  (text || "").normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase();

export default function AdCreationForm({ categories, user, planLimit }) {
  const { showToast } = useToast();

  const [step, setStep] = useState(1);
  const [showCities, setShowCities] = useState(false);
  const [formData, setFormData] = useState({
    title: '',
    description: '',
    categoryId: '',
    location: '',
    address: '',
    businessHours: '',
    phone: '',
    cellphone: '',
    email: '',
    websiteUrl: '',
    facebookUrl: '',
    instagramUrl: '',
    deliveryInfo: '',
    priceRange: '',
    priority: 'basic',
    includeIVA: false,
    isOffer: false
  });
  const [images, setImages] = useState([]);
  const [loading, setLoading] = useState(false);

  const selectedPlan = getPlanById(formData.priority);
  const currentLimit = selectedPlan.photoLimit || 1;
  const isLimitExceeded = images.length > currentLimit;

  const handleImageChange = (e) => {
    const files = Array.from(e.target.files);
    if (files.length + images.length > currentLimit) {
      showToast(`Tu plan ${selectedPlan.name} solo permite ${currentLimit} imágenes.`, 'info');
      return;
    }
    setImages([...images, ...files]);
  };

  const handleSubmit = async (e) => {
    if (e) e.preventDefault();

    if (!formData.title.trim() || !formData.description.trim() || !formData.categoryId || !formData.location.trim()) {
      showToast('Completa los campos obligatorios: nombre, categoría, ciudad y descripción.', 'error');
      return;
    }

    setLoading(true);

    const data = new FormData();
    Object.keys(formData).forEach(key => data.append(key, formData[key]));
    images.forEach(img => data.append('images', img));

    try {
      const res = await fetch('/api/pautas/nueva', {
        method: 'POST',
        body: data
      });
      const result = await res.json();

      if (result.success) {
        const adId = result.data?.adId;
        if (selectedPlan.price > 0) {
          try {
            const checkoutRes = await fetch('/api/payments/checkout', {
              method: 'POST',
              headers: { 'Content-Type': 'application/json' },
              body: JSON.stringify({ adId, planId: formData.priority })
            });
            const checkoutData = await checkoutRes.json();
            if (checkoutData.success && checkoutData.initPoint) {
              window.location.href = checkoutData.initPoint;
              return;
            } else {
              showToast('Error al iniciar el pago: ' + checkoutData.error, 'error');
            }
          } catch (payErr) {
            console.error('Checkout error:', payErr);
            showToast('Error en el motor de pagos', 'error');
          }
        } else {
          setStep(5);
        }
      } else {
        showToast('Error al crear anuncio: ' + result.error, 'error');
      }
    } catch (err) {
      showToast('Error de conexión con el servidor', 'error');
    }
    setLoading(false);
  };

  const renderStepIcon = (s) => {
    if (s < step) return <CheckCircle2 size={20} />;
    return s;
  };

  return (
    <div className="max-w-4xl mx-auto">
      {/* Progress Stepper */}
      <div className="flex items-center justify-center mb-12 gap-4">
        {[1, 2, 3, 4].map((s) => (
          <div key={s} className="flex items-center">
            <div className={cn(
              "w-10 h-10 rounded-full flex items-center justify-center font-bold transition-all border-2",
              step >= s ? "bg-primary border-primary text-secondary" : "bg-white border-border text-muted-foreground"
            )}>
              {renderStepIcon(s)}
            </div>
            {s < 4 && (
              <div className={cn(
                "w-12 md:w-16 h-0.5 mx-2 bg-border transition-colors duration-500",
                step > s && "bg-primary"
              )} />
            )}
          </div>
        ))}
      </div>

      <div className="bg-white rounded-[2.5rem] shadow-2xl overflow-hidden border border-border">
        <AnimatePresence mode="wait">
          
          {/* STEP 1: Selección de Plan (Visibility First) */}
          {step === 1 && (
            <motion.form 
              key="step1" initial={{ opacity: 0, x: 20 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -20 }}
              className="p-8 md:p-12 text-center"
            >
              <div className="mb-10">
                <h2 className="text-3xl font-black text-secondary tracking-tighter uppercase italic">1. Impulsa tu Presencia</h2>
                <p className="text-muted-foreground mt-2 font-medium">Define el nivel de visibilidad y capacidad de tu anuncio.</p>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-12">
                {PLAN_LIST.map((tier) => (
                  <div 
                    key={tier.id}
                    onClick={() => setFormData({...formData, priority: tier.id})}
                    className={cn(
                      "relative p-6 rounded-[2rem] border-2 transition-all cursor-pointer flex flex-col items-center",
                      formData.priority === tier.id 
                        ? (tier.id === 'diamond' ? "border-primary shadow-[0_20px_40px_rgba(226,224,0,0.15)] bg-secondary/5" : "border-primary shadow-xl bg-primary/5") 
                        : "border-border hover:border-primary/40 shadow-sm",
                    )}
                  >
                    {tier.badge && (
                      <div className={cn("absolute -top-3 left-1/2 -translate-x-1/2 px-4 py-1 rounded-full text-[9px] font-black uppercase tracking-widest shadow-lg", tier.id === 'diamond' ? "bg-primary text-secondary" : "bg-accent text-white")}>
                        {tier.badge}
                      </div>
                    )}
                    <h3 className="text-[10px] font-black uppercase tracking-widest mb-3 opacity-60">{tier.name}</h3>
                    <div className="flex items-baseline gap-1 mb-6">
                      <span className="text-3xl font-black">{tier.priceLabel}</span>
                    </div>
                    <ul className="space-y-3 mb-8 w-full text-left">
                      {tier.features.map(f => (
                        <li key={f} className="text-[10px] font-bold flex items-center gap-2">
                          <CheckCircle2 size={12} className="text-primary shrink-0" strokeWidth={3} />
                          <span className="opacity-80">{f}</span>
                        </li>
                      ))}
                    </ul>
                    <div className={cn("mt-auto w-full py-2.5 rounded-xl border font-black text-[9px] uppercase tracking-widest transition-all", formData.priority === tier.id ? "bg-primary border-primary text-secondary" : "border-border text-muted-foreground")}>
                      {formData.priority === tier.id ? 'Seleccionado' : 'Elegir'}
                    </div>
                  </div>
                ))}
              </div>

              <div className="flex justify-end">
                <Button type="button" onClick={() => setStep(2)} className="px-12 h-14 rounded-2xl gap-3 font-black shadow-xl shadow-primary/20">
                  Siguiente paso <ArrowRight size={20} />
                </Button>
              </div>
            </motion.form>
          )}

          {/* STEP 2: Identidad y Ubicación (Smart Selector) */}
          {step === 2 && (
            <motion.form 
              key="step2" initial={{ opacity: 0, x: 20 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -20 }}
              className="p-8 md:p-12 space-y-8"
            >
              <div className="mb-8">
                <h2 className="text-3xl font-black text-secondary tracking-tighter uppercase italic">2. Identidad y Ubicación</h2>
                <p className="text-muted-foreground mt-1 font-medium">Dinos quién eres y dónde pueden encontrarte.</p>
              </div>

              <div className="space-y-6">
                <div className="space-y-2">
                  <label className="text-xs font-black text-secondary uppercase tracking-widest opacity-60">Nombre del Negocio</label>
                  <input 
                    type="text" required value={formData.title}
                    onChange={(e) => setFormData({...formData, title: e.target.value})}
                    placeholder="Ej: CompuByte Tecnología" 
                    className="w-full bg-muted/20 border border-border rounded-2xl px-5 py-4 outline-none focus:border-primary transition-all font-bold"
                  />
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div className="space-y-2">
                    <label className="text-xs font-black text-secondary uppercase tracking-widest opacity-60">Categoría</label>
                    <select 
                      required value={formData.categoryId}
                      onChange={(e) => setFormData({...formData, categoryId: e.target.value})}
                      className="w-full bg-muted/20 border border-border rounded-2xl px-5 py-4 outline-none focus:border-primary transition-all font-bold appearance-none"
                    >
                      <option value="">Seleccionar...</option>
                      {categories.map(cat => <option key={cat.id} value={cat.id}>{cat.name}</option>)}
                    </select>
                  </div>
                  <div className="space-y-2">
                    <label className="text-xs font-black text-secondary uppercase tracking-widest opacity-60">Ciudad / Municipio</label>
                    <div className="relative group/city">
                      <input 
                        type="text" required value={formData.location || ''}
                        onChange={(e) => setFormData({...formData, location: e.target.value})}
                        onFocus={() => setShowCities(true)}
                        onBlur={() => setTimeout(() => setShowCities(false), 200)}
                        placeholder="Ej: Ocaña, N. de Santander" 
                        className="w-full bg-muted/20 border border-border rounded-2xl px-5 py-4 pl-12 outline-none focus:border-primary transition-all font-bold"
                      />
                      <MapPin size={18} className="absolute left-5 top-1/2 -translate-y-1/2 text-primary" />
                      {showCities && (
                        <div className="absolute top-full left-0 right-0 mt-2 bg-white rounded-2xl shadow-2xl border border-border/40 z-[9999] overflow-hidden max-h-60 overflow-y-auto">
                          <div className="p-3 bg-muted/20 border-b border-border/30 text-[9px] font-black uppercase tracking-widest text-secondary/40 flex justify-between items-center">
                            <span>Buscador Nacional</span>
                            <span className="text-[8px] opacity-40">{ALL_CITIES_FLAT.length} municipios</span>
                          </div>
                          {ALL_CITIES_FLAT.filter(city => normalizeText(city).includes(normalizeText(formData.location))).slice(0, 8).map(match => (
                            <button key={match} type="button" onMouseDown={() => { setFormData({...formData, location: match}); setShowCities(false); }} className="w-full text-left px-6 py-3.5 text-xs font-bold hover:bg-primary/10 transition-colors flex items-center justify-between group">
                              {match}
                              <span className="text-[9px] opacity-0 group-hover:opacity-100 uppercase tracking-widest text-primary font-black">Seleccionar</span>
                            </button>
                          ))}
                        </div>
                      )}
                    </div>
                  </div>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div className="space-y-2">
                    <label className="text-xs font-black text-secondary uppercase tracking-widest opacity-60">Dirección Exacta</label>
                    <input type="text" value={formData.address} onChange={(e) => setFormData({...formData, address: e.target.value})} placeholder="Ej: Calle 32 #5-12, Centro" className="w-full bg-muted/20 border border-border rounded-2xl px-5 py-4 outline-none focus:border-primary transition-all font-bold" />
                  </div>
                  <div className="space-y-2">
                    <label className="text-xs font-black text-secondary uppercase tracking-widest opacity-60">Horarios</label>
                    <input type="text" value={formData.businessHours} onChange={(e) => setFormData({...formData, businessHours: e.target.value})} placeholder="Ej: L-V 8am-6pm" className="w-full bg-muted/20 border border-border rounded-2xl px-5 py-4 outline-none focus:border-primary transition-all font-bold" />
                  </div>
                </div>

                <div className="pt-8 flex justify-between">
                  <button onClick={() => setStep(1)} className="flex items-center gap-2 text-sm font-bold text-muted-foreground hover:text-secondary group">
                    <ArrowLeft size={18} className="transition-transform group-hover:-translate-x-1" /> Atrás
                  </button>
                  <Button type="button" onClick={() => setStep(3)} className="px-12 h-14 rounded-2xl gap-3 font-black shadow-xl shadow-primary/20">
                    Continuar <ArrowRight size={20} />
                  </Button>
                </div>
              </div>
            </motion.form>
          )}

          {/* STEP 3: Multimedia y Descripción (Now with dynamic limit) */}
          {step === 3 && (
            <motion.form 
              key="step3" initial={{ opacity: 0, x: 20 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -20 }}
              className="p-8 md:p-12 space-y-8"
            >
              <div className="mb-8">
                <h2 className="text-3xl font-black text-secondary tracking-tighter uppercase italic">3. Galería y Contenido</h2>
                <div className="flex items-center gap-2 bg-primary/10 px-4 py-2 rounded-xl border border-primary/20 w-fit mt-3">
                   <ShieldCheck size={16} className="text-primary" />
                   <span className="text-[10px] font-black uppercase text-secondary">Plan {selectedPlan.name}: Máximo {currentLimit} Foto(s)</span>
                </div>
              </div>

              <div className="space-y-6">
                <div className="space-y-2">
                  <label className="text-xs font-black text-secondary uppercase tracking-widest opacity-60">Descripción del Servicio</label>
                  <textarea rows="4" required value={formData.description} onChange={(e) => setFormData({...formData, description: e.target.value})} placeholder="Describe qué ofreces..." className="w-full bg-muted/20 border border-border rounded-2xl px-5 py-4 outline-none focus:border-primary transition-all font-medium resize-none shadow-inner" />
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div className="space-y-2">
                    <label className="text-xs font-black text-secondary uppercase tracking-widest opacity-60">Rango de Precios</label>
                    <div className="relative">
                      <input type="text" value={formData.priceRange} onChange={(e) => setFormData({...formData, priceRange: e.target.value})} placeholder="Ej: $50.000 - $200.000" className="w-full bg-muted/20 border border-border rounded-2xl px-5 py-4 pl-12 outline-none focus:border-primary transition-all font-bold" />
                      <DollarSign size={18} className="absolute left-5 top-1/2 -translate-y-1/2 text-primary" />
                    </div>
                  </div>
                  <div className="space-y-2">
                    <label className="text-xs font-black text-secondary uppercase tracking-widest opacity-60">Información de Entrega</label>
                    <div className="relative">
                      <input type="text" value={formData.deliveryInfo} onChange={(e) => setFormData({...formData, deliveryInfo: e.target.value})} placeholder="Ej: Domicilios a toda la ciudad" className="w-full bg-muted/20 border border-border rounded-2xl px-5 py-4 pl-12 outline-none focus:border-primary transition-all font-bold" />
                      <Truck size={18} className="absolute left-5 top-1/2 -translate-y-1/2 text-primary" />
                    </div>
                  </div>
                </div>

                <div className="space-y-4">
                  <label className="text-xs font-black text-secondary uppercase tracking-widest opacity-60">Fotos del Negocio</label>
                  <div className="grid grid-cols-2 sm:grid-cols-5 gap-4">
                    {images.map((img, i) => (
                      <div key={i} className="aspect-square rounded-2xl bg-muted overflow-hidden relative border border-border group">
                        <img src={URL.createObjectURL(img)} className="w-full h-full object-cover transition-transform group-hover:scale-110" />
                        <button onClick={() => setImages(images.filter((_, idx) => idx !== i))} className="absolute top-2 right-2 bg-black/60 text-white rounded-full p-1.5 hover:bg-red-500 transition-colors"> <Tag size={12} /> </button>
                      </div>
                    ))}
                    {images.length < currentLimit && (
                      <label className="aspect-square rounded-2xl border-2 border-dashed border-border/50 hover:border-primary flex flex-col items-center justify-center cursor-pointer transition-all hover:bg-primary/5">
                        <Camera size={24} className="text-primary mb-1" />
                        <span className="text-[9px] font-black text-muted-foreground uppercase tracking-widest">Añadir</span>
                        <input type="file" multiple accept="image/*" onChange={handleImageChange} className="hidden" />
                      </label>
                    )}
                  </div>
                </div>

                <div className="pt-8 flex justify-between">
                  <button onClick={() => setStep(2)} className="flex items-center gap-2 text-sm font-bold text-muted-foreground hover:text-secondary group">
                    <ArrowLeft size={18} className="transition-transform group-hover:-translate-x-1" /> Atrás
                  </button>
                  <Button type="button" onClick={() => setStep(4)} className="px-12 h-14 rounded-2xl gap-3 font-black shadow-xl shadow-primary/20">
                    Continuar <ArrowRight size={20} />
                  </Button>
                </div>
              </div>
            </motion.form>
          )}

          {/* STEP 4: Canales de Contacto */}
          {step === 4 && (
            <motion.form 
              key="step4" initial={{ opacity: 0, x: 20 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -20 }}
              className="p-8 md:p-12 space-y-8"
            >
              <div className="mb-8">
                <h2 className="text-3xl font-black text-secondary tracking-tighter uppercase italic">4. Contacto y Redes</h2>
                <p className="text-muted-foreground mt-1 font-medium">¿Cómo te contactarán tus clientes?</p>
              </div>

              <div className="space-y-6">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div className="space-y-2">
                    <label className="text-xs font-black text-secondary uppercase tracking-widest opacity-60">WhatsApp / Celular</label>
                    <div className="relative">
                      <input type="text" value={formData.cellphone} onChange={(e) => setFormData({...formData, cellphone: e.target.value})} placeholder="312 456 7890" className="w-full bg-muted/20 border border-border rounded-2xl px-5 py-4 pl-12 outline-none focus:border-primary font-bold" />
                      <Smartphone size={18} className="absolute left-5 top-1/2 -translate-y-1/2 text-primary" />
                    </div>
                  </div>
                  <div className="space-y-2">
                    <label className="text-xs font-black text-secondary uppercase tracking-widest opacity-60">Teléfono Fijo</label>
                    <div className="relative">
                      <input type="text" value={formData.phone} onChange={(e) => setFormData({...formData, phone: e.target.value})} placeholder="7 456 7890" className="w-full bg-muted/20 border border-border rounded-2xl px-5 py-4 pl-12 outline-none focus:border-primary font-bold" />
                      <Phone size={18} className="absolute left-5 top-1/2 -translate-y-1/2 text-primary" />
                    </div>
                  </div>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div className="space-y-2">
                    <label className="text-xs font-black text-secondary uppercase tracking-widest opacity-60">Correo Electrónico</label>
                    <div className="relative">
                      <input type="email" value={formData.email} onChange={(e) => setFormData({...formData, email: e.target.value})} placeholder="contacto@tunegocio.com" className="w-full bg-muted/20 border border-border rounded-2xl px-5 py-4 pl-12 outline-none focus:border-primary font-bold" />
                      <Mail size={18} className="absolute left-5 top-1/2 -translate-y-1/2 text-primary" />
                    </div>
                  </div>
                  <div className="space-y-2">
                     <label className="text-xs font-black text-secondary uppercase tracking-widest opacity-60">Sitio Web</label>
                     <div className="relative">
                        <input type="url" value={formData.websiteUrl} onChange={(e) => setFormData({...formData, websiteUrl: e.target.value})} placeholder="tusitio.com" className="w-full bg-muted/20 border border-border rounded-2xl px-5 py-4 pl-12 outline-none focus:border-primary font-bold" />
                        <Globe size={18} className="absolute left-5 top-1/2 -translate-y-1/2 text-primary" />
                     </div>
                  </div>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div className="space-y-2">
                    <label className="text-xs font-black text-secondary uppercase tracking-widest opacity-60">Instagram</label>
                    <div className="relative">
                      <input type="text" value={formData.instagramUrl} onChange={(e) => setFormData({...formData, instagramUrl: e.target.value})} placeholder="@tunegocio" className="w-full bg-muted/20 border border-border rounded-2xl px-5 py-4 pl-12 outline-none focus:border-pink-500 font-bold" />
                      <Camera size={18} className="absolute left-5 top-1/2 -translate-y-1/2 text-pink-600" />
                    </div>
                  </div>
                  <div className="space-y-2">
                    <label className="text-xs font-black text-secondary uppercase tracking-widest opacity-60">Facebook</label>
                    <div className="relative">
                      <input type="text" value={formData.facebookUrl} onChange={(e) => setFormData({...formData, facebookUrl: e.target.value})} placeholder="facebook.com/tunegocio" className="w-full bg-muted/20 border border-border rounded-2xl px-5 py-4 pl-12 outline-none focus:border-blue-500 font-bold" />
                      <Share2 size={18} className="absolute left-5 top-1/2 -translate-y-1/2 text-blue-600" />
                    </div>
                  </div>
                </div>

                <div className="space-y-2">
                  <label className="text-xs font-black text-secondary uppercase tracking-widest opacity-60">Plan Seleccionado</label>
                  <div className="w-full bg-secondary text-white rounded-2xl px-5 py-4 flex items-center justify-between font-black italic shadow-lg">
                    <span>PLAN {selectedPlan.name.toUpperCase()}</span>
                    <span>{selectedPlan.priceLabel}</span>
                  </div>
                </div>

                <div className="bg-primary/5 border border-primary/10 p-5 rounded-[2rem] flex items-center justify-between">
                   <div className="flex items-center gap-3">
                      <Tag size={20} className="text-primary" />
                      <span className="text-xs font-black text-secondary uppercase italic">Destacar como Oferta Especial</span>
                   </div>
                   <input type="checkbox" checked={formData.isOffer} onChange={(e) => setFormData({...formData, isOffer: e.target.checked})} className="w-6 h-6 accent-primary" />
                </div>

                <div className="pt-8 flex justify-between gap-4">
                  <button onClick={() => setStep(3)} className="flex items-center gap-2 text-sm font-bold text-muted-foreground hover:text-secondary group px-4">
                    <ArrowLeft size={18} className="transition-transform group-hover:-translate-x-1" /> Atrás
                  </button>
                  <Button onClick={handleSubmit} disabled={loading || isLimitExceeded} className="flex-1 max-w-[300px] h-16 rounded-2xl font-black shadow-2xl shadow-primary/20 hover:scale-[1.03] transition-all">
                    {loading ? 'Procesando...' : 'Finalizar y Publicar'} <Send size={20} className="ml-3" />
                  </Button>
                </div>
              </div>
            </motion.form>
          )}

          {/* STEP 5: Success Screen */}
          {step === 5 && (
            <motion.div key="step5" initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }} className="p-16 text-center">
              <div className="w-24 h-24 bg-green-100 text-green-600 rounded-full flex items-center justify-center mx-auto mb-8 shadow-2xl"> <CheckCircle2 size={48} strokeWidth={2.5} /> </div>
              <h1 className="text-5xl font-black text-secondary tracking-tighter mb-4 italic">¡Súper!</h1>
              <p className="text-muted-foreground max-w-sm mx-auto mb-12 font-bold text-lg leading-tight"> Tu anuncio está siendo revisado y pronto estará brillando en KLICUS. </p>
              <div className="flex flex-col sm:flex-row gap-4 justify-center">
                 <Button onClick={() => window.location.href = '/'} variant="outline" className="px-12 h-14 rounded-2xl font-black border-border border-2"> Ir al Inicio </Button>
                 <Button onClick={() => window.location.href = '/dashboard'} className="px-12 h-14 rounded-2xl font-black shadow-xl shadow-primary/20"> Ver mis anuncios </Button>
              </div>
            </motion.div>
          )}

        </AnimatePresence>
      </div>
    </div>
  );
}
