import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class MessageRepository {
  Future<void> saveMessage({
    required String conversationId,
    required String sender,
    required String content,
  });
}

class ChatRepository implements MessageRepository {
  ChatRepository(this._client);

  final SupabaseClient _client;

  Future<String> createConversation({
    required String title,
  }) async {
    final response = await _client
        .from('conversations')
        .insert({
          'title': title,
        })
        .select('id')
        .single();

    return response['id'].toString();
  }

  @override
  Future<void> saveMessage({
    required String conversationId,
    required String sender,
    required String content,
  }) async {
    await _client.from('messages').insert({
      'conversation_id': conversationId,
      'sender': sender,
      'content': content,
    });
  }
}
