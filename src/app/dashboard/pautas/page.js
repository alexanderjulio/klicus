'use client';

import { useEffect } from 'react';
import { useRouter } from 'next/navigation';

/**
 * KLICUS Route Redirector
 * Ensures users landing on the old /dashboard/pautas URL are 
 * seamlessly moved to the new consolidated /dashboard mission control.
 */
export default function PautasRedirect() {
  const router = useRouter();

  useEffect(() => {
    // Immediate redirect to the main high-performance dashboard
    router.replace('/dashboard');
  }, [router]);

  return (
    <div className="min-h-screen bg-[#F5F5F7] flex items-center justify-center">
      <div className="text-center">
        <div className="w-12 h-12 border-4 border-primary border-t-transparent rounded-full animate-spin mx-auto mb-4"></div>
        <p className="text-[10px] font-black uppercase tracking-[0.3em] text-secondary/40 italic">Redirigiendo a Consola...</p>
      </div>
    </div>
  );
}
