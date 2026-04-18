import { jwtVerify } from 'jose';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/lib/auth';

/**
 * Recovers the User ID from either a Session (Web) or a Bearer Token (Mobile)
 */
export async function getAuthenticatedUser(req) {
  // 1. Try Session first (Web)
  const session = await getServerSession(authOptions);
  if (session?.user?.id) {
    return session.user;
  }

  // 2. Try Bearer Token (Mobile)
  const authHeader = req.headers.get('authorization');
  if (authHeader && authHeader.startsWith('Bearer ')) {
    const token = authHeader.split(' ')[1];
    try {
      const secret = new TextEncoder().encode(process.env.NEXTAUTH_SECRET);
      const { payload } = await jwtVerify(token, secret);
      
      // Map payload to session user structure
      return {
        id: payload.id,
        name: payload.name,
        email: payload.email,
        role: payload.role,
        plan_type: payload.plan_type
      };
    } catch (error) {
      console.error('JWT Verification Error:', error);
      return null;
    }
  }

  return null;
}
