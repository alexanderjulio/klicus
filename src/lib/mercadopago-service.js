/**
 * KLICUS Mercado Pago Billing Service
 * Integration with Mercado Pago Node.js SDK for processing COP payments.
 */

import { MercadoPagoConfig, Preference, Payment } from 'mercadopago';

function getClient() {
  const token = process.env.MP_ACCESS_TOKEN;
  if (!token) {
    throw new Error(
      'MP_ACCESS_TOKEN no está configurado. Agrega la variable de entorno antes de procesar pagos.'
    );
  }
  return new MercadoPagoConfig({ accessToken: token });
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
  const preference = new Preference(getClient());

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
    throw error;
  }
}

/**
 * Retrieves details of a payment by its ID
 * @param {string} paymentId - The ID sent by the webhook
 * @returns {Promise<Object>} - The payment data
 */
export async function getPaymentDetails(paymentId) {
  const payment = new Payment(getClient());
  try {
    const response = await payment.get({ id: paymentId });
    return response;
  } catch (error) {
    console.error(`❌ MP GET_PAYMENT ERROR [ID: ${paymentId}]:`, error.message);
    throw error;
  }
}
