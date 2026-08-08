import 'package:aida/widgets/typing_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/chat_viewmodel.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/conversation_card.dart';
import '../widgets/search_bar_widget.dart';
import '../utils/constants.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatViewModel = Provider.of<ChatViewModel>(context);

    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child:
                          const Icon(Icons.auto_awesome, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'AIDA History',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SearchBarWidget(
                  onChanged: (q) => chatViewModel.setSearchQuery(q),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: chatViewModel.conversations.length,
                  itemBuilder: (context, index) {
                    final conv = chatViewModel.conversations[index];
                    return ConversationCard(
                      conversation: conv,
                      isSelected: conv.id == chatViewModel.activeConversationId,
                      onTap: () async {
                        await chatViewModel.selectConversation(conv.id);
                        Navigator.of(context).pop();
                      },
                      onDelete: () => chatViewModel.deleteConversation(conv.id),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.card),
                    ),
                  ),
                  onPressed: () {
                    chatViewModel.createNewConversation();
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('New Chat'),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: DropdownButton<String>(
          value: chatViewModel.selectedModel,
          underline: const SizedBox(),
          icon: const Icon(Icons.arrow_drop_down_rounded),
          items: const [
            DropdownMenuItem(
              value: 'gemini-3.6-flash',
              child: Text('Gemini 3.6 Flash',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DropdownMenuItem(
              value: 'llama-3.3-70b',
              child: Text('Groq Llama 3.3 70B',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
          onChanged: (val) {
            if (val != null) chatViewModel.setSelectedModel(val);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment_outlined),
            onPressed: () => chatViewModel.createNewConversation(),
            tooltip: 'New Conversation',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: chatViewModel.activeMessages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.auto_awesome,
                            size: 64,
                            color: AppColors.primary.withOpacity(0.4)),
                        const SizedBox(height: 16),
                        Text(
                          'How can I help you today?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: chatViewModel.activeMessages.length,
                    itemBuilder: (context, index) {
                      final msg = chatViewModel.activeMessages[index];
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
          ),
          if (chatViewModel.isGenerating) const TypingIndicator(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    decoration: InputDecoration(
                      hintText: 'Ask AIDA anything...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.card),
                      ),
                    ),
                    onSubmitted: (text) {
                      if (text.isNotEmpty) {
                        chatViewModel.sendMessage(text);
                        _inputController.clear();
                        _scrollToBottom();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.card),
                    ),
                  ),
                  icon: const Icon(Icons.send_rounded, color: Colors.white),
                  onPressed: () {
                    final text = _inputController.text;
                    if (text.isNotEmpty) {
                      chatViewModel.sendMessage(text);
                      _inputController.clear();
                      _scrollToBottom();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
