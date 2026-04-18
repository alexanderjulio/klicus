import 'dart:io';
import 'package:dio/dio.dart';
import '../api_service.dart';

class ChatService {
  final ApiService _apiService;

  ChatService([ApiService? apiService]) : _apiService = apiService ?? ApiService();

  /// List all user conversations
  Future<dynamic> getConversations() async {
    return await _apiService.get('/chat/conversations');
  }

  /// Start or retrieve a conversation for an ad
  Future<dynamic> startConversation(String adId) async {
    return await _apiService.post('/chat/conversations', data: {'adId': adId});
  }

  /// Fetch message history for a conversation
  Future<dynamic> getMessages(String conversationId) async {
    return await _apiService.get('/chat/messages/$conversationId');
  }

  /// Send a text message
  Future<dynamic> sendMessage(String conversationId, String text) async {
    return await _apiService.post('/chat/messages/$conversationId', data: {'text': text});
  }

  /// Send an image message
  Future<dynamic> sendImage(String conversationId, File imageFile, {String? text}) async {
    String fileName = imageFile.path.split('/').last;
    FormData formData = FormData.fromMap({
      'text': text ?? '',
      'image': await MultipartFile.fromFile(imageFile.path, filename: fileName),
    });

    return await _apiService.post(
      '/chat/messages/$conversationId', 
      data: formData,
      // The Dio instance inside ApiService already handles headers, 
      // but FormData usually sets the correct type automatically.
    );
  }
}
