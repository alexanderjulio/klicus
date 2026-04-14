/**
 * KLICUS Mercado Pago Billing Service
 * Integration with Mercado Pago Node.js SDK for processing COP payments.
 */

import { MercadoPagoConfig, Preference } from 'mercadopago';

// Initialize MP Client with access token from .env
const client = new MercadoPagoConfig({ 
  accessToken: process.env.MP_ACCESS_TOKEN || 'YOUR_ACCESS_TOKEN' 
});

/**
 * Creates a payment preference to initiate the checkout flow.
 * @param {Object} params
 * @param {string} params.title - Item description for checkout
 * @param {number} params.price - Base price (COP)
 * @param {number} [params.quantity=1] - Multiplier
 * @param {string} params.adId - Ad Reference for database tracking
 * @param {boolean} [params.includeIVA=false] - Optional 19% tax calculation
 * @returns {Promise<string>} - The init_point (redirection URL)
 */
export async function createPaymentPreference({ title, price, quantity = 1, adId, includeIVA = false }) {
  const preference = new Preference(client);

  // Optional 19% VAT (IVA) calculation
  const unitPrice = includeIVA ? price * 1.19 : price;

  const result = await preference.create({
    body: {
      items: [
        {
          title: title,
          unit_price: Number(unitPrice),
          quantity: quantity,
          currency_id: 'COP'
        }
      ],
      back_urls: {
        success: `${process.env.NEXTAUTH_URL}/dashboard/pautas/exito`,
        failure: `${process.env.NEXTAUTH_URL}/dashboard/pautas/error`,
        pending: `${process.env.NEXTAUTH_URL}/dashboard/pautas/pendiente`
      },
      notification_url: `${process.env.MP_WEBHOOK_URL}/api/billing/webhook`,
      external_reference: adId,
      auto_return: 'approved',
    }
  });

  return result.init_point;
}
