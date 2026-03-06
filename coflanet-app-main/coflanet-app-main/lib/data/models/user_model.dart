/// User model for authenticated user data
class UserModel {
  final String id;
  final String? email;
  final String? name;
  final String? profileImageUrl;
  final String provider; // kakao, naver, apple, guest
  final String accessToken;
  final String? refreshToken;

  const UserModel({
    required this.id,
    this.email,
    this.name,
    this.profileImageUrl,
    required this.provider,
    required this.accessToken,
    this.refreshToken,
  });

  /// Create from JSON (for storage)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String?,
      name: json['name'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      provider: json['provider'] as String,
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String?,
    );
  }

  /// Convert to JSON (for storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profile_image_url': profileImageUrl,
      'provider': provider,
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }

  /// Create a copy with updated fields
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? profileImageUrl,
    String? provider,
    String? accessToken,
    String? refreshToken,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      provider: provider ?? this.provider,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, provider: $provider)';
  }
}

/// Authentication exception
class AuthException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AuthException(this.message, {this.code, this.originalError});

  @override
  String toString() => 'AuthException: $message (code: $code)';
}
