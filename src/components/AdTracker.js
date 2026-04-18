'use client';

import { useEffect } from 'react';

/**
 * KLICUS Ad Tracking Component
 * Performs automatic 'view' tracking on mount and provides helper for 'click' tracking.
 */
export default function AdTracker({ adId }) {
  useEffect(() => {
    // 1. Initial View Tracking
    const trackView = async () => {
      try {
        await fetch('/api/metrics/track', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ adId, eventType: 'view' })
        });
      } catch (err) {
        console.warn('View tracking failed');
      }
    };

    // Tracking after a small delay to ensure it was a real visit, not a crawler or bounce
    const timer = setTimeout(trackView, 2000); 
    return () => clearTimeout(timer);
  }, [adId]);

  return null; // Invisible component
}

/**
 * Helper to track clicks on contact buttons (WhatsApp, Phone)
 */
export async function trackContact(adId) {
  try {
    await fetch('/api/metrics/track', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ adId, eventType: 'contact' })
    });
  } catch (err) {
    console.warn('Contact tracking failed');
  }
}

/**
 * Helper to track clicks on ad cards (opening the ad)
 */
export async function trackClick(adId) {
  try {
    await fetch('/api/metrics/track', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ adId, eventType: 'click' })
    });
  } catch (err) {
    console.warn('Click tracking failed');
  }
}
