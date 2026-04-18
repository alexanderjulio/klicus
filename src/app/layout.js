/**
 * KLICUS Root Layout
 * Configures global styles, metadata, and fonts for the entire application.
 * Supports PWA manifest and mobile-responsive viewport tags.
 */

import { Inter, Outfit } from "next/font/google";
import { ToastProvider } from '@/context/ToastContext';
import { LocationProvider } from '@/context/LocationContext';
import "@/styles/globals.css";
import Navigation from "@/components/Navigation";
import BottomNav from "@/components/BottomNav";
import { Providers } from "@/components/Providers";

// Google Fonts for a premium aesthetic
const inter = Inter({ subsets: ["latin"], variable: "--font-inter" });
const outfit = Outfit({ subsets: ["latin"], variable: "--font-outfit" });

/** @type {import('next').Metadata} */
export const metadata = {
  title: "KLICUS | Marketplace Publicitario Premium",
  description: "La plataforma líder para conectar profesionales y comercios con su audiencia local.",
  manifest: "/manifest.json",
  icons: {
    icon: "/favicon.png",
    apple: "/favicon.png",
  },
};

/** @type {import('next').Viewport} */
export const viewport = {
  themeColor: "#E2E000",
  width: "device-width",
  initialScale: 1,
  maximumScale: 1,
  userScalable: false,
};

export default function RootLayout({ children }) {
  return (
    <html lang="es">
      <head>
        {/* PWA & Mobile Meta Tags */}
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <meta name="apple-mobile-web-app-status-bar-style" content="default" />
      </head>
      <body className={`${inter.variable} ${outfit.variable} pb-16 md:pb-0 font-sans`}>
        <Providers>
          <LocationProvider>
            <ToastProvider>
              <Navigation />
              {children}
              <BottomNav />
            </ToastProvider>
          </LocationProvider>
        </Providers>
      </body>
    </html>
  );
}
