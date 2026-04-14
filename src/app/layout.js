/**
 * KLICUS Root Layout
 * Configures global styles, metadata, and fonts for the entire application.
 * Supports PWA manifest and mobile-responsive viewport tags.
 */

import { Inter, Outfit } from "next/font/google";
import "@/styles/design-tokens.css";
import "@/styles/globals.css";

// Google Fonts for a premium aesthetic
const inter = Inter({ subsets: ["latin"], variable: "--font-inter" });
const outfit = Outfit({ subsets: ["latin"], variable: "--font-outfit" });

/** @type {import('next').Metadata} */
export const metadata = {
  title: "KLICUS | Marketplace Publicitario Premium",
  description: "La plataforma líder para conectar profesionales y comercios con su audiencia local.",
  manifest: "/manifest.json",
  themeColor: "#2563eb",
  viewport: "width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0",
};

export default function RootLayout({ children }) {
  return (
    <html lang="es">
      <head>
        {/* PWA & Mobile Meta Tags */}
        <link rel="apple-touch-icon" href="/icons/icon-192x192.png" />
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <meta name="apple-mobile-web-app-status-bar-style" content="default" />
      </head>
      <body className={`${inter.variable} ${outfit.variable}`}>
        {children}
      </body>
    </html>
  );
}
