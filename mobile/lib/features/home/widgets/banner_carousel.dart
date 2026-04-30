import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/services/image_cache_manager.dart';
import 'package:provider/provider.dart';
import '../../../core/api_service.dart';
import '../../../core/repositories/ad_repository.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  List<dynamic> _banners = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBanners();
  }

  Future<void> _fetchBanners() async {
    try {
      final response = await context.read<AdRepository>().fetchBanners();
      if (response.data['success'] == true) {
        if (mounted) {
          setState(() {
            _banners = response.data['data'];
            _isLoading = false;
          });
          if (_banners.isNotEmpty) {
            _startTimer();
          }
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_banners.isEmpty) return;
      
      if (_currentPage < _banners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients && _pageController.position.hasContentDimensions) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: 230,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    if (_banners.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 230,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemCount: _banners.length,
              itemBuilder: (context, index) {
                final banner = _banners[index];
                return _buildBannerSlide(banner);
              },
            ),
            // Indicators
            Positioned(
              bottom: 20,
              left: 24,
              child: Row(
                children: _banners.asMap().entries.map((entry) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _currentPage == entry.key ? 24 : 8,
                    height: 4,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(_currentPage == entry.key ? 1 : 0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerSlide(Map<String, dynamic> banner) {
    final Color bannerColor = _parseColor(banner['color'] ?? '0xFF0E2244');
    final bool isYellowBackground = bannerColor.value == 0xFFE2E000;
    final Color textColor = isYellowBackground ? const Color(0xFF0E2244) : Colors.white;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image
        CachedNetworkImage(
          imageUrl: ApiService.normalizeUrl(banner['image_url']),
          cacheManager: KlicusCacheManager.instance,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(color: Colors.grey[200]),
          errorWidget: (context, url, error) => Container(color: bannerColor),
        ),
        // Gradient Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                bannerColor.withOpacity(0.95),
                bannerColor.withOpacity(0.4),
                Colors.transparent,
              ],
            ),
          ),
        ),
        // Content
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'DESTACADO',
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: textColor.withOpacity(0.7),
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 200,
                child: Text(
                  banner['title'] ?? '',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 180,
                child: Text(
                  banner['subtitle'] ?? '',
                  style: TextStyle(
                    fontSize: 11,
                    color: textColor.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (banner['cta_text'] != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: textColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: textColor.withOpacity(0.2)),
                  ),
                  child: Text(
                    banner['cta_text'].toUpperCase(),
                    style: TextStyle(color: textColor, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Color _parseColor(String? colorStr) {
    if (colorStr == null) return const Color(0xFF0E2244);
    try {
      if (colorStr.startsWith('0x')) {
        return Color(int.parse(colorStr));
      }
      return const Color(0xFF0E2244);
    } catch (e) {
      return const Color(0xFF0E2244);
    }
  }
}
