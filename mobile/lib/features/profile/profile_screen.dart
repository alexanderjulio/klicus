import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth/auth_provider.dart';
import 'user_ads_screen.dart';
import 'business_info_screen.dart';
import '../admin/admin_push_screen.dart';
import '../admin/admin_marketing_screen.dart';
import '../admin/admin_analytics_screen.dart';
import 'privacy_security_screen.dart';
import 'notification_settings_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';
import '../../core/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh stats when entering profile
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().fetchDashboardStats();
    });
  }

  void _showLogoutConfirmation(BuildContext context) {
    const navy = Color(0xFF0E2244);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Text(
          '¿CERRAR SESIÓN?',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 18, color: navy),
        ),
        content: Text(
          '¿Estás seguro de que deseas salir de tu cuenta Elite?',
          style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CANCELAR', style: GoogleFonts.outfit(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () {
              final auth = Provider.of<AuthProvider>(context, listen: false);
              auth.logout();
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: navy,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('SÍ, SALIR'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;
    final stats = auth.dashboardStats;
    const navy = Color(0xFF0E2244);
    const yellow = Color(0xFFE2E000);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MI CUENTA',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: navy,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 24),

              // HEADER SECTION (BANNER + AVATAR)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(color: navy.withOpacity(0.04), blurRadius: 30, offset: const Offset(0, 10))
                  ],
                ),
                child: Column(
                  children: [
                    // Banner Part
                    Stack(
                      alignment: Alignment.bottomCenter,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 140,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: navy,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
                            image: user?['banner_url'] != null ? DecorationImage(
                              image: CachedNetworkImageProvider(user!['banner_url']),
                              fit: BoxFit.cover,
                            ) : null,
                          ),
                        ),
                        if (user?['banner_url'] != null)
                          Positioned.fill(
                            child: Container(decoration: BoxDecoration(color: navy.withOpacity(0.3), borderRadius: const BorderRadius.vertical(top: Radius.circular(35)))),
                          ),
                        Positioned(
                          bottom: -40,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: CircleAvatar(
                              radius: 45,
                              backgroundColor: yellow,
                              backgroundImage: user?['avatar_url'] != null ? CachedNetworkImageProvider(ApiService.normalizeUrl(user!['avatar_url'])) : null,
                              child: user?['avatar_url'] == null ? const Icon(Icons.business_center_rounded, color: navy, size: 30) : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    
                    // Name & Stats
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      child: Column(
                        children: [
                          Text(
                            user?['business_name']?.toUpperCase() ?? 
                            user?['full_name']?.toUpperCase() ?? 
                            user?['name']?.toUpperCase() ?? 
                            'SOCIO KLICUS',
                            style: GoogleFonts.outfit(
                              color: navy,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'SOCIO DIAMANTE VERIFICADO',
                            style: GoogleFonts.outfit(
                              color: yellow,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 3,
                            ),
                          ),
                          
                          if (user?['bio'] != null && user!['bio'].toString().isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(
                              user!['bio'],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: Colors.grey[600],
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                          ],

                          const SizedBox(height: 24),
                          const Divider(color: Color(0xFFF4F7FA)),
                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem('VISTAS', '${stats?['totalViews'] ?? 0}', navy),
                              _buildStatItem('ANUNCIOS', '${stats?['activeAds'] ?? 0}', navy),
                              _buildStatItem('CLICKS', '${stats?['totalClicks'] ?? 0}', navy),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              _buildSectionTitle('GESTIÓN PROFESIONAL', navy),
              const SizedBox(height: 16),
              _buildMenuAction(
                context,
                Icons.ads_click_rounded,
                'Mis Pautas Publicadas',
                'Gestionar, editar y ver analíticas',
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UserAdsScreen())),
                navy,
              ),
              _buildMenuAction(
                context,
                Icons.edit_note_rounded,
                'Datos de Negocio',
                'Nombre, Bio y Redes Sociales',
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BusinessInfoScreen())),
                navy,
              ),

              const SizedBox(height: 32),

              _buildSectionTitle('CONFIGURACIÓN', navy),
              const SizedBox(height: 16),
              _buildMenuAction(
                context,
                Icons.notifications_none_rounded,
                'Notificaciones',
                'Preferencias de avisos push',
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationSettingsScreen())),
                navy,
              ),
              _buildMenuAction(
                context,
                Icons.security_rounded,
                'Privacidad y Seguridad',
                'Cambiar contraseña y accesos',
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacySecurityScreen())),
                navy,
              ),

              if (user?['role'] == 'admin') ...[
                const SizedBox(height: 32),
                _buildSectionTitle('ADMINISTRACIÓN', navy),
                const SizedBox(height: 16),
                _buildMenuAction(
                  context,
                  Icons.campaign_rounded,
                  'Centro de Notificaciones',
                  'Enviar avisos Push a la red',
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminPushScreen())),
                  navy,
                ),
                _buildMenuAction(
                  context,
                  Icons.collections_outlined,
                  'Gestión de Marketing',
                  'Administrar banners del Home',
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminMarketingScreen())),
                  navy,
                ),
              ],

              const SizedBox(height: 48),

              // LOGOUT BUTTON
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => _showLogoutConfirmation(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                  child: Text(
                    'CERRAR SESIÓN',
                    style: GoogleFonts.outfit(
                      color: Colors.red[400],
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color navy) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.outfit(
            color: navy,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.outfit(
            color: Colors.grey[400],
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ],
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

  Widget _buildMenuAction(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap, Color navy) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 5))
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.grey[50], shape: BoxShape.circle),
          child: Icon(icon, color: navy, size: 22),
        ),
        title: Text(
          title,
          style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: navy),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[400]),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
