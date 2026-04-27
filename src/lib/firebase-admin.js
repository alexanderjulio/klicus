import admin from 'firebase-admin';
import { readFileSync } from 'fs';
import { join } from 'path';

if (!admin.apps.length) {
  try {
    let serviceAccount = null;

    if (process.env.FIREBASE_SERVICE_ACCOUNT) {
      // Production: credentials come from environment variable (JSON string en base64 o raw)
      serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
    } else if (process.env.NODE_ENV !== 'production') {
      // Development only: fallback to local file (gitignored, nunca commiteado)
      const filePath = join(process.cwd(), 'config', 'firebase-admin.json');
      serviceAccount = JSON.parse(readFileSync(filePath, 'utf8'));
    }

    if (serviceAccount) {
      admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });
    } else {
      console.warn('FIREBASE_SERVICE_ACCOUNT no configurado. Las notificaciones push no funcionarán.');
    }
  } catch (error) {
    console.warn('Firebase Admin init error:', error.message);
  }
}

export default admin;
