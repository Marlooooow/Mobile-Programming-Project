class ConversationModel {
  final String id;
  final String userId;
  final String title;
  final String aiModel;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;

  ConversationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.aiModel,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'] ?? 'New Conversation',
      aiModel: json['ai_model'] ?? 'gemini-3.6-flash',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
      isDeleted: json['is_deleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'ai_model': aiModel,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_deleted': isDeleted,
    };
  }

  ConversationModel copyWith({
    String? title,
    String? aiModel,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return ConversationModel(
      id: id,
      userId: userId,
      title: title ?? this.title,
      aiModel: aiModel ?? this.aiModel,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}