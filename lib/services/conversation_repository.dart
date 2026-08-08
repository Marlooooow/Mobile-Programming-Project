import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/chat_message.dart';
import '../models/conversation.dart';

abstract interface class ConversationRepository {
  Future<List<Conversation>> fetchRecentConversations();
  Future<String> createConversation({required String title});
  Future<List<ChatMessage>> fetchMessages(String conversationId);
  Future<void> saveMessage({
    required String conversationId,
    required String role,
    required String content,
  });
}


class ChatRepository implements ConversationRepository {
  ChatRepository(this._client);

  final SupabaseClient _client;


  @override
Future<List<Conversation>> fetchRecentConversations() async {
  try {

    final data = await _client
        .from('conversations')
        .select('id, title, updated_at, last_message')
        .order('updated_at', ascending: false)
        .limit(20);

    return (data as List)
        .map((e) => Conversation.fromMap(e as Map<String, dynamic>))
        .toList();

  } on PostgrestException catch (e) {
    throw Exception(e.message);
  }
}


  @override
  Future<String> createConversation({
    required String title,
  }) async {

    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception('User is not authenticated');
    }


    final normalizedTitle = title.trim();


    final data = await _client
        .from('conversations')
        .insert({
          'user_id': user.id,
          'title': normalizedTitle.isEmpty
              ? 'New conversation'
              : normalizedTitle,
        })
        .select('id')
        .single();


    return data['id'] as String;
  }



  @override
  Future<List<ChatMessage>> fetchMessages(
      String conversationId,
  ) async {

    final data = await _client
        .from('messages')
        .select('role, content, created_at')
        .eq('conversation_id', conversationId)
        .order('created_at');


    return (data as List).map((item) {

      final map = item as Map<String, dynamic>;


      return ChatMessage(
        text: map['content'] as String? ?? '',

        isUser:
            (map['role'] as String?)?.toLowerCase() == 'user',

        timestamp:
            DateTime.tryParse(
              map['created_at'] as String? ?? '',
            ),
      );

    }).toList();
  }



  @override
  Future<void> saveMessage({
    required String conversationId,
    required String role,
    required String content,
  }) async {

    final normalizedRole = role.trim();
    final normalizedContent = content.trim();


    if (normalizedRole.isEmpty ||
        normalizedContent.isEmpty) {
      return;
    }


    await _client
        .from('messages')
        .insert({

          'conversation_id': conversationId,

          'role': normalizedRole,

          'content': normalizedContent,

        });

    // No need to update conversations here.
    // The database trigger does it automatically.
  }
}
