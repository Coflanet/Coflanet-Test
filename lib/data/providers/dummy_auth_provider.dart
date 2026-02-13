import 'package:coflanet/data/models/user_model.dart';
import 'package:coflanet/data/providers/auth_provider.dart';

/// Dummy authentication provider for development and testing
///
/// This provider simulates social login without actual SDK integration.
/// Use this during development or when SDKs are not yet configured.
class DummyAuthProvider implements AuthProvider {
  final SocialLoginType _type;
  bool _isSignedIn = false;

  DummyAuthProvider(this._type);

  @override
  SocialLoginType get type => _type;

  @override
  Future<UserModel> signIn() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));

    _isSignedIn = true;

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final providerName = _getProviderName();

    return UserModel(
      id: '${_type.name}_user_$timestamp',
      email: '${_type.name}_user@example.com',
      name: '$providerName 사용자',
      profileImageUrl: null,
      provider: _type.name,
      accessToken: '${_type.name}_dummy_token_$timestamp',
      refreshToken: '${_type.name}_dummy_refresh_$timestamp',
    );
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _isSignedIn = false;
  }

  @override
  Future<bool> isSignedIn() async {
    return _isSignedIn;
  }

  @override
  Future<UserModel?> refreshToken(UserModel currentUser) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return currentUser.copyWith(
      accessToken:
          '${_type.name}_refreshed_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  Future<void> unlink() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _isSignedIn = false;
  }

  String _getProviderName() {
    switch (_type) {
      case SocialLoginType.kakao:
        return '카카오';
      case SocialLoginType.naver:
        return '네이버';
      case SocialLoginType.apple:
        return 'Apple';
      case SocialLoginType.guest:
        return '게스트';
    }
  }
}
