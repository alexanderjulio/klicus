import { query } from '@/lib/db';
import AdCreationForm from '@/components/AdCreationForm';

export default async function NewAdPage() {
  const categories = await query('SELECT * FROM categories WHERE active = TRUE');

  return (
    <div className="container mx-auto px-4 pt-32 pb-24">
      <AdCreationForm categories={categories} />
    </div>
  );
}
