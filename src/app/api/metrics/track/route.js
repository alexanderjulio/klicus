import { query } from '@/lib/db';
import { NextResponse } from 'next/server';
import crypto from 'crypto';

/**
 * KLICUS Event Tracker API
 * Records views and clicks with device detection and basic deduplication.
 */
export async function POST(req) {
  try {
    const { adId, eventType } = await req.json();

    if (!adId || !['view', 'click', 'contact'].includes(eventType)) {
      return NextResponse.json({ error: 'Faltan parámetros o el tipo de evento es inválido' }, { status: 400 });
    }

    // 1. Device Detection from User-Agent
    const ua = req.headers.get('user-agent') || '';
    let deviceType = 'desktop';
    if (/mobile/i.test(ua)) deviceType = 'mobile';
    if (/tablet/i.test(ua)) deviceType = 'pwa'; // Mapping tablet to 'pwa' or just keep mobile
    
    // 2. IP Hashing for basic deduplication (privacy-safe)
    const ip = req.headers.get('x-forwarded-for') || '127.0.0.1';
    const ipHash = crypto.createHash('sha256').update(ip + adId + eventType).digest('hex');

    // 3. Rate Limiting / Deduplication Logic:
    // Don't record same event from same IP for same ad within 1 hour for views, 1 minute for clicks
    const timeWindow = eventType === 'view' ? 'INTERVAL 1 HOUR' : 'INTERVAL 1 MINUTE';
    
    const recentEvents = await query(`
      SELECT id FROM metrics 
      WHERE ad_id = ? AND event_type = ? AND ip_hash = ? AND created_at > DATE_SUB(NOW(), ${timeWindow})
      LIMIT 1
    `, [adId, eventType, ipHash]);

    if (recentEvents.length > 0) {
      // Skip insertion to avoid inflation
      return NextResponse.json({ success: true, duplicated: true });
    }

    // 4. Record Event
    await query(`
      INSERT INTO metrics (ad_id, event_type, device_type, ip_hash)
      VALUES (?, ?, ?, ?)
    `, [adId, eventType, deviceType, ipHash]);

    return NextResponse.json({ success: true });

  } catch (error) {
    console.error('Tracking API Error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}
