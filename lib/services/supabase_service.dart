import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

class SupabaseService {
  SupabaseClient get _client => Supabase.instance.client;

  Future<User> ensureAuthenticatedUser() async {
    final currentUser = _client.auth.currentUser;

    if (currentUser != null) {
      return currentUser;
    }

    final existingSession = _client.auth.currentSession;

    if (existingSession != null) {
      final response = await _client.auth.getUser();

      if (response.user != null) {
        return response.user!;
      }
    }

    final response = await _client.auth.signInAnonymously();

    if (response.user == null) {
      throw Exception(
        'Unable to initialize a Supabase session for chat persistence',
      );
    }

    await _ensureUserProfile(
      response.user!.id,
      email: response.user!.email ?? 'anonymous@aida.app',
      fullName: 'Anonymous User',
    );

    return response.user!;
  }

  Future<void> _ensureUserProfile(
    String userId, {
    required String email,
    required String fullName,
  }) async {
    await _client.from('users').upsert({
      'id': userId,
      'email': email,
      'full_name': fullName,
      'theme_preference': 'system',
    }, onConflict: 'id');
  }

  // Auth Operations
  Future<AuthResponse> signIn(String email, String password) async {
    return await _client.auth
        .signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUp(
      String email, String password, String fullName) async {
    final response =
        await _client.auth.signUp(email: email, password: password);
    if (response.user != null) {
      await _client.from('users').insert({
        'id': response.user!.id,
        'email': email,
        'full_name': fullName,
        'theme_preference': 'system',
      });
    }
    return response;
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // User Profile
  Future<UserModel?> getUserProfile(String userId) async {
    final data =
        await _client.from('users').select().eq('id', userId).maybeSingle();
    if (data != null) {
      return UserModel.fromJson(data);
    }
    return null;
  }

  // Conversation Operations
  Future<List<ConversationModel>> getConversations(String userId) async {
    final data = await _client
        .from('conversations')
        .select()
        .eq('user_id', userId)
        .eq('is_deleted', false)
        .order('updated_at', ascending: false);

    return (data as List).map((e) => ConversationModel.fromJson(e)).toList();
  }

  Future<ConversationModel> createConversation(
    String userId,
    String title,
    String model,
  ) async {
    final authUser = await ensureAuthenticatedUser();

    await _ensureUserProfile(
      authUser.id,
      email: authUser.email ?? 'anonymous@aida.app',
      fullName: 'Anonymous User',
    );

    final data = await _client
        .from('conversations')
        .insert({
          'user_id': authUser.id,
          'title': title,
          'ai_model': model,
        })
        .select()
        .single();

    return ConversationModel.fromJson(data);
  }

  Future<void> deleteConversation(String conversationId) async {
    await _client
        .from('conversations')
        .update({'is_deleted': true}).eq('id', conversationId);
  }

  // Messages Operations
  Future<List<MessageModel>> getMessages(String conversationId) async {
    final data = await _client
        .from('messages')
        .select()
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: true);

    return (data as List).map((e) => MessageModel.fromJson(e)).toList();
  }

  Future<MessageModel> insertMessage(MessageModel message) async {
    final data = await _client
        .from('messages')
        .insert(message.toJson())
        .select()
        .single();

    return MessageModel.fromJson(data);
  }

  Future<void> toggleMessageFavorite(String messageId, bool isFavorite) async {
    await _client
        .from('messages')
        .update({'is_favorite': isFavorite}).eq('id', messageId);
  }

  Future<void> reactToMessage(String messageId, String? reaction) async {
    await _client
        .from('messages')
        .update({'reaction': reaction}).eq('id', messageId);
  }

  Future<void> updateConversation(
    String conversationId, {
    String? title,
    String? lastMessage,
    DateTime? updatedAt,
  }) async {
    final updates = <String, dynamic>{};

    if (title != null) {
      updates['title'] = title;
    }

    if (lastMessage != null) {
      updates['last_message'] = lastMessage;
    }

    updates['updated_at'] = updatedAt ?? DateTime.now();

    await _client
        .from('conversations')
        .update(updates)
        .eq('id', conversationId);
  }
}
