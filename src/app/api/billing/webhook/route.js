import { query } from '@/lib/db';
import { NextResponse } from 'next/server';

export async function POST(req) {
  try {
    const { searchParams } = new URL(req.url);
    const type = searchParams.get('type') || req.body?.type; // MP can send it in URL or body

    // We only care about payments or merchant orders for now
    if (type === 'payment' || type === 'ipn') {
      const data = await req.json();
      const id = data.data?.id || data.id;

      if (!id) return NextResponse.json({ success: true }); // Acknowledge MP even if no ID

      /**
       * REAL IMPLEMENTATION:
       * 1. Call Mercado Pago API with the ID to get payment details (status, external_reference)
       * 2. Verify external_reference matches an ad_id in our DB
       * 3. Update billing and ad status
       */
      
      console.log(`--- [WEBHOOK] Received Mercado Pago notification ID: ${id} ---`);

      // For this demo/setup, we'll try to find any pending billing and simulate an update 
      // if external_reference was provided in the query params (MP often does this)
      const externalRef = searchParams.get('external_reference') || data.external_reference;

      if (externalRef) {
        console.log(`Updating billing for Ad ID: ${externalRef} to PAID`);
        
        // 1. Mark billing as paid
        await query('UPDATE billings SET status = "paid" WHERE ad_id = ?', [externalRef]);

        // 2. ACTIVATE THE AD AUTOMATICALLY
        await query('UPDATE advertisements SET status = "active" WHERE id = ?', [externalRef]);

        // 3. Fetch owner details AND the purchased plan from billing
        const billingData = await query('SELECT plan_type, amount FROM billings WHERE ad_id = ? AND status = "paid" ORDER BY created_at DESC LIMIT 1', [externalRef]);
        const purchasedPlan = billingData[0]?.plan_type || 'basic';
        const billAmount = billingData[0]?.amount || 0;

        const owners = await query('SELECT owner_id, title FROM advertisements WHERE id = ?', [externalRef]);
        const owner = owners[0];

        if (owner) {
          // 4. Update Ad Priority and Expiration based on the new plan
          let durationDays = 30;
          if (purchasedPlan === 'basic') durationDays = 15;
          if (purchasedPlan === 'diamond') durationDays = 3650; // 10 years for unlimited

          await query(`
            UPDATE advertisements 
            SET priority_level = ?, status = "active", expires_at = DATE_ADD(NOW(), INTERVAL ? DAY), rejection_reason = NULL
            WHERE id = ?
          `, [purchasedPlan, durationDays, externalRef]);

          const { createNotification, NotificationTemplates } = await import('@/lib/notifications');
          
          // Notify Advertiser with specific plan mention
          const advertiserTemplate = NotificationTemplates.PAYMENT_SUCCESS(owner.title);
          // Customize message for upgrade
          if (purchasedPlan === 'diamond') {
            advertiserTemplate.message = `¡Felicidades! Tu pauta "${owner.title}" ahora es Diamante con vigencia ilimitada.`;
          }

          await createNotification({
            userId: owner.owner_id,
            ...advertiserTemplate,
            link: `/dashboard`
          });

          // Notify ALL Admins
          const admins = await query('SELECT id FROM profiles WHERE role = "admin"');
          const adminTemplate = NotificationTemplates.ADMIN_PAYMENT_SUCCESS(owner.title, billAmount);
          
          for (const admin of admins) {
            await createNotification({
              userId: admin.id,
              ...adminTemplate,
              link: `/dashboard/admin`
            });
          }
        }
      }
    }

    return NextResponse.json({ success: true });

  } catch (error) {
    console.error('Webhook Error:', error);
    // Always return 200 or 201 to MP to stop retries, even if we had an internal error 
    // (unless we want MP to retry the notification)
    return NextResponse.json({ success: true });
  }
}
