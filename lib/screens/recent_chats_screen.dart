import 'package:flutter/material.dart';

import '../models/conversation.dart';

class RecentChatsScreen extends StatelessWidget {
  const RecentChatsScreen({
    super.key,
    required this.conversations,
    required this.onConversationSelected,
    required this.onCreateConversation,
  });

  final List<Conversation> conversations;
  final void Function(Conversation conversation) onConversationSelected;
  final VoidCallback onCreateConversation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recent Chats')),
      body: conversations.isEmpty
          ? const Center(
              child: Text(
                'No conversation yet',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conversation = conversations[index];

                return ListTile(
                  title: Text(conversation.title),
                  subtitle: Text(conversation.preview ?? ''),
                  onTap: () {
                    onConversationSelected(conversation);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: onCreateConversation,
        child: const Icon(Icons.add),
      ),
    );
  }
}
