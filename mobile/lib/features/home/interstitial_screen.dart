import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/api_service.dart';
import '../../core/services/image_cache_manager.dart';

class InterstitialScreen extends StatelessWidget {
  final String imageUrl;
  final String? ctaLink;

  const InterstitialScreen({super.key, required this.imageUrl, this.ctaLink});

  Future<void> _openLink() async {
    if (ctaLink == null || ctaLink!.isEmpty) return;
    final uri = Uri.parse(ctaLink!);
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Imagen a pantalla completa
          GestureDetector(
            onTap: ctaLink != null && ctaLink!.isNotEmpty ? _openLink : null,
            child: CachedNetworkImage(
              imageUrl: ApiService.normalizeUrl(imageUrl),
              cacheManager: KlicusCacheManager.instance,
              fit: BoxFit.fitWidth,
              placeholder: (_, __) => const SizedBox.shrink(),
              errorWidget: (_, __, ___) => const Center(child: Icon(Icons.broken_image, color: Colors.white54, size: 64)),
            ),
          ),

          // Botón cerrar (esquina superior derecha)
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24, width: 1),
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ),

          // CTA hint si hay link
          if (ctaLink != null && ctaLink!.isNotEmpty)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 32,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E000),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'TOCA PARA SABER MÁS',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF0E2244),
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
