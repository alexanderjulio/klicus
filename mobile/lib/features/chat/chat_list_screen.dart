import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/services/image_cache_manager.dart';
import 'package:provider/provider.dart';
import '../../core/services/chat_service.dart';
import '../../core/api_service.dart';
import '../../core/repositories/chat_repository.dart';
import '../auth/auth_provider.dart';
import 'chat_detail_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late ChatService _chatService;
  Timer? _refreshTimer;
  bool _isSilentRefreshing = false;
  bool _isLoading = true;
  List<dynamic> _conversations = [];

  @override
  void initState() {
    super.initState();
    _chatService = context.read<ChatRepository>();
    _fetchConversations();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) => _fetchConversations(silent: true));
  }

  Future<void> _fetchConversations({bool silent = false}) async {
    if (silent && _isSilentRefreshing) return;
    if (!silent) setState(() => _isLoading = true);
    if (silent) _isSilentRefreshing = true;

    try {
      final response = await _chatService.getConversations();
      if (response.data['success'] == true) {
        if (mounted) {
          setState(() {
            _conversations = response.data['conversations'];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Chat List Error: $e');
      if (mounted && !silent) setState(() => _isLoading = false);
    } finally {
      if (silent) _isSilentRefreshing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0E2244);
    const yellow = Color(0xFFE2E000);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: Text(
          'KLICUS 💎',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: navy, fontSize: 18, letterSpacing: 2),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchConversations,
        child: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: navy))
          : _conversations.isEmpty
            ? _buildEmptyState(navy)
            : ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: _conversations.length,
                itemBuilder: (context, index) {
                  final chat = _conversations[index];
                  return _buildChatTile(chat, navy, yellow);
                },
              ),
      ),
    );
  }

  Widget _buildChatTile(dynamic chat, Color navy, Color yellow) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final currentUserId = auth.currentUser?['id']?.toString();
    final isSeller = chat['seller_id']?.toString() == currentUserId;
    
    final String partnerName = isSeller 
        ? (chat['buyer_name'] ?? 'Comprador') 
        : (chat['seller_name'] ?? 'Vendedor');
        
    final String lastMsg = chat['last_message'] ?? 'Sin mensajes';
    final String adTitle = chat['ad_title'] ?? 'Anuncio';
    final int unreadCount = int.tryParse(chat['unread_count']?.toString() ?? '0') ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: navy.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: yellow.withOpacity(0.1),
          backgroundImage: (chat['seller_avatar'] != null && !isSeller) 
              ? CachedNetworkImageProvider(ApiService.normalizeUrl(chat['seller_avatar']), cacheManager: KlicusCacheManager.instance) 
              : null,
          child: (chat['seller_avatar'] == null || isSeller) ? Icon(Icons.person, color: navy) : null,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                partnerName.toUpperCase(),
                style: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: navy, fontSize: 13, letterSpacing: -0.5),
                maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
            ),
            if (unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: yellow, borderRadius: BorderRadius.circular(10)),
                child: Text(
                  unreadCount.toString(),
                  style: GoogleFonts.outfit(color: navy, fontSize: 10, fontWeight: FontWeight.w900),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              adTitle,
              style: GoogleFonts.inter(color: yellow, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5),
            ),
            const SizedBox(height: 4),
            Text(
              lastMsg,
              style: GoogleFonts.inter(
                color: unreadCount > 0 ? navy : Colors.grey[600], 
                fontSize: 12, 
                fontWeight: unreadCount > 0 ? FontWeight.w700 : FontWeight.w500
              ),
              maxLines: 1, overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => ChatDetailScreen(conversation: chat)));
        },
      ),
    );
  }

  Widget _buildEmptyState(Color navy) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10)),
              ],
            ),
            child: Icon(Icons.chat_bubble_outline_rounded, size: 48, color: navy.withOpacity(0.2)),
          ),
          const SizedBox(height: 24),
          Text(
            'SIN CONVERSACIONES',
            style: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: navy.withOpacity(0.4), fontSize: 16, letterSpacing: 2),
          ),
          const SizedBox(height: 8),
          Text(
            'Inicia un chat desde cualquier anuncio\npara contactar al vendedor.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }
}
