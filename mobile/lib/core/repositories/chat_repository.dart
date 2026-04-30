import '../services/chat_service.dart';

/// Thin repository layer over ChatService.
/// Screens should prefer this over constructing ChatService directly.
class ChatRepository extends ChatService {
  ChatRepository(super.api);
}
