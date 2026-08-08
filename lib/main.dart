import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'viewmodels/chat_viewmodel.dart';
import 'views/splash_view.dart';
import 'screens/chat_page.dart';
import 'services/ai_service.dart';
import 'services/conversation_repository.dart';
import 'services/chat_repository.dart' as legacy_chat_repository;
import 'models/conversation.dart';
import 'models/chat_message.dart';

class _LegacyMessageRepositoryAdapter implements ConversationRepository {
  _LegacyMessageRepositoryAdapter(this._repo);

  final legacy_chat_repository.MessageRepository _repo;

  @override
  Future<List<Conversation>> fetchRecentConversations() async => [];

  @override
  Future<String> createConversation({required String title}) async => '';

  @override
  Future<List<ChatMessage>> fetchMessages(String conversationId) async => [];

  @override
  Future<void> saveMessage({
    required String conversationId,
    required String role,
    required String content,
  }) async {
    await _repo.saveMessage(
      conversationId: conversationId,
      sender: role,
      content: content,
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Dotenv loading exception: $e");
  }

  final supabaseUrl = (dotenv.env['SUPABASE_URL'] ?? '').trim();
  final supabaseAnonKey = (dotenv.env['SUPABASE_KEY'] ?? dotenv.env['SUPABASE_ANON_KEY'] ?? '').trim();

  if (supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty) {
    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
      );
    } catch (e) {
      debugPrint("Supabase initialization exception: $e");
    }
  }

  runApp(const AidaApp());
}

class AidaApp extends StatelessWidget {
  const AidaApp({
    super.key,
    this.aiService,
    this.chatRepository,
  });

  final dynamic aiService;
  final dynamic chatRepository;

  @override
  Widget build(BuildContext context) {
    final effectiveAiService = aiService as AiService?;
    final effectiveChatRepository = chatRepository is ConversationRepository
        ? chatRepository as ConversationRepository
        : chatRepository is legacy_chat_repository.MessageRepository
            ? _LegacyMessageRepositoryAdapter(
                chatRepository as legacy_chat_repository.MessageRepository,
              )
            : null;

    if (effectiveAiService != null && effectiveChatRepository != null) {
      return MaterialApp(
        title: 'AIDA - AI Personal Assistant',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: ChatPage(
          aiService: effectiveAiService,
          chatRepository: effectiveChatRepository,
          conversationId: '',
          isDarkMode: false,
          onThemeChanged: (_) {},
          onShowRecentChats: () {},
        ),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChatViewModel()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'AIDA - AI Personal Assistant',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const SplashView(),
          );
        },
      ),
    );
  }
}