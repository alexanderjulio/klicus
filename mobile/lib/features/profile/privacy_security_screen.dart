import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../auth/auth_provider.dart';
import '../../core/repositories/user_repository.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  bool _isDeletingAccount = false;

  Future<void> _requestAccountClosure() async {
    const navy = Color(0xFF0E2244);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Confirmar cierre de cuenta',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: navy),
        ),
        content: Text(
          'Esta acción es irreversible. Se eliminarán todas tus pautas y datos. ¿Estás seguro?',
          style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[700]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancelar', style: GoogleFonts.outfit(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Eliminar cuenta', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isDeletingAccount = true);
    try {
      final response = await context.read<UserRepository>().deleteAccount();
      if (!mounted) return;
      if (response.statusCode == 200 || response.data['success'] == true) {
        final auth = context.read<AuthProvider>();
        await auth.logout();
        if (!mounted) return;
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.data['error'] ?? 'Error al cerrar cuenta')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error de conexión. Intenta nuevamente.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isDeletingAccount = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;
    const navy = Color(0xFF0E2244);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        title: const Text('PRIVACIDAD Y SEGURIDAD'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GESTIÓN DE CUENTA',
              style: GoogleFonts.outfit(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: navy.withOpacity(0.3),
              ),
            ),
            const SizedBox(height: 24),

            // IDENTITY CARD
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20)],
              ),
              child: Row(
                children: [
                   Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: navy.withOpacity(0.05), shape: BoxShape.circle),
                    child: const Icon(Icons.alternate_email_rounded, color: navy, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CORREO ELECTRÓNICO', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                        Text(
                          user?['email'] ?? 'No disponible',
                          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: navy),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            _buildSectionTitle('SEGURIDAD', navy),
            const SizedBox(height: 16),
            _buildSecurityAction(
              context,
              Icons.lock_reset_rounded,
              'Cambiar Contraseña',
              'Actualiza tu acceso periódicamente',
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Enlace de recuperación enviado a tu email'))
                );
              },
              navy,
            ),
            _buildSecurityAction(
              context,
              Icons.phonelink_lock_rounded,
              'Sesiones Activas',
              'Controla los dispositivos conectados',
              () {},
              navy,
            ),
            _buildSecurityAction(
              context,
              Icons.verified_user_rounded,
              'Autenticación de 2 Pasos',
              'Próximamente para socios Elite',
              null,
              navy,
            ),

             const SizedBox(height: 48),

            _buildSectionTitle('ELIMINACIÓN', navy),
            const SizedBox(height: 16),
             Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    '¿Deseas darte de baja de KLICUS?',
                    style: GoogleFonts.outfit(color: Colors.red[900], fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Esta acción es irreversible y eliminará tus pautas.',
                    style: GoogleFonts.inter(color: Colors.red[300], fontSize: 11),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _isDeletingAccount ? null : _requestAccountClosure,
                    child: _isDeletingAccount
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(color: Colors.red, strokeWidth: 2),
                          )
                        : Text('SOLICITAR CIERRE DE CUENTA', style: GoogleFonts.outfit(color: Colors.red, fontWeight: FontWeight.w900, fontSize: 11)),
                  ),
                ],
              ),
            ),
             const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color navy) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        letterSpacing: 2,
        color: navy.withOpacity(0.3),
      ),
    );
  }

  Widget _buildSecurityAction(BuildContext context, IconData icon, String title, String subtitle, VoidCallback? onTap, Color navy) {
    bool isEnabled = onTap != null;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isEnabled ? Colors.white : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (isEnabled) BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 5))
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Icon(icon, color: isEnabled ? navy : Colors.grey[300], size: 24),
        title: Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 15, 
            fontWeight: FontWeight.bold, 
            color: isEnabled ? navy : Colors.grey[400]
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[400]),
        ),
        trailing: isEnabled ? const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey) : null,
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
