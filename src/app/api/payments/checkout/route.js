export const dynamic = 'force-dynamic';
import { createPaymentPreference } from '@/lib/mercadopago-service';
import { query } from '@/lib/db';
import { NextResponse } from 'next/server';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/lib/auth';
import { v4 as uuidv4 } from 'uuid';
import { getPlanById } from '@/config/plans';

export async function POST(req) {
  try {
    const session = await getServerSession(authOptions);
    if (!session) {
      return NextResponse.json({ error: 'No autorizado' }, { status: 401 });
    }

    const { adId, planId } = await req.json();

    if (!adId || !planId) {
      return NextResponse.json({ error: 'Faltan parámetros' }, { status: 400 });
    }

    // 1. Get Ad details to verify ownership and plan
    const ads = await query('SELECT * FROM advertisements WHERE id = ? AND owner_id = ?', [adId, session.user.id]);
    const ad = ads[0];

    if (!ad) {
      return NextResponse.json({ error: 'Anuncio no encontrado o no autorizado' }, { status: 404 });
    }

    // 2. Get Plan Pricing
    const plan = getPlanById(planId);
    if (!plan || plan.price <= 0) {
      return NextResponse.json({ error: 'Plan no requiere pago o es inválido' }, { status: 400 });
    }

    // 3. Create or Update Billing record in status 'pending'
    const billingId = uuidv4();
    await query(`
      INSERT INTO billings (id, ad_id, user_id, amount, status, plan_type) 
      VALUES (?, ?, ?, ?, 'pending', ?)
    `, [billingId, adId, session.user.id, plan.price, planId]);

    // 4. Create Mercado Pago Preference
    try {
      const initPoint = await createPaymentPreference({
        title: `Plan ${plan.name} - KLICUS: ${ad.title}`,
        price: plan.price,
        quantity: 1,
        adId: adId,
        userEmail: session.user.email,
        includeIVA: false
      });

      return NextResponse.json({ success: true, initPoint });
    } catch (mpError) {
      console.error('❌ Mercado Pago Connection Error:', mpError.message);
      
      // Simulation mode: Redirect to Consignment Fallback when Token is missing or invalid
      return NextResponse.json({ 
        success: true, 
        initPoint: `/dashboard/pautas/exito?fallback=true&adId=${adId}`,
        message: 'Modo Contingencia: Redirigiendo a pago por consignación'
      });
    }

  } catch (error) {
    console.error('💥 Checkout Critical Error:', error);
    return NextResponse.json({ error: 'Error interno del servidor en el proceso de cobro' }, { status: 500 });
  }
}

