import admin from 'firebase-admin';
import { readFileSync } from 'fs';
import { join } from 'path';
import { query } from './db.js';

// Initialize Firebase Admin
let serviceAccount;
try {
  const envConfig = process.env.FIREBASE_SERVICE_ACCOUNT;
  
  if (envConfig) {
    // If provided as a stringified JSON in environment variable
    serviceAccount = JSON.parse(envConfig);
  } else {
    // Fallback to local file
    const jsonPath = join(process.cwd(), 'config', 'firebase-admin.json');
    serviceAccount = JSON.parse(readFileSync(jsonPath, 'utf8'));
  }

  if (!admin.apps.length) {
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount)
    });
    console.log('🔥 [FCM] Firebase Admin SDK Initialized');
  }
} catch (error) {
  if (process.env.NODE_ENV === 'production') {
    console.error('❌ [FCM] Error initializing Firebase Admin:', error.message);
  } else {
    console.warn('⚠️ [FCM] Firebase Admin not initialized (optional for dev):', error.message);
  }
}

/**
 * Send a push notification to a specific user
 * @param {string} userId - UUID of the user
 * @param {object} payload - Notification data { title, body, data, image }
 */
export async function sendPushToUser(userId, payload) {
  try {
    // 1. Fetch tokens for this user
    const tokens = await query('SELECT token FROM user_fcm_tokens WHERE user_id = ?', [userId]);
    
    if (tokens.length === 0) {
      console.log(`[FCM] No tokens found for user ${userId}`);
      return false;
    }

    const tokenList = tokens.map(t => t.token);
    
    const message = {
      notification: {
        title: payload.title,
        body: payload.body,
        ...(payload.image && { imageUrl: payload.image })
      },
      data: payload.data || {},
      tokens: tokenList,
    };

    const response = await admin.messaging().sendEachForMulticast(message);
    console.log(`🚀 [FCM] Sent to ${response.successCount} devices for user ${userId}`);

    // Clean up invalid tokens
    if (response.failureCount > 0) {
      const failedTokens = [];
      response.responses.forEach((resp, idx) => {
        if (!resp.success) {
          failedTokens.push(tokenList[idx]);
        }
      });
      
      if (failedTokens.length > 0) {
        await query('DELETE FROM user_fcm_tokens WHERE token IN (?)', [failedTokens]);
        console.log(`🧹 [FCM] Cleaned up ${failedTokens.length} invalid tokens`);
      }
    }

    return response.successCount > 0;
  } catch (error) {
    console.error('❌ [FCM] sendPushToUser error:', error);
    return false;
  }
}

/**
 * Send a push notification to ALL registered devices (Broadcast)
 */
export async function broadcastPush(payload) {
  try {
    // Fetch all unique tokens (can be many, so we process in chunks if needed)
    // For smaller deployments, a single query is fine.
    const tokens = await query('SELECT DISTINCT token FROM user_fcm_tokens');
    
    if (tokens.length === 0) return false;

    const tokenList = tokens.map(t => t.token);
    
    // FCM multicast limit is 500 tokens at a time
    const CHUNK_SIZE = 500;
    let totalSuccess = 0;

    for (let i = 0; i < tokenList.length; i += CHUNK_SIZE) {
      const chunk = tokenList.slice(i, i + CHUNK_SIZE);
      const message = {
        notification: {
          title: payload.title,
          body: payload.body,
          ...(payload.image && { imageUrl: payload.image })
        },
        data: payload.data || { type: 'broadcast' },
        tokens: chunk,
      };

      const response = await admin.messaging().sendEachForMulticast(message);
      totalSuccess += response.successCount;
    }

    console.log(`📣 [FCM] Broadcast complete. Total successful: ${totalSuccess}`);
    return true;
  } catch (error) {
    console.error('❌ [FCM] broadcastPush error:', error);
    return false;
  }
}

/**
 * Register or update an FCM token for a user
 */
export async function registerFCMToken(userId, token, deviceType = 'mobile') {
  try {
    await query(`
      INSERT INTO user_fcm_tokens (user_id, token, device_type)
      VALUES (?, ?, ?)
      ON DUPLICATE KEY UPDATE 
        user_id = VALUES(user_id),
        device_type = VALUES(device_type),
        last_used = CURRENT_TIMESTAMP
    `, [userId, token, deviceType]);
    
    return true;
  } catch (error) {
    console.error('❌ [FCM] registerFCMToken error:', error);
    return false;
  }
}
