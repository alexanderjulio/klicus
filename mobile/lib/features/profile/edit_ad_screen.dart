import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;
import 'package:google_fonts/google_fonts.dart';
import '../../core/repositories/ad_repository.dart';
import '../../models/ad_model.dart';

class EditAdScreen extends StatefulWidget {
  final AdModel ad;
  const EditAdScreen({super.key, required this.ad});

  @override
  State<EditAdScreen> createState() => _EditAdScreenState();
}

class _EditAdScreenState extends State<EditAdScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _locationController;
  late TextEditingController _priceController;
  late TextEditingController _cellphoneController;
  late TextEditingController _webController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _facebookController;
  late TextEditingController _instagramController;
  late TextEditingController _businessHoursController;
  late TextEditingController _addressController;
  late TextEditingController _deliveryInfoController;
  
  late List<String> _currentImageUrls;
  final List<XFile> _newImages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Timer? _draftTimer;
  static const _draftPrefix = 'klicus_draft_';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.ad.title);
    _descController = TextEditingController(text: widget.ad.description);
    _locationController = TextEditingController(text: widget.ad.location);
    _priceController = TextEditingController(text: widget.ad.priceRange ?? '');
    _cellphoneController = TextEditingController(text: widget.ad.cellphone ?? '');
    _webController = TextEditingController(text: widget.ad.websiteUrl ?? '');
    _phoneController = TextEditingController(text: widget.ad.phone ?? '');
    _emailController = TextEditingController(text: widget.ad.email ?? '');
    _facebookController = TextEditingController(text: widget.ad.facebookUrl ?? '');
    _instagramController = TextEditingController(text: widget.ad.instagramUrl ?? '');
    _businessHoursController = TextEditingController(text: widget.ad.businessHours ?? '');
    _addressController = TextEditingController(text: widget.ad.address ?? '');
    _deliveryInfoController = TextEditingController(text: widget.ad.deliveryInfo ?? '');
    _currentImageUrls = List.from(widget.ad.imageUrls);
    _loadDraft();
    _draftTimer = Timer.periodic(const Duration(seconds: 3), (_) => _saveDraft());
  }

  @override
  void dispose() {
    _draftTimer?.cancel();
    _titleController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _cellphoneController.dispose();
    _webController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _facebookController.dispose();
    _instagramController.dispose();
    _businessHoursController.dispose();
    _addressController.dispose();
    _deliveryInfoController.dispose();
    super.dispose();
  }

  String get _draftKey => '$_draftPrefix${widget.ad.id}';

  Future<void> _saveDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final map = {
      'title': _titleController.text,
      'description': _descController.text,
      'location': _locationController.text,
      'price_range': _priceController.text,
      'cellphone': _cellphoneController.text,
      'website_url': _webController.text,
      'phone': _phoneController.text,
      'email': _emailController.text,
      'facebook_url': _facebookController.text,
      'instagram_url': _instagramController.text,
      'business_hours': _businessHoursController.text,
      'address': _addressController.text,
      'delivery_info': _deliveryInfoController.text,
    };
    await prefs.setString(_draftKey, jsonEncode(map));
  }

  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_draftKey);
    if (raw == null) return;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      if (mounted) {
        setState(() {
          if ((map['title'] as String? ?? '').isNotEmpty) _titleController.text = map['title'];
          if ((map['description'] as String? ?? '').isNotEmpty) _descController.text = map['description'];
          if ((map['location'] as String? ?? '').isNotEmpty) _locationController.text = map['location'];
          if ((map['price_range'] as String? ?? '').isNotEmpty) _priceController.text = map['price_range'];
          if ((map['cellphone'] as String? ?? '').isNotEmpty) _cellphoneController.text = map['cellphone'];
          if ((map['website_url'] as String? ?? '').isNotEmpty) _webController.text = map['website_url'];
          if ((map['phone'] as String? ?? '').isNotEmpty) _phoneController.text = map['phone'];
          if ((map['email'] as String? ?? '').isNotEmpty) _emailController.text = map['email'];
          if ((map['facebook_url'] as String? ?? '').isNotEmpty) _facebookController.text = map['facebook_url'];
          if ((map['instagram_url'] as String? ?? '').isNotEmpty) _instagramController.text = map['instagram_url'];
          if ((map['business_hours'] as String? ?? '').isNotEmpty) _businessHoursController.text = map['business_hours'];
          if ((map['address'] as String? ?? '').isNotEmpty) _addressController.text = map['address'];
          if ((map['delivery_info'] as String? ?? '').isNotEmpty) _deliveryInfoController.text = map['delivery_info'];
        });
      }
    } catch (_) {}
  }

  Future<void> _clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_draftKey);
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final compressed = await _compressImage(image);
      setState(() {
        _newImages.add(compressed);
      });
    }
  }

  Future<XFile> _compressImage(XFile original) async {
    if (kIsWeb) return original;
    try {
      final dir = await getTemporaryDirectory();
      final targetPath = '${dir.path}/c_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final result = await FlutterImageCompress.compressAndGetFile(
        original.path,
        targetPath,
        quality: 85,
        minWidth: 1280,
        minHeight: 1280,
        keepExif: false,
      );
      if (result == null) return original;
      // If still > 1MB, compress harder
      final size = await result.length();
      if (size > 1024 * 1024) {
        final retry = await FlutterImageCompress.compressAndGetFile(
          result.path,
          '${dir.path}/c2_${DateTime.now().millisecondsSinceEpoch}.jpg',
          quality: 60,
          minWidth: 960,
          minHeight: 960,
          keepExif: false,
        );
        if (retry != null) return XFile(retry.path);
      }
      return XFile(result.path);
    } catch (e) {
      debugPrint('Image compression error: $e');
      return original;
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition();
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty && mounted) {
        final p = placemarks.first;
        final parts = [p.locality, p.administrativeArea, p.country]
            .where((s) => s != null && s.isNotEmpty)
            .join(', ');
        setState(() {
          _locationController.text = parts.isNotEmpty
              ? parts
              : '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _locationController.text =
              '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
        });
      }
    }
  }

  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);
    try {
      // Use dio.FormData which correctly handles lists of keys
      final formDataMap = {
        'title': _titleController.text,
        'description': _descController.text,
        'location': _locationController.text,
        'price_range': _priceController.text,
        'cellphone': _cellphoneController.text,
        'website_url': _webController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'facebook_url': _facebookController.text,
        'instagram_url': _instagramController.text,
        'business_hours': _businessHoursController.text,
        'address': _addressController.text,
        'delivery_info': _deliveryInfoController.text,
        'kept_images': _currentImageUrls, 
      };

      final formData = dio.FormData.fromMap(formDataMap);

      // Add new files (Platform-aware logic)
      for (var file in _newImages) {
        if (kIsWeb) {
          // Web: Use Bytes
          formData.files.add(MapEntry(
            'images',
            dio.MultipartFile.fromBytes(
              await file.readAsBytes(), 
              filename: file.name
            ),
          ));
        } else {
          // Mobile: Use File system
          formData.files.add(MapEntry(
            'images',
            await dio.MultipartFile.fromFile(file.path),
          ));
        }
      }

      final response = await context.read<AdRepository>().updateAd(widget.ad.id.toString(), formData);
      
      if (response.statusCode == 200) {
        await _clearDraft();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Anuncio actualizado con éxito')));
          Navigator.pop(context, true);
        }
      } else {
        throw dio.DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Error al actualizar: ${response.data['error'] ?? 'Desconocido'}',
        );
      }
    } catch (e) {
      String errorMessage = e.toString();
      if (e is dio.DioException) {
        errorMessage = e.response?.data?['error'] ?? e.message ?? 'Error de conexión';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $errorMessage')));
      }
    } finally {
      setState(() => _isLoading = false);
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
          'EDITAR ANUNCIO',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(label: 'TÍTULO', controller: _titleController),
            const SizedBox(height: 24),
            _buildTextField(label: 'DESCRIPCIÓN', controller: _descController, maxLines: 5),
            const SizedBox(height: 24),
            
            Row(
              children: [
                Expanded(child: _buildTextField(label: 'UBICACIÓN', controller: _locationController)),
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: IconButton(
                    onPressed: _getCurrentLocation,
                    icon: const Icon(Icons.my_location, color: navy),
                    style: IconButton.styleFrom(backgroundColor: Colors.white, padding: const EdgeInsets.all(16), elevation: 1, shadowColor: Colors.black12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            _buildTextField(label: 'DIRECCIÓN EXACTA', controller: _addressController),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildTextField(label: 'PRECIO / RANGO', controller: _priceController, keyboardType: TextInputType.text, hint: 'Ej: 50.000 - 100.000')),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField(label: 'WHATSAPP / CEL', controller: _cellphoneController, keyboardType: TextInputType.phone, hint: '313...')),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildTextField(label: 'TELÉFONO FIJO', controller: _phoneController, keyboardType: TextInputType.phone)),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField(label: 'CORREO ELECTRÓNICO', controller: _emailController, keyboardType: TextInputType.emailAddress)),
              ],
            ),
            const SizedBox(height: 24),
            _buildTextField(label: 'HORARIO DE ATENCIÓN', controller: _businessHoursController, hint: 'Ej: Lunes a Viernes 8am - 6pm'),
            const SizedBox(height: 24),
            _buildTextField(label: 'INFO. DE ENVÍO / DOMICILIO', controller: _deliveryInfoController, hint: 'Ej: Envíos gratis a todo el país'),
            const SizedBox(height: 32),
            Text('ENLACES Y REDES SOCIALES', style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2, color: navy.withOpacity(0.4))),
            const SizedBox(height: 16),
            _buildTextField(label: 'SITIO WEB / LINK', controller: _webController, keyboardType: TextInputType.url, hint: 'https://...'),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildTextField(label: 'FACEBOOK URL', controller: _facebookController, keyboardType: TextInputType.url)),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField(label: 'INSTAGRAM URL', controller: _instagramController, keyboardType: TextInputType.url)),
              ],
            ),
            
            const SizedBox(height: 32),
            Text('IMÁGENES', style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2, color: navy.withOpacity(0.4))),
            const SizedBox(height: 12),
            
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(_currentImageUrls.length + _newImages.length + 1, (index) {
                final double screenWidth = MediaQuery.of(context).size.width;
                final double itemWidth = math.max(0.0, (screenWidth - 48 - 24) / 3);
                
                if (index < _currentImageUrls.length) {
                  return SizedBox(
                    width: itemWidth,
                    height: itemWidth,
                    child: _ImagePreview(
                      url: _currentImageUrls[index],
                      onDelete: () => setState(() => _currentImageUrls.removeAt(index)),
                    ),
                  );
                } else if (index < _currentImageUrls.length + _newImages.length) {
                  final newIndex = index - _currentImageUrls.length;
                  return SizedBox(
                    width: itemWidth,
                    height: itemWidth,
                    child: _FilePreview(
                      file: _newImages[newIndex],
                      onDelete: () => setState(() => _newImages.removeAt(newIndex)),
                    ),
                  );
                } else {
                  return SizedBox(
                    width: itemWidth,
                    height: itemWidth,
                    child: _AddButton(onTap: _pickImage),
                  );
                }
              }),
            ),
            
            const SizedBox(height: 48),
            
            SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: navy,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 5,
                  shadowColor: navy.withOpacity(0.3),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text('GUARDAR CAMBIOS', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1, fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label, 
    required TextEditingController controller, 
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? hint,
  }) {
    const navy = Color(0xFF0E2244);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2, color: navy.withOpacity(0.4))),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 5)),
            ],
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, color: navy),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.inter(color: Colors.grey[400], fontSize: 12, fontWeight: FontWeight.normal),
              filled: true,
              fillColor: Colors.transparent,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}

class _ImagePreview extends StatelessWidget {
  final String url;
  final VoidCallback onDelete;
  const _ImagePreview({required this.url, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              url, 
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[100],
                child: const Center(child: Icon(Icons.image_not_supported_outlined, color: Colors.grey, size: 20)),
              ),
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: onDelete,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.close, size: 14, color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}

class _FilePreview extends StatelessWidget {
  final XFile file;
  final VoidCallback onDelete;
  const _FilePreview({required this.file, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: kIsWeb 
              ? Image.network(file.path, fit: BoxFit.cover) // Web uses blob URL
              : Image.file(File(file.path), fit: BoxFit.cover), // Mobile uses path
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: onDelete,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.close, size: 14, color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!, width: 2),
        ),
        child: const Icon(Icons.add_a_photo_outlined, color: Colors.grey),
      ),
    );
  }
}
