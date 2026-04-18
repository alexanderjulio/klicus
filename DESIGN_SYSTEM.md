# KLICUS Design System: "Jewelry Elite"

Este documento define la identidad visual, los patrones de diseño y las reglas de interacción del marketplace KLICUS. Debe servir como guía única para cualquier futura mejora o creación de contenido.

---

## 🎨 Paleta de Colores
La experiencia KLICUS se basa en un contraste entre la energía del amarillo y la sofisticación de los grises neutros.

*   **KLICUS Yellow (`#FFF159`)**: Utilizado exclusivamente para la cabecera y el área promocional (banner). Representa la vitalidad del mercado.
*   **Neutral Background (`#F8F9FB`)**: Un gris muy claro que sirve como lienzo para todo el contenido principal, reduciendo la fatiga visual.
*   **Card Background (`#FBFBFC`)**: Un gris sutilmente más blanco que el fondo general, utilizado para dar relieve a los anuncios.

---

## 🏗️ Estructura del Marketplace
El layout está dividido en dos zonas de influencia claramente separadas:

1.  **Zona de Atracción (Header Gradient)**:
    *   Contiene el banner promocional.
    *   Usa un degradado `from-[#FFF159] to-[#F8F9FB]`.
    *   **Regla Crítica**: El degradado debe terminar **exactamente** al finalizar el banner. No debe tocar la sección de categorías.

2.  **Zona de Interacción (Categories & Grid)**:
    *   Ubicada sobre el fondo neutro (`#F8F9FB`).
    *   **Categorías**: Iconos centrados, compactos (`md:gap-5`) y sin sombras en el texto para mantener la nitidez.

---

## 💎 Sistema de Anuncios (Priority Tiers)

### 1. Diamante (Jewelry Elite Style)
Es el nivel más alto de exposición. No usa bordes de colores sólidos, sino efectos de luz.
*   **Animación Shine**: Un barrido de luz (`motion.div`) que cruza la tarjeta cada 7 segundos.
*   **Glow**: Sombra suave y amplia (`shadow-xl`) que se intensifica al hover.
*   **Badge**: Estilo Glassmorphism (`backdrop-blur-xl`) con borde metálico.
*   **Acento**: Una línea inferior de 2px con degradado dorado metálico.

### 2. Pro (Professional Style)
*   Equilibrio entre visibilidad y limpieza.
*   Badge azul con efecto de cristal esmerilado.

### 3. Basic (Neutral Style)
*   Diseño minimalista integrado totalmente en la cuadrícula.

---

## 📊 Sistema de Analítica
Los anuncios cuentan con tracking automático de:
*   **Tráfico**: Cada vez que se renderiza el anuncio.
*   **Clics**: Al entrar al detalle (`AdCard`).
*   **Contactos**: Al presionar botones de WhatsApp o Llamada (`AdContactButtons`).

---

## 🚀 Guía para Futuras Mejoras
*   **Nuevas Categorías**: Usar iconos de `lucide-react` con trazos de `stroke-width={2}`.
*   **Nuevos Colores**: Si se introducen nuevos estados, priorizar degradados suaves en lugar de colores sólidos intensos.
*   **Consistencia**: Siempre mantener el `rounded-[2.5rem]` para contenedores grandes y `rounded-xl` para elementos pequeños.

---
*KLICUS: Conectando lo mejor de tu región con un diseño premium.*
