export const dynamic = 'force-dynamic';
import { query } from '@/lib/db';
import { NextResponse } from 'next/server';
import { getPaymentDetails } from '@/lib/mercadopago-service';

export async function POST(req) {
  if (process.env.BUILD_MODE) return new Response(JSON.stringify({ build: true }), { status: 200, headers: { 'Content-Type': 'application/json' } });
  try {
    const { searchParams } = new URL(req.url);
    const type = searchParams.get('type') || req.body?.type;
    
    // 1. Check if it's a payment notification
    if (type === 'payment') {
      const body = await req.json();
      const paymentId = body.data?.id || body.id;

      if (!paymentId) return NextResponse.json({ success: true });

      console.log(`📡 [WEBHOOK] Verificando pago ID: ${paymentId}`);

      // 2. VERIFY WITH REAL MP API (STRICT VALIDATION)
      const payment = await getPaymentDetails(paymentId);
      
      // 3. SECURE EXTRACTION: Only trust what MP API returns
      const status = payment.status;
      const externalRef = payment.external_reference; // This was adId during preference creation
      const amount = payment.transaction_amount;

      if (status === 'approved' && externalRef) {
        console.log(`✅ [WEBHOOK] Pago APROBADO para Ad: ${externalRef}`);

        // 4. Update Billing status
        await query('UPDATE billings SET status = "paid" WHERE ad_id = ?', [externalRef]);

        // 5. Fetch Ad and Billing details for activation logic
        const billingData = await query('SELECT plan_type FROM billings WHERE ad_id = ? AND status = "paid" ORDER BY created_at DESC LIMIT 1', [externalRef]);
        const purchasedPlan = billingData[0]?.plan_type || 'basic';

        const owners = await query('SELECT owner_id, title FROM advertisements WHERE id = ?', [externalRef]);
        const owner = owners[0];

        if (owner) {
          // 6. Activation Parameters
          let durationDays = 30;
          if (purchasedPlan === 'basic') durationDays = 15;
          if (purchasedPlan === 'diamond') durationDays = 3650;

          await query(`
            UPDATE advertisements 
            SET priority_level = ?, status = "active", expires_at = DATE_ADD(NOW(), INTERVAL ? DAY), rejection_reason = NULL
            WHERE id = ?
          `, [purchasedPlan, durationDays, externalRef]);

          // 7. NOTIFICATIONS (Internal + Push via the unified service)
          const { createNotification, NotificationTemplates } = await import('@/lib/notifications');
          const template = NotificationTemplates.PAYMENT_SUCCESS(owner.title);
          
          if (purchasedPlan === 'diamond') {
            template.message = `¡Felicidades! Tu pauta "${owner.title}" ahora es Diamante con vigencia ilimitada.`;
          }

          await createNotification({
            userId: owner.owner_id,
            ...template,
            link: `/dashboard`
          });

          // Notify Admin
          const admins = await query('SELECT id FROM profiles WHERE role = "admin"');
          const adminTemplate = NotificationTemplates.ADMIN_PAYMENT_SUCCESS(owner.title, amount);
          
          for (const admin of admins) {
            await createNotification({
              userId: admin.id,
              ...adminTemplate,
              link: `/dashboard/admin`
            });
          }
        }
      } else {
        console.log(`⚠️ [WEBHOOK] El pago ${paymentId} tiene estado: ${status}`);
      }
    }

    // Always 200 for MP
    return NextResponse.json({ success: true });

  } catch (error) {
    console.error('❌ [WEBHOOK] Error crítico:', error.message);
    return NextResponse.json({ success: true });
  }
}

