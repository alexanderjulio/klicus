import { query } from '@/lib/db';
import Navigation from '@/components/Navigation';
import AdCreationForm from '@/components/AdCreationForm';

export default async function NewAdPage() {
  const categories = await query('SELECT * FROM categories WHERE active = TRUE');

  return (
    <>
      <Navigation />
      <div className="container" style={{ paddingTop: '100px', paddingBottom: '4rem' }}>
        <header style={{ textAlign: 'center', marginBottom: '3rem' }}>
          <h1 style={{ fontSize: '2.5rem' }}>Publica tu Pauta</h1>
          <p style={{ color: 'var(--muted-foreground)' }}>Llega a miles de personas con KLICUS.</p>
        </header>
        
        <AdCreationForm categories={categories} />
      </div>
    </>
  );
}
