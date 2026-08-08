class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String? photoUrl;
  final String themePreference;
  final DateTime createdAt;
  final DateTime lastLogin;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.photoUrl,
    required this.themePreference,
    required this.createdAt,
    required this.lastLogin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? 'User',
      photoUrl: json['photo_url'],
      themePreference: json['theme_preference'] ?? 'system',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      lastLogin: json['last_login'] != null ? DateTime.parse(json['last_login']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'photo_url': photoUrl,
      'theme_preference': themePreference,
      'created_at': createdAt.toIso8601String(),
      'last_login': lastLogin.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? fullName,
    String? photoUrl,
    String? themePreference,
    DateTime? lastLogin,
  }) {
    return UserModel(
      id: id,
      email: email,
      fullName: fullName ?? this.fullName,
      photoUrl: photoUrl ?? this.photoUrl,
      themePreference: themePreference ?? this.themePreference,
      createdAt: createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}