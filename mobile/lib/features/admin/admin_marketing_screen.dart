import 'dart:typed_data';
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
      if (res.data['success']) {
        _fetchBanners();
      }
    } catch (e) {
      debugPrint('Toggle error: $e');
    }
  }

  Future<void> _deleteBanner(int id) async {
    try {
      final res = await _apiService.delete('/admin/banners', queryParameters: {'id': id});
      if (res.data['success']) {
        _fetchBanners();
      }
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
          : _banners.isEmpty
              ? _buildEmptyState(navy)
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _banners.length,
                  itemBuilder: (context, index) {
                    final b = _banners[index];
                    return _buildBannerCard(b, navy, yellow);
                  },
                ),
    );
  }

  Widget _buildEmptyState(Color navy) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.collections_outlined, size: 64, color: navy.withOpacity(0.1)),
          const SizedBox(height: 16),
          Text('No hay banners configurados', 
            style: GoogleFonts.outfit(color: navy.withOpacity(0.4), fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _showBannerForm(),
            style: ElevatedButton.styleFrom(backgroundColor: navy),
            child: const Text('CREAR PRIMER BANNER', style: TextStyle(color: Colors.white)),
          ),
        ],
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
                  errorBuilder: (_, __, ___) => Container(height: 120, color: navy, child: const Icon(Icons.broken_image, color: Colors.white)),
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
                Text(b['title'], style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w900, color: navy)),
                const SizedBox(height: 4),
                Text(b['subtitle'] ?? 'Sin subtítulo', 
                  maxLines: 1, overflow: TextOverflow.ellipsis,
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
        title: const Text('¿Eliminar banner?'),
        content: const Text('Esta acción no se puede deshacer.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteBanner(id);
            }, 
            child: const Text('ELIMINAR', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}

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
    _isActive = widget.banner != null ? (widget.banner!['is_active'] == 1 || widget.banner!['is_active'] == true) : true;
  }

  Future<void> _pickAndUpload() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    if (image != null) {
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
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Imagen subida y optimizada con éxito'),
            backgroundColor: Colors.green,
          ));
        }
      } catch (e) {
        debugPrint('Upload error: $e');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Error al subir imagen al servidor'),
          backgroundColor: Colors.redAccent,
        ));
      } finally {
        setState(() => _isUploading = false);
      }
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
              
              _buildImageSelector(navy, yellow),
              
              const SizedBox(height: 24),
              _buildField('Título del Banner', _titleController, Icons.title_rounded, navy),
              const SizedBox(height: 16),
              _buildField('Subtítulo / Descripción corta', _subtitleController, Icons.short_text_rounded, navy),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(child: _buildField('Texto Botón', _ctaTextController, Icons.ads_click_rounded, navy)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildField('Link (/ruta)', _ctaLinkController, Icons.link_rounded, navy)),
                ],
              ),
              const SizedBox(height: 24),
              SwitchListTile(
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

  Widget _buildImageSelector(Color navy, Color yellow) {
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
                      Text('SUBIR IMAGEN DEL BANNER', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: navy)),
                      Text('Click para buscar en tu computadora', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
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

  Widget _buildField(String label, TextEditingController controller, IconData icon, Color navy) {
    return TextFormField(
      controller: controller,
      validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
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
