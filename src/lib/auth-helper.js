/**
 * KLICUS Authentication Helper
 * Standardized session retrieval for Web & Flutter.
 */

import { getServerSession } from 'next-auth';
import { getToken } from 'next-auth/jwt';
import { authOptions } from './auth';
import { jwtVerify } from 'jose';

/**
 * Gets the current user session from either cookies (Web) 
 * or Authorization header (Flutter/Mobile).
 * 
 * @param {Request} req - The incoming request
 * @returns {Object|null} The user object or null if not authenticated
 */
export async function getUniversalSession(req) {
  // 1. Check for standard NextAuth session (Cookies - Web)
  const session = await getServerSession(authOptions);
  if (session?.user) {
    return session.user;
  }

  // 2. Fallback: Check for JWT in Authorization Header (For Mobile App)
  try {
    const authHeader = req.headers.get('authorization');
    if (authHeader && authHeader.startsWith('Bearer ')) {
      const token = authHeader.split(' ')[1];
      const secret = new TextEncoder().encode(process.env.NEXTAUTH_SECRET);
      
      const { payload } = await jwtVerify(token, secret);
      
      if (payload) {
        return {
          id: payload.id,
          name: payload.name,
          email: payload.email,
          role: payload.role,
          plan_type: payload.plan_type
        };
      }
    }

    // 3. Last resort: Try standard getToken from next-auth/jwt
    const nextAuthToken = await getToken({ 
      req, 
      secret: process.env.NEXTAUTH_SECRET 
    });
    
    if (nextAuthToken) {
      return {
        id: nextAuthToken.id,
        name: nextAuthToken.name,
        email: nextAuthToken.email,
        role: nextAuthToken.role,
        plan_type: nextAuthToken.plan_type
      };
    }

    // 4. Guest Fallback: Look for X-Guest-ID header (Hardened Validation)
    const guestId = req.headers.get('x-guest-id');
    const guestName = req.headers.get('x-guest-name') || 'Invitado Klicus';
    
    // Only accept validly prefixed guest IDs to prevent spoofing real user IDs
    if (guestId && typeof guestId === 'string' && guestId.startsWith('gst_')) {
      return {
        id: guestId,
        name: guestName,
        role: 'guest',
        is_guest: true
      };
    }
  } catch (error) {
    console.error('Session Verification Error:', error.message);
  }

  return null;
}
