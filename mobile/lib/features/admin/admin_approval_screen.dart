import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/api_service.dart';
import '../../models/ad_model.dart';
import '../home/ad_detail_screen.dart';

class AdminApprovalScreen extends StatefulWidget {
  const AdminApprovalScreen({super.key});

  @override
  State<AdminApprovalScreen> createState() => _AdminApprovalScreenState();
}

class _AdminApprovalScreenState extends State<AdminApprovalScreen> {
  bool _isLoading = true;
  List<AdModel> _pendingAds = [];
  final Color _navy = const Color(0xFF0E2244);
  final Color _yellow = const Color(0xFFE2E000);

  @override
  void initState() {
    super.initState();
    _loadPendingAds();
  }

  Future<void> _loadPendingAds() async {
    setState(() => _isLoading = true);
    try {
      final api = context.read<ApiService>();
      // We use the admin/stats endpoint which returns the 'queue' (pending ads)
      final res = await api.get('/admin/stats'); 
      if (res.data['success'] == true) {
        final List<dynamic> queue = res.data['data']['queue'];
        setState(() {
          _pendingAds = queue.map((json) => AdModel.fromJson(json)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cargar la cola de aprobación')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _processAd(String adId, String status, {String? reason}) async {
    try {
      final api = context.read<ApiService>();
      final res = await api.post('/admin/approve-ad', data: {
        'adId': adId,
        'status': status,
        'reason': reason ?? 'Aprobado por el administrador',
      });

      if (res.data['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: status == 'active' ? Colors.green : Colors.red,
              content: Text(status == 'active' ? 'Anuncio aprobado' : 'Anuncio rechazado'),
            ),
          );
        }
        _loadPendingAds();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al procesar el anuncio')),
        );
      }
    }
  }

  void _showRejectDialog(String adId) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('RECHAZAR ANUNCIO', style: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: _navy)),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Motivo del rechazo (ej: Foto poco clara, contenido inapropiado...)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              _processAd(adId, 'rejected', reason: controller.text);
            },
            child: const Text('RECHAZAR'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        backgroundColor: _navy,
        elevation: 0,
        title: Text(
          'COLA DE APROBACIÓN',
          style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w900, color: _yellow, letterSpacing: 2),
        ),
        leading: const BackButton(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pendingAds.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadPendingAds,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _pendingAds.length,
                    itemBuilder: (context, index) {
                      final ad = _pendingAds[index];
                      return _buildApprovalCard(ad);
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 80, color: _navy.withOpacity(0.1)),
          const SizedBox(height: 16),
          Text(
            '¡TODO AL DÍA!',
            style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w900, color: _navy.withOpacity(0.3)),
          ),
          const SizedBox(height: 8),
          const Text('No hay anuncios pendientes de revisión.'),
        ],
      ),
    );
  }

  Widget _buildApprovalCard(AdModel ad) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Plan Type
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: ad.priorityLevel == 'diamond' ? _yellow : _navy.withOpacity(0.05),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ad.priorityLevel.toUpperCase(),
                  style: GoogleFonts.outfit(
                    fontSize: 10, 
                    fontWeight: FontWeight.w900, 
                    color: ad.priorityLevel == 'diamond' ? _navy : Colors.grey[600],
                    letterSpacing: 2
                  ),
                ),
                Text(
                  'SOLICITADO HACE POCO',
                  style: GoogleFonts.outfit(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    ApiService.normalizeUrl(ad.firstImage),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(width: 80, height: 80, color: Colors.grey[200], child: const Icon(Icons.image_not_supported)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ad.title,
                        style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w900, color: _navy),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Por: ${ad.ownerName ?? "Usuario KLICUS"}',
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AdDetailScreen(ad: ad))),
                        child: Text(
                          'VER PREVISUALIZACIÓN →',
                          style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.blue, letterSpacing: 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Actions
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showRejectDialog(ad.id),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('RECHAZAR', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _processAd(ad.id, 'active'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('APROBAR', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
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
