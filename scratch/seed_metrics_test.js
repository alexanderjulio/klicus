import { query } from '../src/lib/db.js';
import crypto from 'crypto';

async function seedMetrics() {
    console.log('--- Seeding Synthetic Analytics for Integration Test ---');
    
    // Use an existing ad ID from the previous check
    const adId = '09b30f00-769b-487c-8405-5beef0d45611'; 
    const days = 14;

    console.log(`Generating data for Ad: ${adId} for the last ${days} days...`);

    for (let i = 0; i < days; i++) {
        const date = new Date();
        date.setDate(date.getDate() - i);
        const formattedDate = date.toISOString().slice(0, 19).replace('T', ' ');

        // Generate random counts
        const viewsCount = Math.floor(Math.random() * 50) + 10;
        const contactCount = Math.floor(Math.random() * viewsCount * 0.1) + 1;

        console.log(`- Day -${i}: Views: ${viewsCount}, Contacts: ${contactCount}`);

        // Insert Views
        for (let j = 0; j < viewsCount; j++) {
            const ipHash = crypto.createHash('sha256').update(`ip_${i}_${j}`).digest('hex');
            await query(`INSERT INTO metrics (ad_id, event_type, device_type, ip_hash, created_at) VALUES (?, 'view', 'mobile-app', ?, ?)`, 
            [adId, ipHash, formattedDate]);
        }

        // Insert Contacts
        for (let k = 0; k < contactCount; k++) {
            const ipHash = crypto.createHash('sha256').update(`ip_contact_${i}_${k}`).digest('hex');
            await query(`INSERT INTO metrics (ad_id, event_type, device_type, ip_hash, created_at) VALUES (?, 'contact', 'mobile-app', ?, ?)`, 
            [adId, ipHash, formattedDate]);
        }
    }

    console.log('Seeding completed successfully.');
}

seedMetrics().then(() => process.exit(0)).catch(err => {
    console.error(err);
    process.exit(1);
});
