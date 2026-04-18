import admin from 'firebase-admin';

if (!admin.apps.length) {
  try {
    // We assume the service account JSON is provided via env or a file in a secure path
    // For this implementation, we will check for environment variables first
    const serviceAccount = process.env.FIREBASE_SERVICE_ACCOUNT 
      ? JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT) 
      : null;

    if (serviceAccount) {
      admin.initializeApp({
        credential: admin.credential.cert(serviceAccount),
      });
      console.log('Firebase Admin Initialized from ENV');
    } else {
      console.warn('FIREBASE_SERVICE_ACCOUNT not found. Push notifications will fail.');
    }
  } catch (error) {
    console.error('Firebase Admin Initialization Error:', error);
  }
}

export default admin;
