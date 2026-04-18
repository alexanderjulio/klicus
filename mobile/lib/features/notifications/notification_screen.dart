import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'notification_provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh notifications on open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0E2244);
    const yellow = Color(0xFFE2E000);
    final provider = Provider.of<NotificationProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        title: const Text('CENTRO DE INTERACCIÓN'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: navy, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () => provider.markAsRead(all: true),
            child: Text(
              'LEER TODO',
              style: GoogleFonts.outfit(color: navy, fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: provider.isLoading && provider.notifications.isEmpty
          ? const Center(child: CircularProgressIndicator(color: navy))
          : RefreshIndicator(
              onRefresh: () => provider.fetchNotifications(),
              color: navy,
              child: provider.notifications.isEmpty
                  ? _buildEmptyState(navy)
                  : ListView.builder(
                      padding: const EdgeInsets.all(24),
                      itemCount: provider.notifications.length,
                      itemBuilder: (context, index) {
                        final notification = provider.notifications[index];
                        return _NotificationTile(notification: notification, navy: navy, yellow: yellow);
                      },
                    ),
            ),
    );
  }

  Widget _buildEmptyState(Color navy) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none_rounded, size: 80, color: navy.withOpacity(0.1)),
          const SizedBox(height: 24),
          Text(
            'SIN MENSAJES NUEVOS',
            style: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: navy.withOpacity(0.3), letterSpacing: 1),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final dynamic notification;
  final Color navy;
  final Color yellow;

  const _NotificationTile({required this.notification, required this.navy, required this.yellow});

  @override
  Widget build(BuildContext context) {
    final isRead = notification['is_read'] == 1 || notification['is_read'] == true;
    final type = notification['type'] ?? 'system';
    
    // UI Helpers based on type
    final IconData icon;
    final Color accent;
    
    switch(type) {
      case 'marketing':
        icon = Icons.star_border_purple500_rounded;
        accent = yellow;
        break;
      case 'ad_status':
        icon = Icons.ads_click_rounded;
        accent = Colors.blueAccent;
        break;
      default:
        icon = Icons.info_outline_rounded;
        accent = navy.withOpacity(0.5);
    }

    return GestureDetector(
      onTap: () {
        if (!isRead) {
          context.read<NotificationProvider>().markAsRead(id: notification['id'].toString());
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isRead ? Colors.white.withOpacity(0.7) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: isRead ? null : Border.all(color: yellow.withOpacity(0.5), width: 1),
          boxShadow: [
            BoxShadow(
              color: isRead ? Colors.transparent : navy.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accent, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        type.toString().toUpperCase(),
                        style: GoogleFonts.outfit(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: accent,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        _formatDate(notification['created_at']),
                        style: GoogleFonts.inter(fontSize: 10, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification['title'] ?? 'Notificación KLICUS',
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: isRead ? FontWeight.bold : FontWeight.w900,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification['message'] ?? '',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(dynamic dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr.toString());
      return DateFormat('MMM d, HH:mm').format(date);
    } catch (e) {
      return dateStr.toString();
    }
  }
}
