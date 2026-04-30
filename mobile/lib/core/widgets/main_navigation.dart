import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../nav_provider.dart';
import '../../features/home/home_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/auth/auth_provider.dart';
import '../../features/auth/login_screen.dart';
import '../../features/chat/chat_list_screen.dart';
import '../../features/notifications/notification_provider.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final nav = Provider.of<NavigationProvider>(context);

    final List<Widget> screens = [
      const HomeScreen(),
      const ChatListScreen(), // Always allow, even as guest
      auth.isAuthenticated ? const ProfileScreen() : const LoginScreen(),
    ];

    return Scaffold(
      extendBody: false,
      body: IndexedStack(
        index: nav.currentIndex,
        children: screens,
      ),
      bottomNavigationBar: _buildGlassNavigationBar(context, nav),
    );
  }

  Widget _buildGlassNavigationBar(BuildContext context, NavigationProvider nav) {
    const navy = Color(0xFF0E2244);

    return Container(
      decoration: BoxDecoration(
        color: navy,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, -5), // Shadow upwards for depth
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, 0, Icons.storefront_outlined, Icons.storefront, 'MARKET'),
              Consumer<NotificationProvider>(
                builder: (context, notif, child) => 
                  _buildNavItem(context, 1, Icons.chat_bubble_outline_rounded, Icons.chat_bubble_rounded, 'CHATS', hasBadge: notif.unreadCount > 0),
              ),
              _buildNavItem(context, 2, Icons.person_outline_rounded, Icons.person_rounded, 'PERFIL'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData outlineIcon, IconData solidIcon, String label, {bool hasBadge = false}) {
    final nav = Provider.of<NavigationProvider>(context);
    final isSelected = nav.currentIndex == index;
    const yellow = Color(0xFFE2E000);
    
    return GestureDetector(
      onTap: () => nav.setIndex(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutExpo,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? yellow.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.15 : 1.0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutBack,
                  child: Icon(
                    isSelected ? solidIcon : outlineIcon,
                    color: isSelected ? yellow : Colors.white.withOpacity(0.6),
                    size: 24,
                  ),
                ),
                if (hasBadge) 
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(color: yellow, shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 1.5)),
                    ),
                  ),
              ],
            ),
            if (isSelected) ...[
              const SizedBox(width: 10),
              Text(
                label,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
