/**
 * KLICUS Manual Payment Configuration
 * Centralized place to edit bank details and QR options for consignment payments.
 */
export const manualPaymentConfig = {
  // Main visibility toggle for consignment fallback
  enabled: true,
  
  // Bank Account Details
  bankName: "Bancolombia / Nequi",
  accountType: "Ahorros",
  accountNumber: "313 532 8897",
  accountOwner: "Alexander Julio",
  
  // QR Code Configuration
  qr: {
    enabled: true, // Set to false to hide the QR image
    imagePath: "/assets/qr-pago-klicus.png", // Path in the public folder
    label: "Escanea para pagar con tu App"
  },
  
  // WhatsApp Support
  whatsappNumber: "573135328897",
  whatsappMessage: "¡Hola! He realizado el pago de mi pauta comercial. Adjunto el comprobante."
};
