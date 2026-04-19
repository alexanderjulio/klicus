import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/api_service.dart';
import '../../models/ad_model.dart';
import '../auth/auth_provider.dart';

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
  
  late List<String> _currentImageUrls;
  final List<XFile> _newImages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.ad.title);
    _descController = TextEditingController(text: widget.ad.description);
    _locationController = TextEditingController(text: widget.ad.location);
    _priceController = TextEditingController(text: widget.ad.priceRange ?? '');
    _cellphoneController = TextEditingController(text: widget.ad.cellphone ?? '');
    _webController = TextEditingController(text: widget.ad.websiteUrl ?? '');
    _currentImageUrls = List.from(widget.ad.imageUrls);
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _newImages.add(image);
      });
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
    // For now, we'll just show the coordinates or simple title 
    // In a real app, we'd reverse geocode here.
    setState(() {
      _locationController.text = "GPS: ${position.latitude.toStringAsFixed(3)}, ${position.longitude.toStringAsFixed(3)}";
    });
  }

  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);
    try {
      final api = context.read<ApiService>();
      
      // Use dio.FormData which correctly handles lists of keys
      final formDataMap = {
        'title': _titleController.text,
        'description': _descController.text,
        'location': _locationController.text,
        'price_range': _priceController.text,
        'cellphone': _cellphoneController.text,
        'website_url': _webController.text,
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

      final response = await api.put("/anuncio/${widget.ad.id}", data: formData);
      
      if (response.statusCode == 200) {
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('EDITAR ANUNCIO'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(color: Color(0xFFE2E000), fontWeight: FontWeight.w900, fontSize: 18),
        iconTheme: const IconThemeData(color: Color(0xFFE2E000)),
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
                    icon: const Icon(Icons.my_location, color: Color(0xFFE2E000)),
                    style: IconButton.styleFrom(backgroundColor: Colors.grey[100], padding: const EdgeInsets.all(16)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(child: _buildTextField(label: 'PRECIO / RANGO', controller: _priceController, keyboardType: TextInputType.text, hint: 'Ej: 50.000 - 100.000')),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField(label: 'WHATSAPP / CEL', controller: _cellphoneController, keyboardType: TextInputType.phone, hint: '313...')),
              ],
            ),
            const SizedBox(height: 24),
            _buildTextField(label: 'SITIO WEB / LINK', controller: _webController, keyboardType: TextInputType.url, hint: 'https://...'),
            
            const SizedBox(height: 32),
            const Text('IMÁGENES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.grey)),
            const SizedBox(height: 12),
            
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemCount: _currentImageUrls.length + _newImages.length + 1,
              itemBuilder: (context, index) {
                if (index < _currentImageUrls.length) {
                  return _ImagePreview(
                    url: _currentImageUrls[index],
                    onDelete: () => setState(() => _currentImageUrls.removeAt(index)),
                  );
                } else if (index < _currentImageUrls.length + _newImages.length) {
                  final newIndex = index - _currentImageUrls.length;
                  return _FilePreview(
                    file: _newImages[newIndex],
                    onDelete: () => setState(() => _newImages.removeAt(newIndex)),
                  );
                } else {
                  return _AddButton(onTap: _pickImage);
                }
              },
            ),
            
            const SizedBox(height: 48),
            
            SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE2E000),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Color(0xFF0E2244))
                  : const Text('GUARDAR CAMBIOS', style: TextStyle(color: Color(0xFF0E2244), fontWeight: FontWeight.w900, letterSpacing: 1)),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.grey)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[300], fontSize: 12, fontWeight: FontWeight.normal),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
