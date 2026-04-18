import { query } from '@/lib/db';
import AdCreationForm from '@/components/AdCreationForm';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/lib/auth';
import { redirect } from 'next/navigation';

/**
 * KLICUS Publication Page
 * 
 * SECURITY POLICY:
 * This is a protected route. Only authenticated users can access the creation form.
 * Anonymous users are redirected to the login page with a callback to this page.
 */
export default async function PublicarPage() {
  // 1. Session Verification (Server Side)
  const session = await getServerSession(authOptions);
  
  if (!session) {
    // Force login if not authenticated
    redirect('/login?callbackUrl=/publicar');
  }

  // 2. Load Categories for the form
  const categories = await query('SELECT * FROM categories WHERE active = TRUE');

  // 3. Fetch Plan Limits for the user
  const userProfile = await query('SELECT plan_type FROM profiles WHERE id = ?', [session.user.id]);
  const planType = userProfile[0]?.plan_type || 'Gratis';
  const planConfigs = await query('SELECT * FROM plan_configs WHERE plan_name = ?', [planType]);
  const planLimit = planConfigs[0] || { max_images: 2, duration_days: 30 };


  return (
    <div className="container mx-auto px-4 pt-32 pb-24">
      <header className="text-center mb-12 animate-in fade-in duration-700">
        <h1 className="text-4xl md:text-5xl font-black text-secondary tracking-tighter mb-2">
          Publica tu Pauta
        </h1>
        <p className="text-muted-foreground text-lg max-w-lg mx-auto font-medium">
          Llega a miles de personas en tu región con la red más innovadora de anuncios.
        </p>
      </header>
      
      <div className="fade-in animate-in slide-in-from-bottom-8 duration-700">
        {/* Pass the session user info and plan limits for enforcement */}
        <AdCreationForm 
          categories={categories} 
          user={session.user} 
          planLimit={planLimit}
        />

      </div>
    </div>
  );
}

