class MessageModel {
  final String? id;
  final String conversationId;
  final String sender; // 'user' or 'ai'
  final String content;
  final DateTime createdAt;
  final String? reaction; // '👍' | '👎' | '❤️' | '⭐'
  final bool isFavorite;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.content,
    required this.createdAt,
    this.reaction,
    this.isFavorite = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      conversationId: json['conversation_id'],
      sender: json['sender'],
      content: json['content'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      reaction: json['reaction'],
      isFavorite: json['is_favorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'conversation_id': conversationId,
      'sender': sender,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }

  MessageModel copyWith({
    String? conversationId,
    String? content,
    String? reaction,
    bool? isFavorite,
  }) {
    return MessageModel(
      id: id,
      conversationId: conversationId ?? this.conversationId,
      sender: sender,
      content: content ?? this.content,
      createdAt: createdAt,
      reaction: reaction ?? this.reaction,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
