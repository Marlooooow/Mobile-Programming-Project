import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/conversation_model.dart';
import '../models/message_model.dart';
import '../services/gemini_service.dart';
import '../repositories/chat_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatViewModel extends ChangeNotifier {
  late final GeminiService _geminiService;
  final ChatRepository _chatRepository = ChatRepository();

  List<ConversationModel> _conversations = [];
  Map<String, List<MessageModel>> _messagesMap = {};
  String? _activeConversationId;
  String _selectedModel = 'gemini-3.6-flash'; // Default model
  bool _isGenerating = false;
  String _searchQuery = '';

  // Getters
  List<ConversationModel> get conversations {
    if (_searchQuery.isEmpty) return _conversations;
    return _conversations
        .where(
            (c) => c.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  String? get activeConversationId => _activeConversationId;
  String get selectedModel => _selectedModel;
  bool get isGenerating => _isGenerating;
  String get searchQuery => _searchQuery;

  ConversationModel? get activeConversation {
    if (_activeConversationId == null) return null;
    return _conversations.firstWhere(
      (c) => c.id == _activeConversationId,
      orElse: () => _conversations.first,
    );
  }

  List<MessageModel> get activeMessages {
    if (_activeConversationId == null) return [];
    return _messagesMap[_activeConversationId] ?? [];
  }

  List<MessageModel> get favoriteMessages {
    final all = <MessageModel>[];
    _messagesMap.values.forEach((list) {
      all.addAll(list.where((m) => m.isFavorite));
    });
    return all;
  }

  ChatViewModel() {
    _geminiService = GeminiService(
      apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
    );

    initializeChat();
  }

  Future<void> initializeChat() async {
    try {
      final supabaseService = SupabaseService();
      final user = await supabaseService.ensureAuthenticatedUser();

      // Load existing conversations
      _conversations = await _chatRepository.fetchConversations(user.id);

      // Create a conversation only if none exist
      if (_conversations.isEmpty) {
        final conversation = await _chatRepository.createConversation(
          user.id,
          'Welcome & System Overview',
          _selectedModel,
        );

        _conversations.add(conversation);
      }

      // Load messages for each conversation
      for (final conversation in _conversations) {
        _messagesMap[conversation.id] =
            await _chatRepository.fetchMessages(conversation.id);
      }

      // Select the first conversation
      _activeConversationId = _conversations.first.id;

      notifyListeners();
    } catch (e) {
      debugPrint('initializeChat failed: $e');
    }
  }

  void setSelectedModel(String model) {
    _selectedModel = model;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> selectConversation(String id) async {
    _activeConversationId = id;

    _messagesMap[id] = await _chatRepository.fetchMessages(id);

    notifyListeners();
  }

  Future<void> createNewConversation() async {
    try {
      final supabaseService = SupabaseService();

      final user = await supabaseService.ensureAuthenticatedUser();

      final conversation = await _chatRepository.createConversation(
        user.id,
        'New Conversation',
        _selectedModel,
      );

      _conversations.insert(0, conversation);
      _messagesMap[conversation.id] = [];
      _activeConversationId = conversation.id;

      notifyListeners();

      debugPrint(
        'Created Supabase conversation: ${conversation.id}',
      );
    } catch (e) {
      debugPrint('Failed creating conversation: $e');
    }
  }

  Future<void> deleteConversation(String id) async {
    try {
      // Delete from Supabase first
      await _chatRepository.deleteConversation(id);

      // Remove locally
      _conversations.removeWhere((c) => c.id == id);
      _messagesMap.remove(id);

      // Change active conversation if needed
      if (_activeConversationId == id) {
        _activeConversationId =
            _conversations.isNotEmpty ? _conversations.first.id : null;
      }

      notifyListeners();

      debugPrint('Deleted conversation: $id');
    } catch (e) {
      debugPrint('Failed deleting conversation: $e');
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || _isGenerating) return;

    String? convId = _activeConversationId;
    final authenticatedUserId = Supabase.instance.client.auth.currentUser?.id;

    if (convId == null) {
      if (authenticatedUserId != null && authenticatedUserId.isNotEmpty) {
        try {
          final createdConversation = await _chatRepository.createConversation(
            authenticatedUserId,
            'New Conversation',
            _selectedModel,
          );

          convId = createdConversation.id;
          _activeConversationId = convId;
          _conversations.insert(0, createdConversation);
          _messagesMap[convId] = [];
        } catch (e) {
          debugPrint('Could not create Supabase conversation: $e');
        }
      }

      if (convId == null) {
        await createNewConversation();
        convId = _activeConversationId;
      }

      if (convId == null) {
        debugPrint('Unable to create conversation');
        return;
      }
    }

    final userMsg = MessageModel(
      id: null,
      conversationId: convId,
      sender: 'user',
      content: text,
      createdAt: DateTime.now(),
    );

    _messagesMap[convId] = [
      ...(_messagesMap[convId] ?? []),
      userMsg,
    ];

    _isGenerating = true;
    notifyListeners();

    try {
      // Save user message
      await _chatRepository.saveMessage(userMsg);

      // Update conversation title if it is still generic
      final conversationIndex = _conversations.indexWhere(
        (c) => c.id == convId,
      );

      if (conversationIndex != -1) {
        final currentConversation = _conversations[conversationIndex];

        if (currentConversation.title == 'New Conversation' ||
            currentConversation.title == 'Welcome & System Overview') {
          final newTitle =
              text.length > 40 ? '${text.substring(0, 40)}...' : text;

          await _chatRepository.updateConversation(
            convId,
            title: newTitle,
            lastMessage: text,
            updatedAt: DateTime.now(),
          );

          _conversations[conversationIndex] = currentConversation.copyWith(
            title: newTitle,
            updatedAt: DateTime.now(),
          );

          notifyListeners();
        } else {
          await _chatRepository.updateConversation(
            convId,
            updatedAt: DateTime.now(),
            lastMessage: text,
          );
        }
      }
    } catch (e) {
      debugPrint('Could not save user message/update conversation: $e');
    }

    final aiMsgId = const Uuid().v4();

    final aiMsg = MessageModel(
      id: aiMsgId,
      conversationId: convId,
      sender: 'ai',
      content: '',
      createdAt: DateTime.now(),
    );

    _messagesMap[convId] = [
      ...(_messagesMap[convId] ?? []),
      aiMsg,
    ];

    notifyListeners();

    try {
      final reply = await _geminiService.generateReply(text);

      final currentMsgs = _messagesMap[convId] ?? [];

      final index = currentMsgs.indexWhere(
        (m) => m.id == aiMsgId,
      );

      if (index != -1) {
        final updatedAiMessage = aiMsg.copyWith(
          content: reply,
          conversationId: convId,
        );

        currentMsgs[index] = updatedAiMessage;

        _messagesMap[convId] = List.from(currentMsgs);

        notifyListeners();

        await _chatRepository.saveMessage(updatedAiMessage);
      }
    } catch (e) {
      final currentMsgs = _messagesMap[convId] ?? [];

      final index = currentMsgs.indexWhere(
        (m) => m.id == aiMsgId,
      );

      if (index != -1) {
        final errorMessage = aiMsg.copyWith(
          content: 'Error: $e',
          conversationId: convId,
        );

        currentMsgs[index] = errorMessage;

        _messagesMap[convId] = List.from(currentMsgs);

        notifyListeners();

        await _chatRepository.saveMessage(errorMessage);
      }
    } finally {
      _isGenerating = false;
      notifyListeners();
    }
  }

  void toggleFavorite(String? messageId) {
    if (messageId == null) return;

    final msgs = _messagesMap[_activeConversationId] ?? [];
    final index = msgs.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      msgs[index] = msgs[index].copyWith(isFavorite: !msgs[index].isFavorite);
      notifyListeners();
    }
  }

  void setReaction(String? messageId, String? reaction) {
    if (_activeConversationId == null) return;
    final msgs = _messagesMap[_activeConversationId] ?? [];
    final index = msgs.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      msgs[index] = msgs[index].copyWith(reaction: reaction);
      notifyListeners();
    }
  }
}
