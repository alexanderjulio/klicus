'use client';

/**
 * KLICUS Official Logo Component
 * Recreated based on branding guidelines (Yellow #E2E000, Navy #0E2244)
 */

import Image from 'next/image';

export default function Logo({ className = "h-8", light = false }) {
  return (
    <div className={`flex items-center ${className}`}>
      <Image 
        src="/assets/logo.png" 
        alt="KLICUS Logo" 
        width={180}
        height={60}
        className="h-full w-auto object-contain"
        priority
        unoptimized
      />
    </div>
  );
}
