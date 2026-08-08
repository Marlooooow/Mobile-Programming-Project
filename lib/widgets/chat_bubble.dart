import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/message_model.dart';
import '../utils/constants.dart';
import '../utils/message_time_formatter.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel message;
  final VoidCallback onFavoriteToggle;
  final Function(String?) onReactionSelect;

  const ChatBubble({
    super.key,
    required this.message,
    required this.onFavoriteToggle,
    required this.onReactionSelect,
  });

  bool get isUser => message.sender == 'user';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser) ...[
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primary,
                  child: const Icon(Icons.auto_awesome, size: 18, color: Colors.white),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isUser
                        ? AppColors.primary
                        : (isDark ? const Color(0xFF1E293B) : Colors.white),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(AppRadius.card),
                      topRight: const Radius.circular(AppRadius.card),
                      bottomLeft: Radius.circular(isUser ? AppRadius.card : 4),
                      bottomRight: Radius.circular(isUser ? 4 : AppRadius.card),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: !isUser
                        ? Border.all(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          )
                        : null,
                  ),
                  child: isUser
                      ? Text(
                          message.content,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        )
                      : MarkdownBody(
                          data: message.content,
                          styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                            p: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                              fontSize: 15,
                              height: 1.5,
                            ),
                          ),
                        ),
                ),
              ),
              if (isUser) ...[
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.secondary,
                  child: const Icon(Icons.person, size: 18, color: Colors.white),
                ),
              ],
            ],
          ),
          Align(
            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: isUser ? 0 : 40,
                top: 4,
                right: isUser ? 0 : 0,
              ),
              child: Text(
                '${formatDateLabel(message.createdAt)} • ${formatTimestamp(message.createdAt)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 11,
                ),
              ),
            ),
          ),
          if (!isUser)
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      message.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: 18,
                      color: message.isFavorite ? Colors.amber : Colors.grey,
                    ),
                    onPressed: onFavoriteToggle,
                    tooltip: 'Favorite response',
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, size: 16, color: Colors.grey),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: message.content));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard!')),
                      );
                    },
                    tooltip: 'Copy text',
                  ),
                  if (message.reaction != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(message.reaction!, style: const TextStyle(fontSize: 12)),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}