import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/services/image_cache_manager.dart';
import '../auth/auth_provider.dart';
import '../../core/repositories/user_repository.dart';
import '../../models/ad_model.dart';
import '../home/ad_detail_screen.dart';
import 'edit_ad_screen.dart';
import 'ad_analytics_screen.dart';
import 'upgrade_ad_screen.dart';

class UserAdsScreen extends StatefulWidget {
  const UserAdsScreen({super.key});

  @override
  State<UserAdsScreen> createState() => _UserAdsScreenState();
}

class _UserAdsScreenState extends State<UserAdsScreen> {
  bool _isLoading = true;
  List<AdModel> _ads = [];
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchUserAds();
  }

  Future<void> _fetchUserAds() async {
    if (!mounted) return;
    setState(() { _isLoading = true; _error = ''; });
    try {
      final response = await context.read<UserRepository>().fetchUserAds();

      if (response.data['success'] == true && mounted) {
        final List<dynamic> adsJson = response.data['ads'];
        setState(() {
          _ads = adsJson.map((json) => AdModel.fromJson(json)).toList();
          _isLoading = false;
        });
        // HOT REFRESH: Sync profile stats whenever ads are updated
        context.read<AuthProvider>().fetchDashboardStats();
      } else {
        if (mounted) setState(() => _error = 'No se pudieron cargar tus anuncios');
      }
    } catch (e) {
      if (mounted) setState(() => _error = 'Error de conexión');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0E2244);
    const yellow = Color(0xFFE2E000);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: navy, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'MIS ANUNCIOS',
          style: GoogleFonts.outfit(
            color: navy,
            fontWeight: FontWeight.w900,
            fontSize: 18,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchUserAds,
        color: navy,
        backgroundColor: Colors.white,
        child: _isLoading && _ads.isEmpty
          ? const Center(child: CircularProgressIndicator(color: navy))
          : _error.isNotEmpty
            ? SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 200,
                  child: _buildErrorState(_error, navy, yellow),
                ),
              )
            : _ads.isEmpty
              ? SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 200,
                    child: _buildEmptyState(navy, yellow),
                  ),
                )
              : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _ads.length,
                itemBuilder: (context, index) => _UserAdTile(
                  ad: _ads[index], 
                  onRefresh: _fetchUserAds,
                  navy: navy,
                  yellow: yellow,
                ),
              ),
      ),
    );
  }

  Widget _buildErrorState(String message, Color navy, Color yellow) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.08), blurRadius: 20)],
              ),
              child: Icon(Icons.wifi_off_rounded, size: 60, color: Colors.red[300]),
            ),
            const SizedBox(height: 32),
            Text(
              'ERROR DE CONEXIÓN',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 16, color: navy, letterSpacing: 1),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _fetchUserAds,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text('REINTENTAR', style: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1)),
              style: ElevatedButton.styleFrom(
                backgroundColor: navy,
                foregroundColor: yellow,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(Color navy, Color yellow) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: navy.withOpacity(0.05), blurRadius: 20)],
              ),
              child: Icon(Icons.ads_click_rounded, size: 80, color: navy.withOpacity(0.1)),
            ),
            const SizedBox(height: 32),
            Text(
              'SIN PAUTAS ACTIVAS',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 18, color: navy, letterSpacing: 1),
            ),
            const SizedBox(height: 12),
            Text(
              'Aún no tienes anuncios publicados en la red KLICUS.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 13, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserAdTile extends StatelessWidget {
  final AdModel ad;
  final VoidCallback onRefresh;
  final Color navy;
  final Color yellow;

  const _UserAdTile({
    required this.ad, 
    required this.onRefresh,
    required this.navy,
    required this.yellow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: navy.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: ad.firstImage,
                  cacheManager: KlicusCacheManager.instance,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: Colors.grey[100]),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ad.title.toUpperCase(),
                      style: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 14, color: navy, letterSpacing: -0.5),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ad.categoryName,
                      style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 8),
                    _StatusBadge(status: ad.priorityLevel),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AdDetailScreen(ad: ad))),
                icon: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[300]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.spaceEvenly,
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSmallAction(Icons.analytics_outlined, 'Estadísticas', () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AdAnalyticsScreen(ad: ad)));
              }),
              _buildSmallAction(Icons.edit_outlined, 'Editar', () async {
                final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => EditAdScreen(ad: ad)));
                if (result == true) {
                  Future.delayed(const Duration(milliseconds: 300), () => onRefresh());
                }
              }),
              _buildSmallAction(Icons.star_rounded, 'Destacar', () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => UpgradeAdScreen(ad: ad)));
              }, isPremium: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallAction(IconData icon, String label, VoidCallback onTap, {bool isPremium = false}) {
    if (isPremium) {
      return ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16, color: navy),
        label: Text(
          label.toUpperCase(),
          style: GoogleFonts.outfit(color: navy, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE2E000), // Solid Yellow
          foregroundColor: navy,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          minimumSize: const Size(0, 32),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }

    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: navy),
      label: Text(
        label.toUpperCase(),
        style: GoogleFonts.outfit(color: navy, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withOpacity(0.1)),
      ),
      child: Text(
        'ACTIVO',
        style: GoogleFonts.outfit(color: Colors.green, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1),
      ),
    );
  }
}
