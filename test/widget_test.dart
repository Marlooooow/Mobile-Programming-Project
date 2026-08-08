// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aida/main.dart';
import 'package:aida/models/chat_message.dart';
import 'package:aida/screens/chat_page.dart';
import 'package:aida/services/ai_service.dart';
import 'package:aida/services/chat_repository.dart';

void main() {
  testWidgets('sends a message and displays the AI reply', (tester) async {
    final repository = _MemoryMessageRepository();
    await tester.pumpWidget(
      AidaApp(aiService: _FakeAiService(), chatRepository: repository),
    );

    expect(
      find.text('Hello! I am AIDA. What would you like to learn today?'),
      findsOneWidget,
    );

    await tester.enterText(find.byKey(const Key('messageField')), 'Hello');
    await tester.tap(find.byKey(const Key('sendButton')));
    await tester.pumpAndSettle();

    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('Test reply'), findsOneWidget);
    expect(repository.savedMessages, [
      ('user', 'Hello'),
      ('assistant', 'Test reply'),
    ]);
  });

  testWidgets('a history save failure does not prevent the AI reply', (
    tester,
  ) async {
    await tester.pumpWidget(
      AidaApp(
        aiService: _FakeAiService(),
        chatRepository: _FailingMessageRepository(),
      ),
    );

    await tester.enterText(find.byKey(const Key('messageField')), 'Hello');
    await tester.tap(find.byKey(const Key('sendButton')));
    await tester.pumpAndSettle();

    expect(find.text('Test reply'), findsOneWidget);
  });

  testWidgets('renders assistant Markdown instead of showing its markers', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MessageBubble(
            message: ChatMessage(
              text: 'This is **bold** and *italic*.',
              isUser: false,
            ),
          ),
        ),
      ),
    );

    final markdownText = tester
        .widgetList<SelectableText>(find.byType(SelectableText))
        .firstWhere(
          (widget) => widget.textSpan?.toPlainText().contains('bold') ?? false,
        );
    final span = markdownText.textSpan!;
    expect(span.toPlainText(), 'This is bold and italic.');
    expect(span.toPlainText(), isNot(contains('**')));
    expect(_hasStyledText(span, 'bold', FontWeight.bold), isTrue);
  });
}

bool _hasStyledText(InlineSpan span, String text, FontWeight weight) {
  if (span is TextSpan) {
    if (span.text == text && span.style?.fontWeight == weight) return true;
    return span.children?.any((child) => _hasStyledText(child, text, weight)) ??
        false;
  }
  return false;
}

class _FakeAiService implements AiService {
  @override
  Future<String> generateReply(String userMessage) async => 'Test reply';

  @override
  void close() {}
}

class _MemoryMessageRepository implements MessageRepository {
  final savedMessages = <(String, String)>[];

  @override
  Future<void> saveMessage({
    required String conversationId,
    required String sender,
    required String content,
  }) async {
    savedMessages.add((sender, content));
  }
}

class _FailingMessageRepository implements MessageRepository {
  @override
  Future<void> saveMessage({
    required String conversationId,
    required String sender,
    required String content,
  }) async {
    throw Exception('Database unavailable');
  }
}
