import 'package:flutter_test/flutter_test.dart';
import 'package:aida/models/message_model.dart';

void main() {
  test('copyWith updates conversationId', () {
    final message = MessageModel(
      id: 'msg-1',
      conversationId: 'local-conv',
      sender: 'user',
      content: 'Hello',
      createdAt: DateTime(2026, 8, 6, 10, 0),
    );

    final updated = message.copyWith(
      conversationId: 'db-conv',
      content: 'Updated',
    );

    expect(updated.conversationId, 'db-conv');
    expect(updated.content, 'Updated');
  });
}
