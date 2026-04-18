import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../auth/auth_provider.dart';

class BusinessInfoScreen extends StatefulWidget {
  const BusinessInfoScreen({super.key});

  @override
  State<BusinessInfoScreen> createState() => _BusinessInfoScreenState();
}

class _BusinessInfoScreenState extends State<BusinessInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _businessNameController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  late TextEditingController _websiteController;
  late TextEditingController _bannerController;
  late TextEditingController _instagramController;
  late TextEditingController _facebookController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    _nameController = TextEditingController(text: user?['full_name'] ?? '');
    _businessNameController = TextEditingController(text: user?['business_name'] ?? '');
    _phoneController = TextEditingController(text: user?['phone'] ?? '');
    _bioController = TextEditingController(text: user?['bio'] ?? '');
    _websiteController = TextEditingController(text: user?['website'] ?? '');
    _bannerController = TextEditingController(text: user?['banner_url'] ?? '');
    
    // Parse social links if present
    final social = user?['social_links'];
    _instagramController = TextEditingController(text: social?['instagram'] ?? '');
    _facebookController = TextEditingController(text: social?['facebook'] ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _businessNameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _websiteController.dispose();
    _bannerController.dispose();
    _instagramController.dispose();
    _facebookController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    
    final success = await context.read<AuthProvider>().updateProfile({
      'full_name': _nameController.text.trim(),
      'business_name': _businessNameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'bio': _bioController.text.trim(),
      'website': _websiteController.text.trim(),
      'banner_url': _bannerController.text.trim(),
      'social_links': {
        'instagram': _instagramController.text.trim(),
        'facebook': _facebookController.text.trim(),
      }
    });

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Perfil actualizado con éxito 💎', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.green[700],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        );
      } else {
        final error = context.read<AuthProvider>().error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Error al guardar cambios', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.red[700],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0E2244);
    const yellow = Color(0xFFE2E000);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: navy, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'GESTIÓN DE IDENTIDAD',
          style: GoogleFonts.outfit(
            color: navy,
            fontWeight: FontWeight.w900,
            fontSize: 18,
            letterSpacing: 1,
          ),
        ),
        actions: [
          if (_isSaving)
            const Center(child: Padding(padding: EdgeInsets.only(right: 20), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: navy))))
          else
            TextButton(
              onPressed: _handleSave,
              child: Text(
                'GUARDAR',
                style: GoogleFonts.outfit(color: navy, fontWeight: FontWeight.w900, fontSize: 13),
              ),
            ),
        ],
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER CARD
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [navy, Color(0xFF1A3A6D)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(color: navy.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(color: yellow, borderRadius: BorderRadius.circular(15)),
                      child: const Icon(Icons.edit_note_rounded, color: navy, size: 30),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CONSOLA DE SOCIO',
                            style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Actualiza tu presencia en la red',
                            style: GoogleFonts.inter(color: yellow.withOpacity(0.8), fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),

              _buildSectionHeader('INFORMACIÓN PÚBLICA', navy),
              const SizedBox(height: 20),
              
              _buildEliteInput(
                controller: _businessNameController,
                label: 'NOMBRE DE NEGOCIO / MARCA',
                icon: Icons.business_rounded,
                hint: 'Ej: Joyería La Elite',
              ),

              _buildEliteInput(
                controller: _bioController,
                label: 'BIOGRAFÍA / DESCRIPCIÓN',
                icon: Icons.description_outlined,
                hint: 'Cuéntanos qué hace especial a tu negocio...',
                maxLines: 4,
              ),

              const SizedBox(height: 32),

              _buildSectionHeader('DATOS DE CONTACTO', navy),
              const SizedBox(height: 20),

              _buildEliteInput(
                controller: _nameController,
                label: 'REPRESENTANTE LEGAL',
                icon: Icons.person_outline_rounded,
                hint: 'Tu nombre completo',
              ),

              _buildEliteInput(
                controller: _phoneController,
                label: 'WHATSAPP / TELÉFONO',
                icon: Icons.phone_outlined,
                hint: 'Ej: 300 000 0000',
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 32),

              _buildSectionHeader('PRESENCIA DIGITAL', navy),
              const SizedBox(height: 20),

              _buildEliteInput(
                controller: _websiteController,
                label: 'SITIO WEB CORPORATIVO',
                icon: Icons.language_rounded,
                hint: 'https://www.tuweb.com',
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value != null && value.isNotEmpty && !value.startsWith('https://')) {
                    return 'Debe comenzar con https://';
                  }
                  return null;
                },
              ),

              _buildEliteInput(
                controller: _bannerController,
                label: 'URL FOTO DE PORTADA (BANNER)',
                icon: Icons.image_outlined,
                hint: 'https://imagen.com/banner.jpg',
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value != null && value.isNotEmpty && !value.startsWith('https://')) {
                    return 'Debe comenzar con https://';
                  }
                  return null;
                },
              ),

              _buildEliteInput(
                controller: _instagramController,
                label: 'INSTAGRAM (URL)',
                icon: Icons.camera_alt_outlined,
                hint: 'https://instagram.com/tuperfil',
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value != null && value.isNotEmpty && !value.startsWith('https://')) {
                    return 'Debe comenzar con https://';
                  }
                  return null;
                },
              ),

              _buildEliteInput(
                controller: _facebookController,
                label: 'FACEBOOK (URL)',
                icon: Icons.facebook_outlined,
                hint: 'https://facebook.com/tupagina',
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value != null && value.isNotEmpty && !value.startsWith('https://')) {
                    return 'Debe comenzar con https://';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 48),
              
              const Center(
                child: Text(
                  'Cualquier cambio se reflejará de inmediato\nen tus anuncios activos.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 11, fontStyle: FontStyle.italic),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color navy) {
    return Row(
      children: [
        Container(width: 4, height: 14, color: const Color(0xFFE2E000)),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2, color: navy.withOpacity(0.4)),
        ),
      ],
    );
  }

  Widget _buildEliteInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    const navy = Color(0xFF0E2244);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: navy),
        decoration: InputDecoration(
          labelText: label,
// ... (rest of decoration is the same)
          labelStyle: GoogleFonts.outfit(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.grey[400], letterSpacing: 1),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[300], fontSize: 14),
          prefixIcon: Icon(icon, color: navy.withOpacity(0.2), size: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }
}
