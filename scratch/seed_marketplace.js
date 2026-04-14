const { query } = require('../src/lib/db');
const crypto = require('crypto');

async function seed() {
  console.log('🚀 Iniciando generación masiva de datos de prueba...');

  try {
    // 1. Limpiar datos previos para evitar duplicados
    await query('DELETE FROM billings');
    await query('DELETE FROM metrics');
    await query('DELETE FROM advertisements');
    await query('DELETE FROM categories');
    await query('DELETE FROM profiles');

    // 2. Crear Perfiles (Propietarios)
    const owners = [
      { id: crypto.randomUUID(), name: 'Carlos Ruiz', biz: 'Dental Shine Bucaramanga', bio: 'Dentista con 15 años de experiencia en estética dental.', role: 'professional' },
      { id: crypto.randomUUID(), name: 'Elena Gómez', biz: 'Gourmet Mediterráneo', bio: 'Cocina de autor en el corazón de la ciudad.', role: 'business' },
      { id: crypto.randomUUID(), name: 'Andrés López', biz: 'TechFix Solutions', bio: 'Reparación express de móviles y portátiles.', role: 'business' },
      { id: crypto.randomUUID(), name: 'Dra. María Paula', biz: 'Clínica Veterinaria El Recreo', bio: 'Cuidamos a tus peludos como si fueran nuestros.', role: 'business' },
      { id: crypto.randomUUID(), name: 'Julián Montoya', biz: 'Montoya Abogados', bio: 'Especialistas en derecho laboral y civil.', role: 'professional' },
      { id: crypto.randomUUID(), name: 'Sofía Castro', biz: 'Fitness Core Gym', bio: 'Entrenamiento funcional y nutrición deportiva.', role: 'business' }
    ];

    for (const owner of owners) {
      await query(`
        INSERT INTO profiles (id, full_name, business_name, bio, role) 
        VALUES (?, ?, ?, ?, ?)
      `, [owner.id, owner.name, owner.biz, owner.bio, owner.role]);
    }

    // 3. Crear Categorías
    const categoriesSet = [
      ['Salud y Bienestar', 'salud', 'Heart'],
      ['Gastronomía', 'gastronomia', 'Utensils'],
      ['Tecnología', 'tecnologia', 'Cpu'],
      ['Servicios Legales', 'legales', 'Scale'],
      ['Deportes', 'deportes', 'Dumbbell'],
      ['Hogar', 'hogar', 'Home'],
      ['Mascotas', 'mascotas', 'Dog'],
      ['Moda', 'moda', 'ShoppingBag']
    ];

    const categoryMap = {};
    for (const [name, slug, icon] of categoriesSet) {
      const result = await query('INSERT INTO categories (name, slug, icon) VALUES (?, ?, ?)', [name, slug, icon]);
      categoryMap[slug] = result.insertId;
    }

    // 4. Crear 20+ Anuncios (Pautas) de forma aleatoria
    const adsData = [
      { title: 'Implantes Dentales 2x1', desc: 'Gran promoción este mes en implantes de alta calidad.', cat: 'salud', priority: 'diamond', price: '$1.2M', loc: 'Bucaramanga, Santander' },
      { title: 'Menú Ejecutivo Gourmet', desc: 'Almuerzos saludables con los mejores ingredientes.', cat: 'gastronomia', priority: 'pro', price: '$25.000', loc: 'Bucaramanga, Cabecera' },
      { title: 'Reparación iPhone Pantalla', desc: 'Cambiamos tu pantalla en 30 minutos con garantía.', cat: 'tecnologia', priority: 'pro', price: 'Desde $150k', loc: 'Bogotá, CC Andino' },
      { title: 'Asesoría Divorcios', desc: 'Trámites rápidos y discretos. Consulta inicial gratuita.', cat: 'legales', priority: 'diamond', price: 'Consultar', loc: 'Cali, Valle' },
      { title: 'Personal Trainer 24/7', desc: 'Logra tus objetivos con rutinas personalizadas.', cat: 'deportes', priority: 'basic', price: '$80k/mes', loc: 'Medellín, Poblado' },
      { title: 'Control Plagas Hogar', desc: 'Eliminamos cucarachas y hormigas con productos certificados.', cat: 'hogar', priority: 'pro', price: 'Desde $120k', loc: 'Barranquilla' },
      { title: 'Peluquería Canina VIP', desc: 'Baño, corte y spa para tu mejor amigo.', cat: 'mascotas', priority: 'pro', price: '$45.000', loc: 'Bucaramanga, El Recreo' },
      { title: 'Moda Sostenible Artística', desc: 'Ropa única hecha a mano con materiales reciclados.', cat: 'moda', priority: 'basic', price: '$90k - $200k', loc: 'Medellín' },
      { title: 'Limpieza Dental Profunda', desc: 'Ultrasonido y profilaxis para una sonrisa perfecta.', cat: 'salud', priority: 'basic', price: '$80.000', loc: 'Bucaramanga' },
      { title: 'Sushi All You Can Eat', desc: 'Los jueves come todo el sushi que quieras por un precio fijo.', cat: 'gastronomia', priority: 'diamond', price: '$65.000', loc: 'Bogotá' },
      { title: 'Marketing Digital Pymes', desc: 'Hacemos crecer tus redes sociales con pauta efectiva.', cat: 'tecnologia', priority: 'pro', price: 'Desde $500k', loc: 'Remoto' },
      { title: 'Yoga para Embarazadas', desc: 'Conecta con tu bebé en un ambiente de paz.', cat: 'salud', priority: 'pro', price: '$30k/clase', loc: 'Cali' },
      { title: 'Diseño de Interiores Jardines', desc: 'Transformamos tu patio en un oasis natural.', cat: 'hogar', priority: 'diamond', price: 'Previa cotización', loc: 'Cartagena' },
      { title: 'Abogado Notarial Express', desc: 'Firmas y autenticaciones en tiempo récord.', cat: 'legales', priority: 'basic', price: 'Consultar', loc: 'Pereira' },
      { title: 'Curso de Natación Niños', desc: 'Clases personalizadas para perder el miedo al agua.', cat: 'deportes', priority: 'pro', price: '$150k/mes', loc: 'Manizales' }
    ];

    for (const ad of adsData) {
      const randomOwner = owners[Math.floor(Math.random() * owners.length)];
      await query(`
        INSERT INTO advertisements (id, owner_id, category_id, title, description, priority_level, status, location, price_range)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
      `, [
        crypto.randomUUID(), 
        randomOwner.id, 
        categoryMap[ad.cat], 
        ad.title, 
        ad.desc, 
        ad.priority, 
        'active', 
        ad.loc, 
        ad.price
      ]);
    }

    console.log('✅ Seeding masivo completado.');
    console.log(`- Categorías creadas: ${categoriesSet.length}`);
    console.log(`- Perfiles creados: ${owners.length}`);
    console.log(`- Anuncios creados: ${adsData.length}`);
  } catch (err) {
    console.error('❌ Error durante el seeding masivo:', err);
  } finally {
    process.exit();
  }
}

seed();
