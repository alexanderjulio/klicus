import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/nav_provider.dart';
import 'auth_provider.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    const navy = Color(0xFF0E2244);
    const yellow = Color(0xFFE2E000);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              children: [
                const SizedBox(height: 60),
                
                // BRANDING ELITE
                Center(
                  child: Column(
                    children: [
                      Text(
                        'KLICUS',
                        style: GoogleFonts.outfit(
                          color: navy,
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -2,
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: yellow,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'MARKETPLACE',
                        style: GoogleFonts.outfit(
                          color: navy.withOpacity(0.4),
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 6,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 80),

                // WELCOME MESSAGE
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bienvenido',
                        style: GoogleFonts.outfit(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: navy,
                          letterSpacing: -1,
                        ),
                      ),
                      Text(
                        'Inicia sesión para gestionar tus anuncios.',
                        style: GoogleFonts.inter(
                          color: Colors.grey[500],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // EMAIL FIELD
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

                      // PASSWORD FIELD
                      _buildEliteField(
                        controller: _passwordController,
                        label: 'CONTRASEÑA',
                        hint: '••••••••',
                        icon: Icons.lock_outline_rounded,
                        isPassword: true,
                        navy: navy,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Ingresa tu contraseña';
                          if (v.length < 6) return 'Mínimo 6 caracteres';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                
                // FORGOT PASSWORD
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Función próximamente', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                          backgroundColor: navy,
                        ),
                      );
                    },
                    child: Text(
                      '¿Olvidaste tu contraseña?',
                      style: GoogleFonts.inter(
                        color: navy.withOpacity(0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                if (auth.error != null)
                  Container(
                    margin: const EdgeInsets.only(top: 16),
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

                const SizedBox(height: 40),

                // LOGIN BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    onPressed: auth.isLoading ? null : () async {
                      if (!_formKey.currentState!.validate()) return;
                      final navigator = Navigator.of(context);
                      final success = await auth.login(_emailController.text.trim(), _passwordController.text);
                      if (success && mounted) navigator.pushReplacementNamed('/home');
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
                          'INICIAR SESIÓN',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                            fontSize: 14,
                          ),
                        ),
                  ),
                ),

                const SizedBox(height: 32),

                // REGISTER LINK
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
                  },
                  child: RichText(
                    text: TextSpan(
                      text: '¿Eres nuevo? ',
                      style: GoogleFonts.inter(color: Colors.grey[500], fontWeight: FontWeight.w500),
                      children: [
                        TextSpan(
                          text: 'Crea una cuenta Elite',
                          style: GoogleFonts.inter(
                            color: navy,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // GUEST ACCESS PREMIUM BUTTON
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.read<NavigationProvider>().setIndex(0);
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    icon: const Icon(Icons.explore_outlined, size: 18),
                    label: Text(
                      'EXPLORAR ANUNCIOS',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        fontSize: 12,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: navy.withOpacity(0.5),
                      side: BorderSide(color: navy.withOpacity(0.1), width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
                
                const SizedBox(height: 48),
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
