import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../core/services/chat_service.dart';
import '../../core/services/chat_ws_service.dart';
import '../../core/api_service.dart';
import '../../core/repositories/chat_repository.dart';
import '../../core/widgets/offline_banner.dart';
import '../../core/services/image_cache_manager.dart';
import '../auth/auth_provider.dart';

class ChatDetailScreen extends StatefulWidget {
  final dynamic conversation;
  const ChatDetailScreen({super.key, required this.conversation});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  late ChatService _chatService;
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  
  List<dynamic> _messages = [];
  bool _isLoading = true;
  Timer? _pollingTimer;
  ChatWsService? _wsService;

  String? _currentGuestId;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _chatService = context.read<ChatRepository>();
    _loadGuestId();
    if (widget.conversation == null || widget.conversation['id'] == null) {
      _isLoading = false;
      return;
    }
    _fetchMessages();
    _initTransport();
  }

  Future<void> _loadGuestId() async {
    final gid = await context.read<ApiService>().getGuestId();
    if (mounted) setState(() => _currentGuestId = gid);
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _wsService?.disconnect();
    _msgController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _initTransport() async {
    final convId = widget.conversation?['id'];
    if (convId == null) return;

    _wsService = ChatWsService(
      conversationId: convId is int ? convId : int.tryParse(convId.toString()) ?? 0,
      onNewMessage: () => _fetchMessages(silent: true),
    );

    final connected = await _wsService!.connect();
    if (!connected && mounted) {
      // WS unavailable — fall back to 5s polling
      _startPolling();
    }
  }

  void _startPolling() {
    if (_pollingTimer != null && _pollingTimer!.isActive) return;
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) => _fetchMessages(silent: true));
  }

  Future<void> _fetchMessages({bool silent = false}) async {
    if (widget.conversation?['id'] == null) return;
    if (!silent) setState(() => _isLoading = true);
    try {
      final response = await _chatService.getMessages(widget.conversation['id']);
      if (response.statusCode == 200 && response.data['success'] == true) {
        if (mounted) {
          final List<dynamic> newMessages = response.data['messages'] ?? [];
          
          // Only update and scroll if there are actually new messages or it's the first load
          if (newMessages.length != _messages.length || !silent) {
            final bool wasAtBottom = _scrollController.hasClients && 
                (_scrollController.position.maxScrollExtent - _scrollController.offset < 100);

            setState(() {
              _messages = newMessages;
              _isLoading = false;
            });
            
            // Auto-scroll if it's the first load or if the user is already near the bottom
            if (!silent || wasAtBottom) {
              _scrollToBottom();
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Fetch Messages Error: $e');
      if (mounted && !silent) setState(() => _isLoading = false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSend() async {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;
    
    final currentUser = context.read<AuthProvider>().currentUser;
    final effectiveId = currentUser?['id']?.toString() ?? _currentGuestId;

    // ⚡ Optimistic Update: Add to UI immediately
    final tempMsg = {
      'content': text,
      'sender_id': effectiveId,
      'message_type': 'text',
      'created_at': DateTime.now().toIso8601String(),
      'is_optimistic': true,
    };

    setState(() {
      _messages.add(tempMsg);
      _scrollToBottom();
    });

    _msgController.clear();
    _focusNode.requestFocus(); // Re-focus immediately
    try {
      await _chatService.sendMessage(widget.conversation['id'], text);
      _fetchMessages(silent: true);
    } catch (e) {
      debugPrint('Send Error: $e');
      // If fail, we should probably remove the optimistic message
      setState(() => _messages.remove(tempMsg));
    }
  }

  Future<void> _handleImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (image == null) return;
      
      // Show loading or optimistic UI
      await _chatService.sendImage(widget.conversation['id'], File(image.path));
      _fetchMessages(silent: true);
      _scrollToBottom();
    } catch (e) {
      debugPrint('Image Send Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthProvider>().currentUser;
    final effectiveId = currentUser?['id']?.toString() ?? _currentGuestId;
    
    const navy = Color(0xFF0E2244);
    const yellow = Color(0xFFE2E000);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              (context.read<AuthProvider>().currentUser?['id']?.toString() == widget.conversation['seller_id']?.toString() 
                ? (widget.conversation['buyer_name'] ?? 'COMPRADOR')
                : (widget.conversation['seller_name'] ?? 'VENDEDOR')
              ).toString().toUpperCase(),
              style: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: navy, fontSize: 13, letterSpacing: 0.5)
            ),
            Text(widget.conversation['ad_title'], 
                 style: GoogleFonts.inter(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: navy))
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  itemCount: _messages.isEmpty ? 1 : _messages.length,
                  itemBuilder: (context, index) {
                    if (_messages.isEmpty) return _buildNewConversationState(navy);
                    
                    final msg = _messages[index];
                    final isMe = msg['sender_id']?.toString() == effectiveId;

                    // Date Divider Logic
                    bool showDateDivider = false;
                    String dateLabel = '';
                    if (index == 0) {
                      showDateDivider = true;
                      dateLabel = _getFormattedDate(msg['created_at']);
                    } else {
                      final prevMsg = _messages[index - 1];
                      final currentDay = _getDayKey(msg['created_at']);
                      final prevDay = _getDayKey(prevMsg['created_at']);
                      if (currentDay != prevDay) {
                        showDateDivider = true;
                        dateLabel = _getFormattedDate(msg['created_at']);
                      }
                    }
                    
                    return Column(
                      children: [
                        if (showDateDivider) _buildDateDivider(dateLabel, navy),
                        TweenAnimationBuilder(
                          duration: const Duration(milliseconds: 400),
                          tween: Tween<double>(begin: 0.0, end: 1.0),
                          curve: Curves.easeOut,
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: Opacity(
                                opacity: value.clamp(0.0, 1.0),
                                child: _buildMessageBubble(msg, isMe, navy, yellow),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
          ),
          _buildInputArea(navy, yellow),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(dynamic msg, bool isMe, Color navy, Color yellow) {
    final bool isImage = msg['message_type'] == 'image';

    // Determine the label for the bubble
    String senderLabel = isMe ? 'TÚ' : (widget.conversation['seller_name'] ?? 'VENDEDOR');
    if (!isMe) {
      // If we are looking at someone else's message, determine if it's the seller or buyer
      // If the current user is the seller, the partner is the buyer
      final auth = context.read<AuthProvider>();
      final myId = auth.currentUser?['id']?.toString() ?? _currentGuestId;
      final amISeller = widget.conversation['seller_id']?.toString() == myId;
      senderLabel = amISeller ? (widget.conversation['buyer_name'] ?? 'COMPRADOR') : (widget.conversation['seller_name'] ?? 'VENDEDOR');
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? navy : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(24),
            topRight: const Radius.circular(24),
            bottomLeft: Radius.circular(isMe ? 24 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 24),
          ),
          boxShadow: [
            BoxShadow(
              color: isMe ? navy.withOpacity(0.15) : Colors.black.withOpacity(0.04), 
              blurRadius: 15, 
              offset: const Offset(0, 5)
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (isImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: ApiService.normalizeUrl(msg['content']),
                  cacheManager: KlicusCacheManager.instance,
                  placeholder: (context, url) => Container(height: 200, width: 200, color: Colors.grey[200]),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              )
            else
              Text(
                msg['content'] ?? '',
                style: GoogleFonts.inter(
                  color: isMe ? Colors.white : navy, 
                  fontSize: 14, 
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${senderLabel.toUpperCase()} • ${_formatTime(msg['created_at'])}',
                  style: TextStyle(
                    color: isMe ? Colors.white.withOpacity(0.5) : Colors.grey[400], 
                    fontSize: 8, 
                    fontWeight: FontWeight.bold
                  ),
                ),
                if (isMe && (msg['is_optimistic'] == true)) ...[
                  const SizedBox(width: 4),
                  Icon(Icons.access_time_rounded, size: 8, color: Colors.white.withOpacity(0.5)),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getDayKey(dynamic timestamp) {
    if (timestamp == null) return '';
    try {
      final dt = DateTime.parse(timestamp.toString()).toLocal();
      return '${dt.year}-${dt.month}-${dt.day}';
    } catch (e) {
      return '';
    }
  }

  String _getFormattedDate(dynamic timestamp) {
    if (timestamp == null) return '';
    try {
      final now = DateTime.now();
      final dt = DateTime.parse(timestamp.toString()).toLocal();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final dateToCheck = DateTime(dt.year, dt.month, dt.day);

      if (dateToCheck == today) return 'HOY';
      if (dateToCheck == yesterday) return 'AYER';
      
      final months = ['ENE', 'FEB', 'MAR', 'ABR', 'MAY', 'JUN', 'JUL', 'AGO', 'SEP', 'OCT', 'NOV', 'DIC'];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (e) {
      return '';
    }
  }

  Widget _buildDateDivider(String label, Color navy) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: navy.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          color: navy.withOpacity(0.4),
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  String _formatTime(dynamic timestamp) {
    if (timestamp == null) return '';
    try {
      final DateTime dt = DateTime.parse(timestamp.toString()).toLocal();
      final String hour = dt.hour.toString().padLeft(2, '0');
      final String minute = dt.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    } catch (e) {
      return '';
    }
  }

  Widget _buildNewConversationState(Color navy) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          children: [
            Icon(Icons.auto_awesome_rounded, size: 60, color: navy.withOpacity(0.05)),
            const SizedBox(height: 24),
            Text(
              '¡CONVERSACIÓN INICIADA!',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: navy.withOpacity(0.3), fontSize: 13, letterSpacing: 1),
            ),
            const SizedBox(height: 8),
            Text(
              'Sé el primero en saludar.',
              style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea(Color navy, Color yellow) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: navy.withOpacity(0.05))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              onPressed: _handleImage,
              icon: Icon(Icons.add_photo_alternate_rounded, color: navy.withOpacity(0.3)),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F7FA),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _msgController,
                  focusNode: _focusNode,
                  decoration: const InputDecoration(
                    hintText: 'Escribe un mensaje...',
                    hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => _handleSend(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: navy,
              child: IconButton(
                onPressed: _handleSend,
                icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Small fix for InputBorder
class InputValue {
  static const none = InputBorder.none;
}
