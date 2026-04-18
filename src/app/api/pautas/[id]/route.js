import { query } from '@/lib/db';
import { apiResponse, ApiError } from '@/lib/api-utils';
import { getUniversalSession } from '@/lib/auth-helper';
import { processAdImage } from '@/lib/image-service';

export async function PUT(req, { params: paramsPromise }) {
  try {
    const params = await paramsPromise;
    const { id } = await params;
    const user = await getUniversalSession(req);
    
    // Security check: Only owner or admin can edit
    const userId = user?.id || 'demo-user-123';
    const isAdmin = user?.role === 'admin';

    const check = await query('SELECT owner_id, priority_level FROM advertisements WHERE id = ?', [id]);
    if (check.length === 0) return ApiError.notFound('Pauta no encontrada');
    
    if (check[0].owner_id !== userId && !isAdmin) {
      return ApiError.unauthorized('No autorizado para editar esta pauta');
    }

    // 2. Data Extraction via FormData
    const formData = await req.formData();
    const title = formData.get('title');
    const description = formData.get('description');
    const price_range = formData.get('price_range') || '';
    const location = formData.get('location');
    const address = formData.get('address');
    const business_hours = formData.get('business_hours');
    const category_id = formData.get('category_id');
    const phone = formData.get('phone');
    const cellphone = formData.get('cellphone');
    const email = formData.get('email');
    const website_url = formData.get('website_url');
    const facebook_url = formData.get('facebook_url');
    const instagram_url = formData.get('instagram_url');
    const delivery_info = formData.get('delivery_info');
    const is_offer = formData.get('is_offer') === 'true';
    
    // IMAGE HANDLING: Merge existing URLs with new Files
    const existingImagesRaw = formData.get('existingImages'); 
    const existingImages = existingImagesRaw ? JSON.parse(existingImagesRaw) : [];
    const newFiles = formData.getAll('images'); 

    const priority = check[0].priority_level;
    const LIMITS = { basic: 1, pro: 3, diamond: 5 };
    const maxAllowed = LIMITS[priority] || 1;

    const finalImageUrls = [...existingImages];

    // Process new images
    for (const file of newFiles) {
      if (file.size > 0 && finalImageUrls.length < maxAllowed) {
        const buffer = Buffer.from(await file.arrayBuffer());
        const url = await processAdImage(buffer, file.name || 'image.webp');
        finalImageUrls.push(url);
      }
    }

    // Update the ad
    await query(`
      UPDATE advertisements 
      SET 
        title = ?, 
        description = ?, 
        price_range = ?, 
        location = ?, 
        address = ?, 
        business_hours = ?, 
        category_id = ?, 
        phone = ?, 
        cellphone = ?, 
        email = ?, 
        website_url = ?, 
        facebook_url = ?,
        instagram_url = ?,
        delivery_info = ?, 
        image_urls = ?,
        is_offer = ?,
        status = 'pending'
      WHERE id = ?
    `, [
      title, description, price_range, location, address, 
      business_hours, category_id, phone, cellphone, 
      email, website_url, facebook_url, instagram_url,
      delivery_info, 
      JSON.stringify(finalImageUrls.slice(0, maxAllowed)),
      is_offer ? 1 : 0,
      id
    ]);

    return apiResponse({ 
      data: { success: true, message: 'Anuncio actualizado y enviado a verificación.' } 
    });

  } catch (error) {
    console.error('Update Ad API Error:', error);
    return ApiError.serverError();
  }
}

export async function GET(req, { params: paramsPromise }) {
  try {
    const params = await paramsPromise;
    const { id } = await params;
    const ad = await query('SELECT * FROM advertisements WHERE id = ?', [id]);
    
    if (ad.length === 0) return ApiError.notFound('Anuncio no encontrado');
    
    const formattedAd = {
      ...ad[0],
      image_urls: typeof ad[0].image_urls === 'string' ? JSON.parse(ad[0].image_urls) : (ad[0].image_urls || [])
    };

    return apiResponse({ data: formattedAd });

  } catch (error) {
    console.error('Get Ad API Error:', error);
    return ApiError.serverError();
  }
}

export async function DELETE(req, { params: paramsPromise }) {
  try {
    const params = await paramsPromise;
    const { id } = await params;
    const user = await getUniversalSession(req);
    
    const userId = user?.id || 'demo-user-123';
    const isAdmin = user?.role === 'admin';

    // Verify ownership
    const check = await query('SELECT owner_id FROM advertisements WHERE id = ?', [id]);
    if (check.length === 0) return ApiError.notFound('Pauta no encontrada');

    if (check[0].owner_id !== userId && !isAdmin) {
      return ApiError.unauthorized('No autorizado para eliminar esta pauta');
    }

    // Execute deletion
    await query('DELETE FROM advertisements WHERE id = ?', [id]);

    return apiResponse({ 
      data: { success: true, message: 'Pauta eliminada con éxito' } 
    });

  } catch (error) {
    console.error('Delete Ad API Error:', error);
    return ApiError.serverError();
  }
}
