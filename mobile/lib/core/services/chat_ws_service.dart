import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as ws_status;
import '../api_service.dart';

/// Manages a WebSocket connection for a single chat conversation.
/// Falls back to polling if the connection cannot be established.
class ChatWsService {
  final int conversationId;
  final VoidCallback onNewMessage;

  WebSocketChannel? _channel;
  StreamSubscription? _sub;
  bool _connected = false;
  bool _disposed = false;

  ChatWsService({required this.conversationId, required this.onNewMessage});

  bool get isConnected => _connected;

  static String _wsUrl(int conversationId) {
    final base = ApiService.baseUrl.replaceFirst('/api', '').replaceFirst('http', 'ws');
    return '$base/ws/chat/$conversationId';
  }

  Future<bool> connect() async {
    if (_disposed) return false;
    try {
      _channel = WebSocketChannel.connect(Uri.parse(_wsUrl(conversationId)));
      // Wait for connection to confirm it's valid
      await _channel!.ready;
      _connected = true;
      _sub = _channel!.stream.listen(
        (message) {
          if (!_disposed) onNewMessage();
        },
        onError: (e) {
          debugPrint('ChatWS error: $e');
          _connected = false;
        },
        onDone: () {
          _connected = false;
          debugPrint('ChatWS closed for conversation $conversationId');
        },
        cancelOnError: true,
      );
      debugPrint('ChatWS connected for conversation $conversationId');
      return true;
    } catch (e) {
      debugPrint('ChatWS connect failed: $e — falling back to polling');
      _connected = false;
      return false;
    }
  }

  void disconnect() {
    _disposed = true;
    _sub?.cancel();
    _channel?.sink.close(ws_status.goingAway);
    _channel = null;
    _connected = false;
  }
}
