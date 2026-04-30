import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/repositories/user_repository.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _marketing = true;
  bool _adStatus = true;
  bool _security = true;
  bool _news = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final response = await context.read<UserRepository>().getNotificationPreferences();
      if (response.data['success'] == true && mounted) {
        final prefs = response.data['preferences'];
        setState(() {
          _marketing = prefs['marketing'] ?? true;
          _adStatus = prefs['ad_status'] ?? true;
          _security = prefs['security'] ?? true;
          _news = prefs['news'] ?? false;
        });
      }
    } catch (e) {
      debugPrint('Load notification prefs error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0E2244);
    const yellow = Color(0xFFE2E000);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        title: const Text('CONFIGURACIÓN DE AVISOS'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CANALES DE COMUNICACIÓN',
              style: GoogleFonts.outfit(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: navy.withOpacity(0.3),
              ),
            ),
            const SizedBox(height: 24),

            _buildToggleItem(
              'Estado de mis Joyas',
              'Recibe avisos cuando tus pautas sean aprobadas o caduquen.',
              _adStatus,
              (v) => setState(() => _adStatus = v),
              navy,
              yellow,
            ),
            _buildToggleItem(
              'Alertas de Seguridad',
              'Notificaciones sobre inicios de sesión y cambios de cuenta.',
              _security,
              (v) => setState(() => _security = v),
              navy,
              yellow,
            ),
            _buildToggleItem(
              'Newsletter de la Red',
              'Tendencias del mercado y noticias de la comunidad.',
              _news,
              (v) => setState(() => _news = v),
              navy,
              yellow,
            ),
            _buildToggleItem(
              'Promociones y Ofertas',
              'Descuentos exclusivos para socios Diamante.',
              _marketing,
              (v) => setState(() => _marketing = v),
              navy,
              yellow,
            ),

            const SizedBox(height: 48),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : () async {
                  setState(() => _isSaving = true);
                  final messenger = ScaffoldMessenger.of(context);
                  final navigator = Navigator.of(context);
                  final repo = context.read<UserRepository>();
                  try {
                    final response = await repo.updateNotificationPreferences({
                      'marketing': _marketing,
                      'ad_status': _adStatus,
                      'security': _security,
                      'news': _news,
                    });
                    if (response.data['success'] == true) {
                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text('Preferencias guardadas correctamente'),
                          backgroundColor: Color(0xFF0E2244),
                        ),
                      );
                      navigator.pop();
                    } else {
                      messenger.showSnackBar(
                        SnackBar(content: Text(response.data['error'] ?? 'Error al guardar')),
                      );
                    }
                  } catch (e) {
                    messenger.showSnackBar(
                      const SnackBar(content: Text('Error de conexión al guardar preferencias')),
                    );
                  } finally {
                    if (mounted) setState(() => _isSaving = false);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: navy,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Text('GUARDAR PREFERENCIAS', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
              ),
            ),
             const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem(String title, String subtitle, bool value, Function(bool) onChanged, Color navy, Color yellow) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: navy),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: yellow,
            activeTrackColor: navy.withOpacity(0.1),
            inactiveThumbColor: Colors.grey[300],
            inactiveTrackColor: Colors.grey[100],
          ),
        ],
      ),
    );
  }
}
