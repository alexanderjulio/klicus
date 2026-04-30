import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/ad_model.dart';

class UpgradeAdScreen extends StatelessWidget {
  final AdModel ad;

  const UpgradeAdScreen({super.key, required this.ad});

  Future<void> _launchWhatsApp(BuildContext context, String planName) async {
    const phoneNumber = "573135328897";
    final message = "Hola, me gustaría destacar mi anuncio '${ad.title}' (ID: ${ad.id}) activando el plan $planName.";
    final url = Uri.parse("https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir WhatsApp')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0E2244);
    const bg = Color(0xFFF8F9FB);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(
          'DESTACAR ANUNCIO',
          style: GoogleFonts.outfit(color: navy, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1),
        ),
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: navy),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'AUMENTA TUS VENTAS',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2, color: navy.withOpacity(0.5)),
            ),
            const SizedBox(height: 8),
            Text(
              'Elige un plan premium',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w900, color: navy),
            ),
            const SizedBox(height: 12),
            Text(
              'Llega a miles de clientes potenciales en KLICUS posicionando tu anuncio en los primeros lugares.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600], height: 1.5),
            ),
            const SizedBox(height: 40),

            _buildPlanCard(
              context: context,
              planName: 'DIAMOND',
              price: 'Contactar',
              subtitle: 'Máxima visibilidad y lujo',
              color: const Color(0xFFE2E000), // KLICUS Yellow
              textColor: navy,
              isBestValue: true,
              benefits: [
                'Top 1 en resultados de búsqueda',
                'Animación de brillo "Jewelry Elite"',
                'Etiqueta Diamante exclusiva',
                'Hasta 5 imágenes de galería',
              ],
            ),

            const SizedBox(height: 24),

            _buildPlanCard(
              context: context,
              planName: 'PRO',
              price: 'Contactar',
              subtitle: 'Posicionamiento avanzado',
              color: navy,
              textColor: Colors.white,
              isBestValue: false,
              benefits: [
                'Prioridad sobre anuncios básicos',
                'Etiqueta Profesional',
                'Borde distintivo en galería',
                'Hasta 3 imágenes de galería',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required BuildContext context,
    required String planName,
    required String price,
    required String subtitle,
    required Color color,
    required Color textColor,
    required bool isBestValue,
    required List<String> benefits,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(isBestValue ? 0.3 : 0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (isBestValue)
            Positioned(
              top: 0,
              right: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Text(
                  'RECOMENDADO',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFFE2E000),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  planName,
                  style: GoogleFonts.outfit(
                    color: textColor,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    color: textColor.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 24),
                ...benefits.map((benefit) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: textColor.withOpacity(0.8), size: 16),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          benefit,
                          style: GoogleFonts.inter(
                            color: textColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => _launchWhatsApp(context, planName),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: textColor,
                      foregroundColor: color,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'LO QUIERO',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
