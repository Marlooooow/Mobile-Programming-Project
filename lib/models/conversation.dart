class Conversation {
  const Conversation({
    required this.id,
    required this.title,
    required this.updatedAt,
    this.preview,
  });

  final String id;
  final String title;
  final DateTime updatedAt;
  final String? preview;

  factory Conversation.fromMap(Map<String, dynamic> map) {
    final title = (map['title'] as String?)?.trim();

    return Conversation(
      id: map['id'] as String,
      title: (title == null || title.isEmpty) ? 'Conversation' : title,
      preview: map['last_message']?.toString(),
      updatedAt:
          DateTime.tryParse(map['updated_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
