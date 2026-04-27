export const dynamic = 'force-dynamic';
import { query } from '@/lib/db';
import { NextResponse } from 'next/server';
import crypto from 'crypto';

/**
 * KLICUS Event Tracker API
 * Records views and clicks with device detection and basic deduplication.
 */
export async function POST(req) {
  if (process.env.BUILD_MODE) return new Response(JSON.stringify({ build: true }), { status: 200, headers: { 'Content-Type': 'application/json' } });
  try {
    const { adId, eventType } = await req.json();

    const isGlobalEvent = ['install', 'session'].includes(eventType);
    const isAdEvent = ['view', 'click', 'contact', 'chat'].includes(eventType);

    if (!eventType || (!isGlobalEvent && !isAdEvent)) {
      return NextResponse.json({ error: 'Tipo de evento inválido' }, { status: 400 });
    }

    if (isAdEvent && !adId) {
      return NextResponse.json({ error: 'Falta adId para este evento' }, { status: 400 });
    }

    // 1. Device Detection (Enhanced for Flutter)
    const ua = req.headers.get('user-agent') || '';
    const source = req.headers.get('x-source') || '';
    
    let deviceType = 'desktop';
    if (source === 'mobile-app' || /dart/i.test(ua) || /klicus-app/i.test(ua)) {
      deviceType = 'mobile-app';
    } else if (/mobile/i.test(ua)) {
      deviceType = 'mobile-web';
    }
    
    // 2. IP Hashing for basic deduplication (privacy-safe)
    const ip = req.headers.get('x-forwarded-for') || '127.0.0.1';
    const dedupeKey = isGlobalEvent ? eventType : (adId + eventType);
    const ipHash = crypto.createHash('sha256').update(ip + dedupeKey).digest('hex');

    // 3. Rate Limiting / Deduplication Logic:
    // Don't record same event from same IP for same target within a time window
    const timeWindow = (eventType === 'view' || eventType === 'install') ? 'INTERVAL 1 HOUR' : 'INTERVAL 1 MINUTE';
    
    const recentEvents = await query(`
      SELECT id FROM metrics 
      WHERE ${isGlobalEvent ? 'ad_id IS NULL' : 'ad_id = ?'} AND event_type = ? AND ip_hash = ? AND created_at > DATE_SUB(NOW(), ${timeWindow})
      LIMIT 1
    `, isGlobalEvent ? [eventType, ipHash] : [adId, eventType, ipHash]);

    if (recentEvents.length > 0) {
      // Skip insertion to avoid inflation
      return NextResponse.json({ success: true, duplicated: true });
    }

    // 4. Record Event
    await query(`
      INSERT INTO metrics (ad_id, event_type, device_type, ip_hash)
      VALUES (?, ?, ?, ?)
    `, [adId || null, eventType, deviceType, ipHash]);

    return NextResponse.json({ success: true });

  } catch (error) {
    console.error('Tracking API Error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}

