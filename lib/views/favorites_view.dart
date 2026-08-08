import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/chat_viewmodel.dart';
import '../widgets/chat_bubble.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    final chatViewModel = Provider.of<ChatViewModel>(context);
    final favs = chatViewModel.favoriteMessages;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Favorites'),
      ),
      body: favs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star_outline_rounded,
                      size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No favorite responses saved yet',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: favs.length,
              itemBuilder: (context, index) {
                final msg = favs[index];
                return ChatBubble(
                  message: msg,
                  onFavoriteToggle: () {
                    if (msg.id != null) {
                      chatViewModel.toggleFavorite(msg.id!);
                    }
                  },
                  onReactionSelect: (r) {
                    if (msg.id != null) {
                      chatViewModel.setReaction(msg.id!, r);
                    }
                  },
                );
              },
            ),
    );
  }
}
