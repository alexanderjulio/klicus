import { NextResponse } from 'next/server';
import { getUniversalSession } from '@/lib/auth-helper';
import { registerFCMToken } from '@/lib/push-notifications';

/**
 * FCM Token Registration API
 * POST: Associate an FCM token with a user or guest
 */
export async function POST(req) {
  try {
    const { token, deviceType, guestId } = await req.json();
    
    if (!token) {
      return NextResponse.json({ success: true, message: 'No token provided, skipping registration' });
    }

    // 1. Identify requester
    const user = await getUniversalSession(req);
    const identifier = user?.id || guestId;

    if (!identifier) {
      return NextResponse.json({ error: 'No identifier provided' }, { status: 400 });
    }

    // 2. Register token in DB
    const success = await registerFCMToken(identifier, token, deviceType || 'mobile');

    if (success) {
      return NextResponse.json({ success: true, message: 'Token registered successfully' });
    } else {
      return NextResponse.json({ error: 'Database update failed' }, { status: 500 });
    }
  } catch (error) {
    console.error('FCM Registration API Error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}
