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
    console.log('--- Phase 7 Migration: Notifications Hub ---');
    const connection = await mysql.createConnection(dbConfig);

    try {
        console.log('Creating user_tokens table...');
        await connection.execute(`
            CREATE TABLE IF NOT EXISTS user_tokens (
                id INT AUTO_INCREMENT PRIMARY KEY,
                user_id VARCHAR(255) NOT NULL,
                token TEXT NOT NULL,
                device_type ENUM('android', 'ios', 'web') DEFAULT 'android',
                last_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES profiles(id) ON DELETE CASCADE
            )
        `);
        
        console.log('Migration successful.');
    } catch (error) {
        console.error('Migration failed:', error);
    } finally {
        await connection.end();
    }
}

migrate();
