/**
 * KLICUS Mercado Pago Billing Service
 * Integration with Mercado Pago Node.js SDK for processing COP payments.
 */

import { MercadoPagoConfig, Preference } from 'mercadopago';

// Initialize MP Client with access token from .env
// Fallback to a generic test token for initial development if not defined
const accessToken = process.env.MP_ACCESS_TOKEN || 'TEST-6056763421258953-061214-7e8c3e8e8e8e8e8e8e8e8e8e8e8e8e8e-123456789'; // Dummy test token

const client = new MercadoPagoConfig({ 
  accessToken: accessToken 
});

if (!process.env.MP_ACCESS_TOKEN) {
  console.warn('⚠️ Mercado Pago Access Token NOT found in .env. Using sandbox/dummy token.');
}

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
export async function createPaymentPreference({ title, price, quantity = 1, adId, userEmail = 'cliente@klicus.com', includeIVA = false }) {
  const preference = new Preference(client);

  // Optional 19% VAT (IVA) calculation
  const unitPrice = includeIVA ? price * 1.19 : price;

  try {
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
        payer: {
          email: userEmail
        },
        back_urls: {
          success: `${process.env.NEXTAUTH_URL}/dashboard/pautas/exito`,
          failure: `${process.env.NEXTAUTH_URL}/dashboard/pautas/error`,
          pending: `${process.env.NEXTAUTH_URL}/dashboard/pautas/pendiente`
        },
        notification_url: `${process.env.MP_WEBHOOK_URL || process.env.NEXTAUTH_URL}/api/billing/webhook`,
        external_reference: adId,
        auto_return: 'approved',
      }
    });

    return result.init_point;
  } catch (error) {
    console.error('❌ MP PREFERENCE ERROR:', error.message, error.stack);
    throw error;
  }
}
