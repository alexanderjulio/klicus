import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/api_service.dart';

class AdminMarketingScreen extends StatefulWidget {
  const AdminMarketingScreen({super.key});

  @override
  State<AdminMarketingScreen> createState() => _AdminMarketingScreenState();
}

class _AdminMarketingScreenState extends State<AdminMarketingScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  List<dynamic> _banners = [];

  List<dynamic> get _carouselBanners =>
      _banners.where((b) => (b['type'] ?? 'carousel') == 'carousel').toList();

  Map<String, dynamic>? get _interstitial =>
      _banners.cast<Map<String, dynamic>?>().firstWhere(
            (b) => b?['type'] == 'interstitial',
            orElse: () => null,
          );

  @override
  void initState() {
    super.initState();
    _fetchBanners();
  }

  Future<void> _fetchBanners() async {
    setState(() => _isLoading = true);
    try {
      final res = await _apiService.get('/admin/banners');
      if (res.data['success']) {
        setState(() => _banners = res.data['data']);
      }
    } catch (e) {
      debugPrint('Fetch banners error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleBannerStatus(int id, bool currentStatus) async {
    try {
      final res = await _apiService.put('/admin/banners', data: {
        'id': id,
        'is_active': !currentStatus,
      });
      if (res.data['success']) _fetchBanners();
    } catch (e) {
      debugPrint('Toggle error: $e');
    }
  }

  Future<void> _deleteBanner(int id) async {
    try {
      final res = await _apiService.delete('/admin/banners', queryParameters: {'id': id});
      if (res.data['success']) _fetchBanners();
    } catch (e) {
      debugPrint('Delete error: $e');
    }
  }

  void _showBannerForm({Map<String, dynamic>? banner}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _BannerForm(
        banner: banner,
        onSave: () {
          Navigator.pop(context);
          _fetchBanners();
        },
      ),
    );
  }

  void _showInterstitialForm({Map<String, dynamic>? interstitial}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _InterstitialForm(
        interstitial: interstitial,
        onSave: () {
          Navigator.pop(context);
          _fetchBanners();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0E2244);
    const yellow = Color(0xFFE2E000);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        title: const Text('GESTIÓN MARKETING'),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: navy),
            onPressed: () => _showBannerForm(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // ── Sección Intersticial ─────────────────────────────────
                _buildSectionHeader('PANTALLA INTERSTICIAL', Icons.fullscreen_rounded, navy),
                const SizedBox(height: 12),
                _buildInterstitialCard(_interstitial, navy, yellow),
                const SizedBox(height: 28),

                // ── Sección Carrusel ─────────────────────────────────────
                _buildSectionHeader('BANNERS DE CARRUSEL', Icons.view_carousel_rounded, navy),
                const SizedBox(height: 12),
                if (_carouselBanners.isEmpty)
                  _buildEmptyCarouselState(navy)
                else
                  ..._carouselBanners
                      .map((b) => _buildBannerCard(b, navy, yellow)),
              ],
            ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color navy) {
    return Row(
      children: [
        Icon(icon, size: 18, color: navy.withOpacity(0.5)),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: navy.withOpacity(0.45),
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildInterstitialCard(Map<String, dynamic>? interstitial, Color navy, Color yellow) {
    final bool hasInterstitial = interstitial != null;
    final bool isActive = hasInterstitial &&
        (interstitial['is_active'] == 1 || interstitial['is_active'] == true);

    if (!hasInterstitial) {
      return GestureDetector(
        onTap: () => _showInterstitialForm(),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: navy.withOpacity(0.1), width: 2),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_photo_alternate_outlined, size: 32, color: navy.withOpacity(0.25)),
              const SizedBox(height: 10),
              Text(
                'AGREGAR PANTALLA INTERSTICIAL',
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: navy.withOpacity(0.35),
                  letterSpacing: 0.8,
                ),
              ),
              Text(
                'Aparece al abrir la app (opcional)',
                style: GoogleFonts.inter(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Stack(
              children: [
                Image.network(
                  ApiService.normalizeUrl(interstitial['image_url']),
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 160,
                    color: navy,
                    child: const Icon(Icons.broken_image, color: Colors.white),
                  ),
                ),
                // Interstitial badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: navy.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.fullscreen_rounded, size: 12, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text(
                          'INTERSTICIAL',
                          style: GoogleFonts.outfit(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
                // Active badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isActive ? yellow : Colors.grey[400],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isActive ? 'ACTIVO' : 'INACTIVO',
                      style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: navy),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pantalla de bienvenida',
                        style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w900, color: navy),
                      ),
                      if ((interstitial['cta_link'] ?? '').isNotEmpty)
                        Text(
                          interstitial['cta_link'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
                        ),
                    ],
                  ),
                ),
                TextButton.icon(
                  icon: Icon(
                    isActive ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    size: 18,
                  ),
                  label: Text(isActive ? 'Ocultar' : 'Mostrar'),
                  onPressed: () => _toggleBannerStatus(interstitial['id'], isActive),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: () => _showInterstitialForm(interstitial: interstitial),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                  onPressed: () => _confirmDelete(interstitial['id']),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCarouselState(Color navy) {
    return GestureDetector(
      onTap: () => _showBannerForm(),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: navy.withOpacity(0.1), width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.collections_outlined, size: 28, color: navy.withOpacity(0.2)),
            const SizedBox(height: 8),
            Text(
              'No hay banners configurados',
              style: GoogleFonts.outfit(color: navy.withOpacity(0.4), fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerCard(Map<String, dynamic> b, Color navy, Color yellow) {
    final bool isActive = b['is_active'] == 1 || b['is_active'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Stack(
              children: [
                Image.network(
                  ApiService.normalizeUrl(b['image_url']),
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 120,
                    color: navy,
                    child: const Icon(Icons.broken_image, color: Colors.white),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isActive ? yellow : Colors.grey[400],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isActive ? 'ACTIVO' : 'INACTIVO',
                      style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: navy),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(b['title'] ?? '', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w900, color: navy)),
                const SizedBox(height: 4),
                Text(b['subtitle'] ?? 'Sin subtítulo',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: Icon(isActive ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18),
                      label: Text(isActive ? 'Desactivar' : 'Activar'),
                      onPressed: () => _toggleBannerStatus(b['id'], isActive),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('Editar'),
                      onPressed: () => _showBannerForm(banner: b),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                      onPressed: () => _confirmDelete(b['id']),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar?'),
        content: const Text('Esta acción no se puede deshacer.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteBanner(id);
            },
            child: const Text('ELIMINAR', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ── Interstitial Form ─────────────────────────────────────────────────────────

class _InterstitialForm extends StatefulWidget {
  final Map<String, dynamic>? interstitial;
  final VoidCallback onSave;

  const _InterstitialForm({this.interstitial, required this.onSave});

  @override
  State<_InterstitialForm> createState() => _InterstitialFormState();
}

class _InterstitialFormState extends State<_InterstitialForm> {
  final _apiService = ApiService();
  final _picker = ImagePicker();
  final _ctaLinkController = TextEditingController();

  bool _isActive = true;
  bool _isSaving = false;
  bool _isUploading = false;
  String _imageUrl = '';
  Uint8List? _selectedBytes;

  @override
  void initState() {
    super.initState();
    if (widget.interstitial != null) {
      _imageUrl = widget.interstitial!['image_url'] ?? '';
      _ctaLinkController.text = widget.interstitial!['cta_link'] ?? '';
      _isActive = widget.interstitial!['is_active'] == 1 || widget.interstitial!['is_active'] == true;
    }
  }

  @override
  void dispose() {
    _ctaLinkController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUpload() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
    if (image == null) return;

    final bytes = await image.readAsBytes();
    setState(() {
      _selectedBytes = bytes;
      _isUploading = true;
    });

    try {
      final res = await _apiService.uploadFile('/admin/upload', image, extraData: {'type': 'marketing'});
      if (res.data['success']) {
        setState(() => _imageUrl = res.data['url']);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Imagen subida con éxito'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      debugPrint('Upload error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al subir imagen'), backgroundColor: Colors.redAccent),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<void> _save() async {
    if (_imageUrl.isEmpty && _selectedBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una imagen primero'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isSaving = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      if (widget.interstitial != null) {
        await _apiService.put('/admin/banners', data: {
          'id': widget.interstitial!['id'],
          'image_url': _imageUrl,
          'cta_link': _ctaLinkController.text.trim(),
          'is_active': _isActive,
        });
      } else {
        await _apiService.post('/admin/banners', data: {
          'title': '',
          'image_url': _imageUrl,
          'cta_link': _ctaLinkController.text.trim(),
          'is_active': _isActive,
          'type': 'interstitial',
        });
      }
      widget.onSave();
    } catch (e) {
      debugPrint('Save interstitial error: $e');
      messenger.showSnackBar(
        const SnackBar(content: Text('Error al guardar'), backgroundColor: Colors.redAccent),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0E2244);
    const yellow = Color(0xFFE2E000);

    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.interstitial == null ? 'NUEVO INTERSTICIAL' : 'EDITAR INTERSTICIAL',
                  style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w900, color: navy),
                ),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ],
            ),
            Text(
              'Imagen a pantalla completa que aparece al abrir la app.',
              style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Image picker
            GestureDetector(
              onTap: _isUploading ? null : _pickAndUpload,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[200]!, width: 2),
                ),
                child: _selectedBytes != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.memory(_selectedBytes!, fit: BoxFit.contain),
                            if (_isUploading)
                              Container(
                                color: Colors.black45,
                                child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                              ),
                          ],
                        ),
                      )
                    : _imageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.network(
                              ApiService.normalizeUrl(_imageUrl),
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 40),
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.fullscreen_rounded, size: 48, color: navy.withOpacity(0.2)),
                              const SizedBox(height: 12),
                              Text(
                                'SUBIR IMAGEN',
                                style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: navy.withOpacity(0.4)),
                              ),
                              Text(
                                'Se mostrará a pantalla completa en el móvil',
                                style: GoogleFonts.inter(fontSize: 10, color: Colors.grey),
                              ),
                            ],
                          ),
              ),
            ),
            const SizedBox(height: 20),

            // CTA link
            TextFormField(
              controller: _ctaLinkController,
              style: GoogleFonts.inter(fontSize: 14, color: navy),
              decoration: InputDecoration(
                labelText: 'Link al tocar (opcional)',
                hintText: 'https://...',
                labelStyle: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                prefixIcon: Icon(Icons.link_rounded, size: 20, color: navy.withOpacity(0.5)),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),

            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Mostrar al abrir la app', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: const Text('Los usuarios lo verán al iniciar la app.'),
              value: _isActive,
              activeColor: yellow,
              onChanged: (v) => setState(() => _isActive = v),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving || _isUploading ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: navy,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'GUARDAR',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Banner Form (Carrusel) ────────────────────────────────────────────────────

class _BannerForm extends StatefulWidget {
  final Map<String, dynamic>? banner;
  final VoidCallback onSave;

  const _BannerForm({this.banner, required this.onSave});

  @override
  State<_BannerForm> createState() => _BannerFormState();
}

class _BannerFormState extends State<_BannerForm> {
  final _apiService = ApiService();
  final _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late TextEditingController _imageController;
  late TextEditingController _ctaTextController;
  late TextEditingController _ctaLinkController;

  bool _isActive = true;
  bool _isSaving = false;
  bool _isUploading = false;

  Uint8List? _selectedBytes;
  Map<String, dynamic>? _uploadMetadata;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.banner?['title']);
    _subtitleController = TextEditingController(text: widget.banner?['subtitle']);
    _imageController = TextEditingController(text: widget.banner?['image_url']);
    _ctaTextController = TextEditingController(text: widget.banner?['cta_text'] ?? 'SABER MÁS');
    _ctaLinkController = TextEditingController(text: widget.banner?['cta_link'] ?? '/');
    _isActive = widget.banner != null
        ? (widget.banner!['is_active'] == 1 || widget.banner!['is_active'] == true)
        : true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _imageController.dispose();
    _ctaTextController.dispose();
    _ctaLinkController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUpload() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
    if (image == null) return;

    final bytes = await image.readAsBytes();
    final sizeInMb = bytes.length / (1024 * 1024);

    setState(() {
      _selectedBytes = bytes;
      _isUploading = true;
    });

    try {
      final res = await _apiService.uploadFile('/admin/upload', image, extraData: {'type': 'marketing'});
      if (res.data['success']) {
        setState(() {
          _imageController.text = res.data['url'];
          _uploadMetadata = {
            'originalSize': '${sizeInMb.toStringAsFixed(2)} MB',
            'optimizedSize': '${(res.data['size'] / 1024).toStringAsFixed(1)} KB',
            'dimensions': '${res.data['width']}x${res.data['height']} px',
          };
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Imagen subida y optimizada con éxito'),
          backgroundColor: Colors.green,
        ));
      }
    } catch (e) {
      debugPrint('Upload error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error al subir imagen al servidor'),
        backgroundColor: Colors.redAccent,
      ));
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final data = {
        'title': _titleController.text,
        'subtitle': _subtitleController.text,
        'image_url': _imageController.text,
        'cta_text': _ctaTextController.text,
        'cta_link': _ctaLinkController.text,
        'is_active': _isActive,
        'type': 'carousel',
      };

      if (widget.banner != null) {
        data['id'] = widget.banner!['id'];
        await _apiService.put('/admin/banners', data: data);
      } else {
        await _apiService.post('/admin/banners', data: data);
      }
      widget.onSave();
    } catch (e) {
      debugPrint('Save error: $e');
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0E2244);
    const yellow = Color(0xFFE2E000);

    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.banner == null ? 'NUEVA PROMOCIÓN' : 'EDITAR PROMOCIÓN',
                    style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w900, color: navy),
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 24),

              _buildImageSelector(navy),
              const SizedBox(height: 24),
              _buildField('Título del Banner', _titleController, Icons.title_rounded, navy),
              const SizedBox(height: 16),
              _buildField('Subtítulo / Descripción corta', _subtitleController, Icons.short_text_rounded, navy, required: false),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: _buildField('Texto Botón', _ctaTextController, Icons.ads_click_rounded, navy, required: false)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildField('Link (/ruta)', _ctaLinkController, Icons.link_rounded, navy, required: false)),
                ],
              ),
              const SizedBox(height: 24),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Banner Activo', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Visibilidad inmediata en el Home.'),
                value: _isActive,
                activeColor: yellow,
                onChanged: (v) => setState(() => _isActive = v),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving || _isUploading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: navy,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text('GUARDAR CAMBIOS', style: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSelector(Color navy) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _isUploading ? null : _pickAndUpload,
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[200]!, width: 2),
            ),
            child: _selectedBytes != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.memory(_selectedBytes!, fit: BoxFit.cover),
                        if (_isUploading)
                          Container(
                            color: Colors.black45,
                            child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                          ),
                      ],
                    ),
                  )
                : widget.banner != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(ApiService.normalizeUrl(_imageController.text), fit: BoxFit.cover),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload_outlined, size: 40, color: navy.withOpacity(0.5)),
                          const SizedBox(height: 12),
                          Text('SUBIR IMAGEN DEL BANNER',
                              style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: navy)),
                          Text('Toca para buscar en tu galería',
                              style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
          ),
        ),
        if (_uploadMetadata != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: navy.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetaItem('ORIGEN', _uploadMetadata!['originalSize'], Icons.file_present_rounded, navy),
                _buildMetaItem('OPTIMIZADO', _uploadMetadata!['optimizedSize'], Icons.auto_awesome, navy),
                _buildMetaItem('DIMENSIONES', _uploadMetadata!['dimensions'], Icons.aspect_ratio, navy),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMetaItem(String label, String value, IconData icon, Color navy) {
    return Column(
      children: [
        Icon(icon, size: 14, color: navy.withOpacity(0.3)),
        const SizedBox(height: 4),
        Text(label, style: GoogleFonts.outfit(fontSize: 8, fontWeight: FontWeight.bold, color: navy.withOpacity(0.4))),
        Text(value, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: navy)),
      ],
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon, Color navy, {bool required = true}) {
    return TextFormField(
      controller: controller,
      validator: required ? (v) => v == null || v.isEmpty ? 'Campo requerido' : null : null,
      style: GoogleFonts.inter(fontSize: 14, color: navy),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
        prefixIcon: Icon(icon, size: 20, color: navy.withOpacity(0.5)),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }
}
