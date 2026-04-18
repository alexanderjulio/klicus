import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../core/services/chat_service.dart';
import '../../core/api_service.dart';
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

  @override
  void initState() {
    super.initState();
    _chatService = ChatService(context.read<ApiService>());
    if (widget.conversation == null || widget.conversation['id'] == null) {
      _isLoading = false;
      return;
    }
    _fetchMessages();
    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) => _fetchMessages(silent: true));
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
    
    _msgController.clear();
    try {
      await _chatService.sendMessage(widget.conversation['id'], text);
      _fetchMessages(silent: true);
      _scrollToBottom();
    } catch (e) {
      debugPrint('Send Error: $e');
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
    final currentUserId = currentUser?['id'].toString();
    
    const navy = Color(0xFF0E2244);
    const yellow = Color(0xFFE2E000);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        title: Column(
          children: [
            Text(widget.conversation['seller_name'].toString().toUpperCase(), 
                 style: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: navy, fontSize: 14)),
            Text(widget.conversation['ad_title'], 
                 style: GoogleFonts.inter(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator(color: navy))
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(20),
                  itemCount: _messages.isEmpty ? 1 : _messages.length,
                  itemBuilder: (context, index) {
                    if (_messages.isEmpty) return _buildNewConversationState(navy);
                    
                    final msg = _messages[index];
                    final isMe = msg['sender_id']?.toString() == currentUserId;
                    return _buildMessageBubble(msg, isMe, navy, yellow);
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

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? navy : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isMe ? 20 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 20),
          ),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (isImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: ApiService.normalizeUrl(msg['content']),
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
            Text(
              'KLICUS CHAT • ${_formatTime(msg['created_at'])}',
              style: TextStyle(
                color: isMe ? Colors.white.withOpacity(0.5) : Colors.grey[400], 
                fontSize: 8, 
                fontWeight: FontWeight.bold
              ),
            ),
          ],
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
                  decoration: const InputDecoration(
                    hintText: 'Escribe un mensaje...',
                    hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                    border: InputValue.none,
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
