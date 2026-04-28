/**
 * KLICUS Ad Plans Configuration
 * Centralized pricing and features to allow easy updates.
 */

export const AD_PLANS = {
  basic: {
    id: 'basic',
    name: 'Básico',
    price: 0,
    priceLabel: 'Gratis',
    photoLimit: 1,
    duration: 365,
    features: ['1 Foto de perfil', 'Visibilidad estándar', 'Vigencia 1 año'],
    color: 'bg-white',
    text: 'text-secondary',
    badge: null
  },
  pro: {
    id: 'pro',
    name: 'Profesional',
    price: 45000,
    priceLabel: '$45.000',
    photoLimit: 3,
    duration: 365,
    features: ['3 Fotos galería', 'Visibilidad prioritaria', 'Vigencia 1 año', 'Etiqueta Pro'],
    color: 'bg-white',
    text: 'text-secondary',
    badge: 'Económico'
  },
  diamond: {
    id: 'diamond',
    name: 'Diamante',
    price: 99000,
    priceLabel: '$99.000',
    photoLimit: 5,
    duration: 365,
    features: ['5 Fotos HD', 'Máxima visibilidad Home', 'Vigencia 1 año', 'Resaltado oro', 'Soporte 24/7'],
    color: 'bg-secondary',
    text: 'text-white',
    badge: 'Recomendado'
  }
};

export const getPlanById = (id) => AD_PLANS[id] || AD_PLANS.basic;

export const PLAN_LIST = Object.values(AD_PLANS);

/**
 * Valores canónicos para profiles.plan_type.
 * Separados de AD_PLANS.id (que corresponde a advertisements.priority_level).
 */
export const PROFILE_PLANS = {
  FREE:    'Gratis',
  BASIC:   'Básico',
  PREMIUM: 'Premium',
};
