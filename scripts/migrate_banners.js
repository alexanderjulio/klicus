import mysql from 'mysql2/promise';
import dotenv from 'dotenv';
dotenv.config();

const dbConfig = {
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'klicus_db',
};

async function migrate() {
    console.log('--- Phase 8 Migration: Admin Banner Manager ---');
    const connection = await mysql.createConnection(dbConfig);

    try {
        console.log('Creating banners table...');
        await connection.execute(`
            CREATE TABLE IF NOT EXISTS banners (
                id INT AUTO_INCREMENT PRIMARY KEY,
                title VARCHAR(255) NOT NULL,
                subtitle TEXT,
                image_url TEXT NOT NULL,
                cta_text VARCHAR(100) DEFAULT 'SABER MÁS',
                cta_link VARCHAR(255) DEFAULT '/',
                is_active BOOLEAN DEFAULT TRUE,
                position INT DEFAULT 0,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
            )
        `);

        // Check if data already exists to avoid duplication
        const [rows] = await connection.execute('SELECT COUNT(*) as count FROM banners');
        if (rows[0].count === 0) {
            console.log('Seeding initial banners...');
            const seedBanners = [
                ['Impulsa tu negocio con KLICUS', 'Llega a miles de potenciales clientes con pautas Diamante.', 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&q=80&w=1200', 'PUBLICAR AHORA', '/publicar'],
                ['Encuentra lo mejor de tu ciudad', 'Salud, Gastronomía y Tecnología con calidad verificada.', 'https://images.unsplash.com/photo-1542744094-24638eff58bb?auto=format&fit=crop&q=80&w=1200', 'EXPLORAR', '/'],
                ['Publicidad efectiva y local', 'Únete a la comunidad de emprendedores que están creciendo.', 'https://images.unsplash.com/photo-1551434678-e076c223a692?auto=format&fit=crop&q=80&w=1200', 'COMENZAR', '/']
            ];

            for (const b of seedBanners) {
                await connection.execute(
                    'INSERT INTO banners (title, subtitle, image_url, cta_text, cta_link) VALUES (?, ?, ?, ?, ?)',
                    b
                );
            }
        }
        
        console.log('Migration successful.');
    } catch (error) {
        console.error('Migration failed:', error);
    } finally {
        await connection.end();
    }
}

migrate();
