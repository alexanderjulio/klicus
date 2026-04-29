'use client';

import { useState, useEffect } from 'react';
import { useRouter, useParams } from 'next/navigation';
import { 
  ArrowLeft, Save, Trash2, Image as ImageIcon, 
  MapPin, Clock, Smartphone, Globe, Mail, Truck,
  AlertTriangle, Check, ShieldCheck,
  ChevronRight, Info, PlusCircle
} from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import Link from 'next/link';
import { cn } from '@/lib/utils';

// UNIVERSAL COLOMBIA CITIES DATABASE (Embedded to guarantee availability)
const COLOMBIA_DATABASE = [
  {"d":"Amazonas","c":["Leticia","Puerto Nariño"]},
  {"d":"Antioquia","c":["Abejorral","Abriaquí","Alejandría","Amagá","Amalfi","Andes","Angelópolis","Angostura","Anorí","Anzá","Apartadó","Arboletes","Argelia","Armenia","Barbosa","Bello","Belmira","Betania","Betulia","Briceño","Buriticá","Cáceres","Caicedo","Caldas","Campamento","Cañasgordas","Caracolí","Caramanta","Carepa","Carolina del Príncipe","Caucasia","Chigorodó","Cisneros","Ciudad Bolívar","Cocorná","Concepción","Concordia","Copacabana","Dabeiba","Donmatías","Ebéjico","El Bagre","El Carmen de Viboral","El Peñol","El Retiro","El Santuario","Entrerríos","Envigado","Fredonia","Frontino","Giraldo","Girardota","Gómez Plata","Granada","Guadalupe","Guarne","Guatapé","Heliconia","Hispania","Itagüí","Ituango","Jardín","Jericó","La Ceja","La Estrella","La Pintada","La Unión","Liborina","Maceo","Marinilla","Medellín","Montebello","Murindó","Mutatá","Nariño","Nechí","Necoclí","Olaya","Peque","Pueblorrico","Puerto Berrío","Puerto Nare","Puerto Triunfo","Remedios","Rionegro","Sabanalarga","Sabaneta","Salgar","San Andrés de Cuerquia","San Carlos","San Francisco","San Jerónimo","San José de la Montaña","San Juan de Urabá","San Luis","San Pedro de Urabá","San Pedro de los Milagros","San Rafael","San Roque","San Vicente","Santa Bárbara","Santa Fe de Antioquia","Santa Rosa de Osos","Santo Domingo","Segovia","Sonsón","Sopetrán","Támesis","Tarazá","Tarso","Titiribí","Toledo","Turbo","Uramita","Urrao","Valdivia","Valparaíso","Vegachí","Venecia","Vigía del Fuerte","Yalí","Yarumal","Yolombó","Yondó","Zaragoza"]},
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
  {"d":"Valle del Cauca","c":["Alcalá","Andalucía","Ansermanuevo","Argelia","Bolívar","Buenaventura","Buga","Bugalagrande","Caicedonia","Cali","Calima","Candelaria","Cartago","Dagua","El Cairo","El Cerrito","El Dovio","Florida","Ginebra","Guacarí","Jamundí","La Cumbre","La Unión","La Victoria","Obando","Palmira","Pradera","Restrepo","Riofrío","Roldanillo","San Pedro","Sevilla","Toro","Trujillo","Tuluá","Ulloa","Versalles","Vijes","Yotoco","Yumbo","Zarzal"]},
  {"d":"Vaupés","c":["Carurú","Mitú","Taraira"]},
  {"d":"Vichada","c":["Cumaribo","La Primavera","Puerto Carreño","Santa Rosalía"]}
];

const ALL_CITIES_FLAT = COLOMBIA_DATABASE.flatMap(dept => 
  dept.c.map(city => `${city}, ${dept.d}`)
);

const normalizeText = (text) => 
  (text || "").normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase();

export default function EditAdPage() {
  const router = useRouter();
  const { id } = useParams();
  
  const [formData, setFormData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [message, setMessage] = useState('');
  const [showCities, setShowCities] = useState(false);
  const [showDeleteConfirm, setShowDeleteConfirm] = useState(false);
  const [isDeleting, setIsDeleting] = useState(false);
  const [images, setImages] = useState([]);

  useEffect(() => {
    async function fetchAd() {
      try {
        const res = await fetch(`/api/pautas/${id}`);
        const json = await res.json();
        const data = json.data || json;
        setFormData(data);
        setImages(data.image_urls || []);
      } catch (error) {
        console.error('Error fetching ad:', error);
      } finally {
        setLoading(false);
      }
    }
    fetchAd();
  }, [id]);

  const handleSubmit = async (e) => {
    if (e) e.preventDefault();
    setSaving(true);
    try {
      const data = new FormData();
      
      // Add all text fields
      Object.keys(formData).forEach(key => {
        if (key !== 'image_urls') {
          data.append(key, formData[key]);
        }
      });

      // Split images into existing (strings) and new (Files)
      const existingImages = images.filter(img => typeof img === 'string');
      const newFiles = images.filter(img => typeof img !== 'string');

      data.append('existingImages', JSON.stringify(existingImages));
      newFiles.forEach(file => data.append('images', file));

      const res = await fetch(`/api/pautas/${id}`, {
        method: 'PUT',
        body: data,
      });
      const result = await res.json();
      if (result.success) {
        setMessage('✨ Cambios guardados con éxito');
        setTimeout(() => router.push('/dashboard'), 1500);
      } else {
        setMessage('❌ ' + (result.error || 'Error al guardar'));
      }
    } catch (error) {
      console.error('Error updating ad:', error);
      setMessage('❌ Error al guardar');
    } finally {
      setSaving(false);
    }
  };

  const handleImageChange = (e) => {
    const files = Array.from(e.target.files);
    const priority = formData.priority_level || 'basic';
    const LIMITS = { basic: 1, pro: 3, diamond: 5 };
    const maxAllowed = LIMITS[priority] || 1;

    if (images.length + files.length > maxAllowed) {
      setMessage(`⚠️ Tu plan ${priority.toUpperCase()} permite máx ${maxAllowed} fotos`);
      return;
    }
    setImages([...images, ...files]);
  };

  const removeImage = (index) => {
    setImages(images.filter((_, i) => i !== index));
  };

  const getImageSrc = (img) => {
    if (typeof img === 'string') return img;
    try {
      return URL.createObjectURL(img);
    } catch (e) {
      return '';
    }
  };

  const handleDelete = async () => {
    setIsDeleting(true);
    try {
      const res = await fetch(`/api/pautas/${id}`, { method: 'DELETE' });
      if (res.ok) {
        setMessage('🗑️ Pauta eliminada correctamente');
        setTimeout(() => router.push('/dashboard'), 1500);
      }
    } catch (error) { 
      console.error(error);
      setMessage('❌ Error al eliminar');
      setIsDeleting(false);
    }
  };

  if (loading) return (
    <div className="min-h-screen bg-[#F5F5F7] flex items-center justify-center">
      <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
    </div>
  );

  if (!formData) return <div>No se encontró la pauta.</div>;

  return (
    <div className="min-h-screen bg-[#F5F5F7] pb-24">
      {/* ELITE SUB-HEADER (Sticky) */}
      <nav className="sticky top-0 z-40 bg-white/80 backdrop-blur-xl border-b border-border/40 px-6 py-4">
        <div className="max-w-7xl mx-auto flex items-center justify-between">
            <div className="flex items-center gap-4">
               <button onClick={() => router.back()} className="p-2 hover:bg-muted rounded-full transition-colors">
                  <ArrowLeft size={20} className="text-secondary" />
               </button>
               <div>
                  <div className="flex items-center gap-2 mb-0.5">
                    <span className="text-[10px] font-black uppercase tracking-[0.2em] text-primary italic">Dashboard</span>
                    <ChevronRight size={10} className="text-muted-foreground" />
                    <span className="text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground">Editar Pauta</span>
                  </div>
                  <h1 className="text-lg font-black tracking-tighter text-secondary italic">{formData.title}</h1>
               </div>
            </div>

            <button 
              form="edit-form"
              disabled={saving}
              className={cn(
                "px-8 py-2.5 bg-[#0E2244] text-white rounded-full text-xs font-black uppercase tracking-widest shadow-xl transition-all active:scale-95 flex items-center gap-2",
                saving && "opacity-50 animate-pulse"
              )}
            >
              {saving ? 'Guardando...' : <><Save size={14} className="text-primary" /> Guardar Cambios</>}
            </button>
        </div>
      </nav>

      <main className="max-w-5xl mx-auto pt-16 px-6">
        {/* Verification Warning */}
        <motion.div 
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          className="mb-12 p-6 bg-[#0E2244] text-white rounded-[2.5rem] flex items-center gap-6 shadow-2xl relative overflow-hidden"
        >
          <div className="w-14 h-14 rounded-2xl bg-primary/20 flex items-center justify-center shrink-0 border border-primary/20">
            <ShieldCheck size={28} className="text-primary" />
          </div>
          <div className="flex-1">
             <h4 className="text-sm font-black uppercase tracking-widest text-primary mb-1 italic">Protocolo de Verificación</h4>
             <p className="text-xs font-medium text-white/60 leading-relaxed max-w-2xl">
                Al guardar, tu pauta entrará en estado <span className="text-primary font-bold underline">pendiente de verificación administrativa</span> para asegurar la calidad del directorio. Este proceso toma menos de 2 horas.
             </p>
          </div>
          <div className="absolute -right-10 -bottom-10 w-40 h-40 bg-primary/5 rounded-full blur-3xl pointer-events-none" />
        </motion.div>

        <form id="edit-form" onSubmit={handleSubmit} className="grid grid-cols-1 lg:grid-cols-12 gap-10">
          
          {/* Main Controls (8 cols) */}
          <div className="lg:col-span-8 space-y-8">
            {/* Galería de Imágenes Section */}
            <section className="bg-white rounded-[3rem] p-10 border border-white shadow-2xl shadow-secondary/5">
              <div className="flex items-center gap-4 mb-8">
                <div className="w-10 h-10 rounded-xl bg-orange-500/10 flex items-center justify-center">
                  <ImageIcon size={20} className="text-orange-500" />
                </div>
                <div>
                  <h3 className="text-xl font-black italic tracking-tighter">Galería del Negocio</h3>
                  <p className="text-[10px] font-bold text-secondary/40 uppercase tracking-widest mt-1">Plan {formData.priority_level?.toUpperCase()}</p>
                </div>
              </div>

              <div className="grid grid-cols-2 sm:grid-cols-4 gap-4 mb-8">
                {images.map((img, i) => (
                  <div key={i} className="aspect-square rounded-2xl bg-muted overflow-hidden relative border border-border group">
                    <img 
                      src={getImageSrc(img)} 
                      className="w-full h-full object-cover transition-transform group-hover:scale-110" 
                    />
                    <button 
                      type="button"
                      onClick={() => removeImage(i)}
                      className="absolute top-2 right-2 bg-black/60 text-white rounded-full p-1.5 hover:bg-red-500 transition-colors"
                    > 
                      <Trash2 size={12} /> 
                    </button>
                  </div>
                ))}

                {images.length < ({ basic: 1, pro: 3, diamond: 5 }[formData.priority_level] || 1) && (
                  <label className="aspect-square rounded-2xl border-2 border-dashed border-border/50 hover:border-primary flex flex-col items-center justify-center cursor-pointer transition-all hover:bg-primary/5">
                    <PlusCircle size={24} className="text-primary mb-1 shadow-sm" />
                    <span className="text-[9px] font-black text-muted-foreground uppercase tracking-widest">Añadir</span>
                    <input 
                      type="file" 
                      multiple 
                      accept="image/*" 
                      onChange={handleImageChange} 
                      className="hidden" 
                    />
                  </label>
                )}
              </div>
            </section>

            {/* 1. SECCION IDENTIDAD */}
            <section className="bg-white rounded-[3rem] p-10 border border-white shadow-2xl shadow-secondary/5">
              <div className="flex items-center gap-4 mb-10">
                <div className="w-10 h-10 rounded-xl bg-primary/10 flex items-center justify-center">
                   <Info size={20} className="text-primary" />
                </div>
                <h3 className="text-xl font-black italic tracking-tighter">Identidad Visual y Contenido</h3>
              </div>

              <div className="space-y-8">
                <div className="group">
                  <label className="text-[10px] font-black uppercase tracking-[0.2em] text-secondary/30 ml-2 mb-3 block group-focus-within:text-primary transition-colors">Título del Negocio</label>
                  <input 
                    type="text" 
                    value={formData.title} 
                    onChange={(e) => setFormData({...formData, title: e.target.value})}
                    placeholder="Nombre comercial"
                    className="w-full h-14 px-6 rounded-xl bg-[#F5F5F7] border border-border/40 focus:border-primary outline-none font-bold"
                  />
                </div>

                <div className="group">
                  <label className="text-[10px] font-black uppercase tracking-[0.2em] text-secondary/30 ml-2 mb-3 block group-focus-within:text-primary transition-colors">Descripción del Servicio</label>
                  <textarea 
                    value={formData.description} 
                    onChange={(e) => setFormData({...formData, description: e.target.value})}
                    rows={4}
                    placeholder="Cuéntanos más sobre lo que ofreces..."
                    className="w-full p-6 rounded-xl bg-[#F5F5F7] border border-border/40 focus:border-primary outline-none font-bold resize-none"
                  />
                </div>
              </div>
            </section>

            {/* 2. SECCION UBICACION Y PRECIOS */}
            <section className="grid grid-cols-1 md:grid-cols-2 gap-8">
               <div className="bg-white rounded-[3rem] p-10 border border-white shadow-2xl shadow-secondary/5">
                  <h3 className="text-xs font-black uppercase tracking-widest mb-8 flex items-center gap-2 text-secondary/40">
                    <MapPin size={16} /> Ubicación
                  </h3>
                  <div className="space-y-6">
                    <div className="relative group/city">
                      <input 
                        type="text" 
                        value={formData.location || ''} 
                        onChange={(e) => setFormData({...formData, location: e.target.value})}
                        onFocus={() => setShowCities(true)}
                        onBlur={() => setTimeout(() => setShowCities(false), 200)}
                        placeholder="Ciudad o Zona"
                        className="w-full h-14 px-6 rounded-xl bg-[#F5F5F7] border border-border/40 focus:border-primary outline-none font-bold"
                      />
                      {showCities && (
                        <div 
                          className="absolute top-full left-0 right-0 mt-2 bg-white rounded-2xl shadow-2xl border border-border/40 z-[9999] overflow-hidden max-h-72 overflow-y-auto"
                          style={{ minWidth: '100%', boxShadow: '0 25px 50px -12px rgba(0, 0, 0, 0.25)' }}
                        >
                          <div className="p-3 bg-muted/20 border-b border-border/30 text-[9px] font-black uppercase tracking-widest text-secondary/40 flex justify-between items-center">
                            <span>Municipios de Colombia</span>
                            <span className="text-[8px] opacity-40">{ALL_CITIES_FLAT.length} cargados</span>
                          </div>
                          {ALL_CITIES_FLAT
                            .filter(city => normalizeText(city).includes(normalizeText(formData.location)))
                            .slice(0, 10)
                            .map(match => (
                            <button
                              key={match}
                              type="button"
                              onMouseDown={() => {
                                setFormData({...formData, location: match});
                                setShowCities(false);
                              }}
                              className="w-full text-left px-6 py-3.5 text-xs font-bold hover:bg-primary/10 transition-colors flex items-center justify-between group"
                            >
                              {match}
                              <span className="text-[9px] opacity-0 group-hover:opacity-100 transition-opacity uppercase tracking-widest text-primary font-black">Seleccionar</span>
                            </button>
                          ))}
                          {(formData.location || '').length > 0 && ALL_CITIES_FLAT.filter(city => normalizeText(city).includes(normalizeText(formData.location))).length === 0 && (
                            <div className="px-6 py-4 bg-primary/5 border-t border-primary/10 text-[10px] font-bold italic text-secondary/40">
                               No se encontró "{formData.location}" en la base nacional. Se guardará como zona personalizada.
                            </div>
                          )}
                        </div>
                      )}
                    </div>
                    <input 
                      type="text" 
                      value={formData.address} 
                      onChange={(e) => setFormData({...formData, address: e.target.value})}
                      placeholder="Dirección Física Exacta"
                      className="w-full h-14 px-6 rounded-xl bg-[#F5F5F7] border border-border/40 focus:border-primary outline-none font-bold"
                    />
                  </div>
               </div>

               <div className="bg-white rounded-[3rem] p-10 border border-white shadow-2xl shadow-secondary/5">
                  <h3 className="text-xs font-black uppercase tracking-widest mb-8 flex items-center gap-2 text-secondary/40">
                    <Truck size={16} /> Logística y Costos
                  </h3>
                  <div className="space-y-6">
                    <div className="group">
                      <label className="text-[9px] font-black uppercase tracking-widest text-secondary/30 ml-2 mb-2 block">Rango de Precios</label>
                      <input 
                        type="text" 
                        value={formData.price_range} 
                        onChange={(e) => setFormData({...formData, price_range: e.target.value})}
                        placeholder="Ej: $20.000 - $50.000"
                        className="w-full h-14 px-6 rounded-xl bg-[#F5F5F7] border border-border/40 focus:border-primary outline-none font-bold"
                      />
                    </div>
                    <div className="group">
                      <label className="text-[9px] font-black uppercase tracking-widest text-secondary/30 ml-2 mb-2 block">Info Domicilios</label>
                      <input 
                        type="text" 
                        value={formData.delivery_info} 
                        onChange={(e) => setFormData({...formData, delivery_info: e.target.value})}
                        placeholder="Ej: Domicilios gratis en el centro"
                        className="w-full h-14 px-6 rounded-xl bg-[#F5F5F7] border border-border/40 focus:border-primary outline-none font-bold"
                      />
                    </div>
                  </div>
               </div>
            </section>

            {/* 3. SECCION CONTACTO ELITE */}
            <section className="bg-white rounded-[3rem] p-10 border border-white shadow-2xl shadow-secondary/5">
               <div className="flex items-center gap-4 mb-10">
                  <div className="w-10 h-10 rounded-xl bg-green-500/10 flex items-center justify-center">
                     <Smartphone size={20} className="text-green-600" />
                  </div>
                  <h3 className="text-xl font-black italic tracking-tighter">Canal de Ventas y Social</h3>
               </div>

               <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
                  <div className="space-y-6">
                    <div className="group">
                       <label className="text-[9px] font-black uppercase tracking-widest text-secondary/30 ml-2 mb-2 block">WhatsApp de Ventas</label>
                       <div className="relative">
                          <input 
                            type="text" 
                            value={formData.cellphone} 
                            onChange={(e) => setFormData({...formData, cellphone: e.target.value})}
                            className="w-full h-14 pl-12 pr-6 rounded-xl bg-[#F5F5F7] border border-border/40 focus:border-primary outline-none font-bold"
                          />
                          <Smartphone size={16} className="absolute left-4 top-1/2 -translate-y-1/2 text-secondary/40" />
                       </div>
                    </div>
                    <div className="group">
                       <label className="text-[9px] font-black uppercase tracking-widest text-secondary/30 ml-2 mb-2 block">Instagram (Puro texto del perfil)</label>
                       <div className="relative">
                          <input 
                            type="text" 
                            value={formData.instagram_url} 
                            onChange={(e) => setFormData({...formData, instagram_url: e.target.value})}
                            placeholder="@tunegocio"
                            className="w-full h-14 pl-12 pr-6 rounded-xl bg-[#F5F5F7] border border-border/40 focus:border-primary outline-none font-bold"
                          />
                          <div className="absolute left-4 top-1/2 -translate-y-1/2">
                             <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="text-secondary/40"><rect x="2" y="2" width="20" height="20" rx="5" ry="5"></rect><path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z"></path><line x1="17.5" y1="6.5" x2="17.51" y2="6.5"></line></svg>
                          </div>
                       </div>
                    </div>
                  </div>
                  <div className="space-y-6">
                    <div className="group">
                       <label className="text-[9px] font-black uppercase tracking-widest text-secondary/30 ml-2 mb-2 block">Website Corporativo</label>
                       <div className="relative">
                          <input 
                            type="text" 
                            value={formData.website_url} 
                            onChange={(e) => setFormData({...formData, website_url: e.target.value})}
                            placeholder="https://www.tuweb.com"
                            className="w-full h-14 pl-12 pr-6 rounded-xl bg-[#F5F5F7] border border-border/40 focus:border-primary outline-none font-bold"
                          />
                          <Globe size={16} className="absolute left-4 top-1/2 -translate-y-1/2 text-secondary/40" />
                       </div>
                    </div>
                    <div className="group">
                       <label className="text-[9px] font-black uppercase tracking-widest text-secondary/30 ml-2 mb-2 block">Email de Negocio</label>
                       <div className="relative">
                          <input 
                            type="text" 
                            value={formData.email} 
                            onChange={(e) => setFormData({...formData, email: e.target.value})}
                            className="w-full h-14 pl-12 pr-6 rounded-xl bg-[#F5F5F7] border border-border/40 focus:border-primary outline-none font-bold"
                          />
                          <Mail size={16} className="absolute left-4 top-1/2 -translate-y-1/2 text-secondary/40" />
                       </div>
                    </div>
                  </div>
               </div>
            </section>
          </div>

          {/* Right Sidebar (4 cols) */}
          <div className="lg:col-span-4 space-y-8">
             <section className="bg-white rounded-[3rem] p-10 border border-white shadow-2xl shadow-secondary/5">
                <h3 className="text-xs font-black uppercase tracking-widest mb-8 text-secondary/40">Configuración</h3>
                
                <div className="space-y-6">
                   <div className="flex items-center justify-between p-4 rounded-2xl bg-[#F5F5F7]">
                      <div className="flex items-center gap-3">
                         <div className="w-8 h-8 rounded-lg bg-red-100 flex items-center justify-center">
                            <AlertTriangle size={16} className="text-red-500" />
                         </div>
                         <span className="text-xs font-bold text-secondary">¿Oferta Especial?</span>
                      </div>
                      <input 
                        type="checkbox" 
                        checked={formData.is_offer}
                        onChange={(e) => setFormData({...formData, is_offer: e.target.checked})}
                        className="w-6 h-6 accent-primary"
                      />
                   </div>

                   <button 
                     type="button"
                     onClick={() => setShowDeleteConfirm(true)}
                     className="w-full py-4 text-[10px] font-black uppercase tracking-widest text-red-500 border-2 border-red-500/10 rounded-2xl hover:bg-red-500 hover:text-white transition-all flex items-center justify-center gap-2 group"
                   >
                     <Trash2 size={14} className="group-hover:scale-110 transition-transform" /> Eliminar Anuncio
                   </button>
                </div>
             </section>

             <section className="bg-white rounded-[3rem] p-10 border border-white shadow-2xl shadow-secondary/5">
                <div className="flex items-center justify-between mb-8">
                   <h3 className="text-xs font-black uppercase tracking-widest text-secondary/40">Horarios</h3>
                   <Clock size={16} className="text-primary" />
                </div>
                <input 
                  type="text" 
                  value={formData.business_hours} 
                  onChange={(e) => setFormData({...formData, business_hours: e.target.value})}
                  placeholder="Ej: Lunes a Sábado 8am - 6pm"
                  className="w-full h-14 px-6 rounded-xl bg-[#F5F5F7] border border-border/40 focus:border-primary outline-none font-bold"
                />
             </section>
          </div>
        </form>
      </main>

      {/* Persistence Message */}
      <AnimatePresence>
        {message && (
          <motion.div 
            initial={{ opacity: 0, scale: 0.9, y: 20 }}
            animate={{ opacity: 1, scale: 1, y: 0 }}
            exit={{ opacity: 0, scale: 0.9, y: 20 }}
            className="fixed bottom-10 left-1/2 -translate-x-1/2 bg-secondary text-white px-8 py-4 rounded-full font-bold shadow-2xl z-[100] flex items-center gap-3 border border-white/10"
          >
            <Check size={18} className="text-primary" />
            {message}
          </motion.div>
        )}
      </AnimatePresence>

      {/* Premium Delete Confirmation Modal */}
      <AnimatePresence>
        {showDeleteConfirm && (
          <div className="fixed inset-0 z-[100] flex items-center justify-center p-6">
            <motion.div 
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              onClick={() => setShowDeleteConfirm(false)}
              className="absolute inset-0 bg-secondary/80 backdrop-blur-xl"
            />
            
            <motion.div 
              initial={{ opacity: 0, scale: 0.9, y: 20 }}
              animate={{ opacity: 1, scale: 1, y: 0 }}
              exit={{ opacity: 0, scale: 0.9, y: 20 }}
              className="relative bg-white rounded-[3rem] p-10 md:p-12 max-w-md w-full shadow-2xl border border-white overflow-hidden"
            >
              {/* Decorative Accent */}
              <div className="absolute top-0 right-0 w-32 h-32 bg-red-500/5 rounded-full blur-3xl -translate-y-1/2 translate-x-1/2" />
              
              <div className="flex flex-col items-center text-center space-y-6">
                <div className="w-20 h-20 rounded-3xl bg-red-100 flex items-center justify-center text-red-500 animate-pulse">
                  <AlertTriangle size={40} />
                </div>
                
                <div className="space-y-2">
                  <h3 className="text-2xl font-black italic tracking-tighter text-secondary">¿Eliminar Pauta?</h3>
                  <p className="text-sm text-secondary/40 font-medium leading-relaxed">
                    Esta acción es irreversible. Se eliminarán permanentemente todos los datos, estadísticas y recursos visuales asociados a 
                    <span className="text-secondary font-black"> "{formData.title}"</span>.
                  </p>
                </div>

                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 w-full pt-4">
                  <button 
                    onClick={() => setShowDeleteConfirm(false)}
                    disabled={isDeleting}
                    className="w-full py-5 rounded-2xl bg-[#F5F5F7] text-secondary font-black text-[10px] uppercase tracking-widest hover:bg-secondary hover:text-white transition-all"
                  >
                    Mantener
                  </button>
                  <button 
                    onClick={handleDelete}
                    disabled={isDeleting}
                    className={cn(
                      "w-full py-5 rounded-2xl bg-red-500 text-white font-black text-[10px] uppercase tracking-widest shadow-xl shadow-red-500/20 hover:bg-red-600 transition-all flex items-center justify-center gap-2",
                      isDeleting && "opacity-50 animate-pulse"
                    )}
                  >
                    {isDeleting ? 'Eliminando...' : <>Confirmar</>}
                  </button>
                </div>
              </div>
            </motion.div>
          </div>
        )}
      </AnimatePresence>
    </div>
  );
}
