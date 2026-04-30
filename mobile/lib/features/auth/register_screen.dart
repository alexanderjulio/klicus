import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    const navy = Color(0xFF0E2244);
    const yellow = Color(0xFFE2E000);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: navy, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                
                // HEADER
                Text(
                  'Crea una cuenta\nElite',
                  style: GoogleFonts.outfit(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: navy,
                    letterSpacing: -1.5,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Únete a la mayor red de joyerías y negocios exclusivos.',
                  style: GoogleFonts.inter(
                    color: Colors.grey[500],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                
                const SizedBox(height: 48),

                // FORM FIELDS
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildEliteField(
                        controller: _nameController,
                        label: 'NOMBRE COMPLETO',
                        hint: 'Juan Pérez',
                        icon: Icons.person_outline_rounded,
                        navy: navy,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Ingresa tu nombre';
                          if (v.trim().length < 3) return 'Nombre muy corto';
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      _buildEliteField(
                        controller: _emailController,
                        label: 'CORREO ELECTRÓNICO',
                        hint: 'tu@email.com',
                        icon: Icons.alternate_email_rounded,
                        navy: navy,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Ingresa tu correo';
                          if (!v.contains('@') || !v.contains('.')) return 'Correo inválido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      _buildEliteField(
                        controller: _passwordController,
                        label: 'CONTRASEÑA',
                        hint: 'Mínimo 8 caracteres',
                        icon: Icons.lock_outline_rounded,
                        isPassword: true,
                        navy: navy,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Ingresa una contraseña';
                          if (v.length < 8) return 'Mínimo 8 caracteres';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                if (auth.error != null)
                  Container(
                    margin: const EdgeInsets.only(top: 24),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            auth.error!, 
                            style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 48),

                // ACTION BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    onPressed: auth.isLoading ? null : () async {
                      if (!_formKey.currentState!.validate()) return;
                      final success = await auth.register(
                        _nameController.text.trim(),
                        _emailController.text.trim(),
                        _passwordController.text,
                      );
                      if (success && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Cuenta Elite creada con éxito.', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                            backgroundColor: navy,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: yellow,
                      foregroundColor: navy,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 10,
                      shadowColor: yellow.withOpacity(0.3),
                    ),
                    child: auth.isLoading 
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: navy, strokeWidth: 2))
                      : Text(
                          'UNIRSE AHORA',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                            fontSize: 14,
                          ),
                        ),
                  ),
                ),

                const SizedBox(height: 40),
                
                Center(
                  child: Text(
                    'Al registrarte, declaras conocer y aceptar los\nTérminos y Condiciones de KLICUS ELITE.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: Colors.grey[400], 
                      fontSize: 10, 
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEliteField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color navy,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: navy.withOpacity(0.3),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: navy.withOpacity(0.03),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword,
            validator: validator,
            style: GoogleFonts.inter(color: navy, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[300], fontSize: 14),
              prefixIcon: Icon(icon, color: navy.withOpacity(0.2), size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 20),
            ),
          ),
        ),
      ],
    );
  }
}
