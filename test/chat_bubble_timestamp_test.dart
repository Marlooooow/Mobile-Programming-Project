import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aida/models/message_model.dart';
import 'package:aida/widgets/chat_bubble.dart';

void main() {
  testWidgets('shows timestamp below chat bubble', (tester) async {
    final message = MessageModel(
      id: '1',
      conversationId: 'c1',
      sender: 'user',
      content: 'Hello',
      createdAt: DateTime(2026, 8, 6, 9, 30),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChatBubble(
            message: message,
            onFavoriteToggle: () {},
            onReactionSelect: (_) {},
          ),
        ),
      ),
    );

    expect(find.textContaining('Today'), findsOneWidget);
    expect(find.textContaining('9:30'), findsOneWidget);
  });
}
