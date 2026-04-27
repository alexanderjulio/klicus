import admin from 'firebase-admin';
import { readFileSync } from 'fs';
import { join } from 'path';

if (!admin.apps.length) {
  try {
    let serviceAccount = null;

    if (process.env.FIREBASE_SERVICE_ACCOUNT_BASE64) {
      // Production: JSON codificado en base64 para evitar problemas con saltos de línea en .env
      const json = Buffer.from(process.env.FIREBASE_SERVICE_ACCOUNT_BASE64, 'base64').toString('utf8');
      serviceAccount = JSON.parse(json);
    } else if (process.env.FIREBASE_SERVICE_ACCOUNT) {
      // Fallback: JSON crudo (solo funciona si el .env escapa correctamente los \n)
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
