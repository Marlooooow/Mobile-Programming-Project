import '../models/conversation_model.dart';
import '../models/message_model.dart';
import '../services/supabase_service.dart';

class ChatRepository {
  final SupabaseService _supabaseService;

  ChatRepository({SupabaseService? supabaseService})
      : _supabaseService = supabaseService ?? SupabaseService();

  Future<List<ConversationModel>> fetchConversations(String userId) async {
    try {
      return await _supabaseService.getConversations(userId);
    } catch (_) {
      return [];
    }
  }

  Future<ConversationModel> createConversation(
      String userId, String title, String model) async {
    return await _supabaseService.createConversation(userId, title, model);
  }

  Future<List<MessageModel>> fetchMessages(String conversationId) async {
    try {
      return await _supabaseService.getMessages(conversationId);
    } catch (_) {
      return [];
    }
  }

  Future<MessageModel> saveMessage(MessageModel message) async {
    return await _supabaseService.insertMessage(message);
  }

  Future<void> toggleFavorite(String messageId, bool isFavorite) async {
    await _supabaseService.toggleMessageFavorite(messageId, isFavorite);
  }

  Future<void> setReaction(String messageId, String? reaction) async {
    await _supabaseService.reactToMessage(messageId, reaction);
  }

  Future<void> updateConversation(
    String conversationId, {
    String? title,
    String? lastMessage,
    DateTime? updatedAt,
  }) async {
    await _supabaseService.updateConversation(
      conversationId,
      title: title,
      lastMessage: lastMessage,
      updatedAt: updatedAt,
    );
  }

  Future<void> deleteConversation(String conversationId) async {
    await _supabaseService.deleteConversation(conversationId);
  }
}
