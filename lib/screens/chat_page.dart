import 'dart:async';

import 'package:aida/widgets/typing_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../models/chat_message.dart';
import '../services/ai_service.dart';
import '../services/conversation_repository.dart';
import '../utils/message_time_formatter.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.aiService,
    required this.chatRepository,
    required this.conversationId,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.onShowRecentChats,
  });

  final AiService aiService;
  final ConversationRepository chatRepository;
  final String conversationId;
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final VoidCallback onShowRecentChats;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Hello! I am AIDA. What would you like to learn today?',
      isUser: false,
      timestamp: DateTime.now(),
    ),
  ];

  final List<String> _suggestedPrompts = const [
    'Explain a topic simply',
    'Give me a study summary',
    'Quiz me on this subject',
  ];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadConversationMessages();
  }

  Future<void> _loadConversationMessages() async {
    if (widget.conversationId.isEmpty) {
      return;
    }

    try {
      final messages =
          await widget.chatRepository.fetchMessages(widget.conversationId);

      if (!mounted) return;

      if (messages.isNotEmpty) {
        setState(() {
          _messages
            ..clear()
            ..addAll(messages);
        });

        _scrollToBottom();
      }
    } catch (error, stackTrace) {
      debugPrint(
        'Could not load conversation messages: $error\n$stackTrace',
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage([String? textOverride]) async {
    final text = (textOverride ?? _controller.text).trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(
        ChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
      );
      _controller.clear();
      _isLoading = true;
    });
    _scrollToBottom();

    unawaited(_saveMessage(
      conversationId: widget.conversationId,
      role: 'user',
      content: text,
    ));

    try {
      final reply = await widget.aiService.generateReply(text);

      if (!mounted) return;
      setState(() {
        _messages.add(
          ChatMessage(text: reply, isUser: false, timestamp: DateTime.now()),
        );
      });

      unawaited(_saveMessage(
        conversationId: widget.conversationId,
        role: 'assistant',
        content: reply,
      ));
    } on AiServiceException catch (error, stackTrace) {
      debugPrint('AI request failed: $error\n$stackTrace');
      if (!mounted) return;
      setState(() {
        _messages.add(
          ChatMessage(
            text: error.userMessage,
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });
    } catch (error, stackTrace) {
      debugPrint('Unexpected chat error: $error\n$stackTrace');
      if (!mounted) return;
      setState(() {
        _messages.add(
          const ChatMessage(
            text: 'Sorry, something went wrong. Please try again.',
            isUser: false,
          ),
        );
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
        _scrollToBottom();
      }
    }
  }

  Future<void> _saveMessage({
    required String conversationId,
    required String role,
    required String content,
  }) async {
    try {
      await widget.chatRepository.saveMessage(
        conversationId: conversationId,
        role: role,
        content: content,
      );
    } catch (error, stackTrace) {
      debugPrint('Could not save $role message: $error\n$stackTrace');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _handlePromptTap(String prompt) {
    _controller.text = prompt;
    _sendMessage(prompt);
  }

  void _toggleTheme() {
    widget.onThemeChanged(!widget.isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 12,
        leading: IconButton(
          onPressed: widget.onShowRecentChats,
          icon: const Icon(Icons.menu_rounded),
          tooltip: 'Recent chats',
        ),
        actions: [
          IconButton(
            onPressed: _toggleTheme,
            icon: Icon(
              widget.isDarkMode
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
            tooltip: 'Toggle theme',
          ),
        ],
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                Icons.smart_toy_outlined,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AIDA',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'AI learning companion',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
        centerTitle: false,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary.withValues(alpha: 0.96),
                theme.colorScheme.primary.withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.surface.withValues(alpha: 0.95),
              theme.colorScheme.surface,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    if (_messages.length == 1)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _suggestedPrompts.map((prompt) {
                            return ActionChip(
                              label: Text(prompt),
                              onPressed: () => _handlePromptTap(prompt),
                            );
                          }).toList(),
                        ),
                      ),
                    Expanded(
                      child: ListView.builder(
                        key: const Key('messageList'),
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        itemCount: _messages.length + (_isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (_isLoading && index == _messages.length) {
                            return const TypingIndicator();
                          }
                          final message = _messages[index];
                          final showDateLabel = index == 0 ||
                              formatDateLabel(
                                    _messages[index - 1].timestamp ??
                                        DateTime.now(),
                                  ) !=
                                  formatDateLabel(
                                    message.timestamp ?? DateTime.now(),
                                  );

                          return Column(
                            children: [
                              if (showDateLabel)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme
                                          .colorScheme.surfaceContainerHighest
                                          .withValues(alpha: 0.7),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      formatDateLabel(
                                        message.timestamp ?? DateTime.now(),
                                      ),
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color:
                                            theme.colorScheme.onSurfaceVariant,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ),
                                ),
                              MessageBubble(message: message),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              _MessageComposer(
                controller: _controller,
                isLoading: _isLoading,
                onSend: _sendMessage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isUser = message.isUser;
    final isDark = theme.brightness == Brightness.dark;

    final bubbleColor = isUser
        ? theme.colorScheme.primary
        : (isDark ? const Color(0xFF1F2937) : Colors.white);

    final borderColor = isUser
        ? Colors.transparent
        : (isDark
            ? const Color(0xFF374151)
            : theme.colorScheme.outlineVariant.withValues(alpha: .45));

    final textColor = isUser
        ? theme.colorScheme.onPrimary
        : (isDark ? const Color(0xFFF3F4F6) : theme.colorScheme.onSurface);

    final timestampColor =
        isDark ? const Color(0xFF9CA3AF) : theme.colorScheme.onSurfaceVariant;

    final timestamp = message.timestamp ?? DateTime.now();
    final isShort = message.text.trim().length <= 12;
    final maxBubbleWidth =
        MediaQuery.of(context).size.width * (isUser ? .68 : .80);

    // 1. The Bubble (Contains ONLY the message content)
    final bubble = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxBubbleWidth),
      child: Container(
        padding: EdgeInsets.fromLTRB(
          isShort ? 20 : 16,
          isShort ? 10 : 12,
          isShort ? 20 : 16,
          isShort ? 10 : 12,
        ),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? .18 : .05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: isUser
            ? Text(
                message.text,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: textColor,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              )
            : MarkdownBody(
                data: message.text,
                selectable: true,
                softLineBreak: true,
                imageBuilder: (uri, title, alt) =>
                    Text(alt?.isNotEmpty == true ? alt! : "Image"),
                styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                  p: theme.textTheme.bodyLarge?.copyWith(
                    color: textColor,
                    height: 1.5,
                  ),
                  pPadding: EdgeInsets.zero,
                  blockSpacing: 10,
                  listIndent: 20,
                  strong: theme.textTheme.bodyLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                  em: theme.textTheme.bodyLarge?.copyWith(
                    color: textColor,
                    fontStyle: FontStyle.italic,
                  ),
                  code: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    color: isDark
                        ? const Color(0xFFD1D5DB)
                        : theme.colorScheme.onSurfaceVariant,
                    backgroundColor: isDark
                        ? const Color(0xFF111827)
                        : theme.colorScheme.surfaceContainer,
                  ),
                  codeblockPadding: const EdgeInsets.all(10),
                  codeblockDecoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF111827)
                        : theme.colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  blockquotePadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  blockquoteDecoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF111827)
                        : theme.colorScheme.surfaceContainer,
                    border: Border(
                      left: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 3,
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );

    // 2. Combine Bubble + External Timestamp
    final bubbleWithTimestamp = Column(
      crossAxisAlignment:
          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        bubble,
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            formatTimestamp(timestamp),
            style: theme.textTheme.bodySmall?.copyWith(
              color: timestampColor,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );

    // USER MESSAGE
    if (isUser) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Align(
          alignment: Alignment.centerRight,
          child: bubbleWithTimestamp,
        ),
      );
    }

    // ASSISTANT MESSAGE
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4, right: 8),
            child: CircleAvatar(
              radius: 14,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                Icons.smart_toy_outlined,
                size: 16,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          Flexible(child: bubbleWithTimestamp),
        ],
      ),
    );
  }
}

class _MessageComposer extends StatelessWidget {
  const _MessageComposer({
    required this.controller,
    required this.isLoading,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? const Color(0xFF1F2937)
            : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.22 : 0.04,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              key: const Key('messageField'),
              controller: controller,
              minLines: 1,
              maxLines: 4,
              enabled: !isLoading,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => !isLoading ? onSend() : null,
              decoration: InputDecoration(
                hintText: 'Ask AIDA anything...',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 4,
                ),
                hintStyle: TextStyle(
                  color: theme.brightness == Brightness.dark
                      ? const Color(0xFF9CA3AF)
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            key: const Key('sendButton'),
            onPressed: isLoading ? null : onSend,
            style: FilledButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(14),
              foregroundColor: theme.colorScheme.onPrimary,
              backgroundColor: theme.colorScheme.primary,
            ),
            child: const Icon(Icons.send_rounded),
          ),
        ],
      ),
    );
  }
}
