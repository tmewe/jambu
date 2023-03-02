import 'dart:async';

abstract class TokenStorage {
  FutureOr<String?> readAccessToken();
  FutureOr<String?> readRefreshToken();

  FutureOr<void> saveAccessToken(String token);
  FutureOr<void> saveRefreshToken(String token);

  /// Clears the current token.
  FutureOr<void> clearTokens();
}

class InMemoryTokenStorage implements TokenStorage {
  String? _accessToken;
  String? _refreshToken;

  @override
  void clearTokens() {
    _accessToken = null;
    _refreshToken = null;
  }

  @override
  String? readAccessToken() => _accessToken;

  @override
  String? readRefreshToken() => _refreshToken;

  @override
  void saveAccessToken(String token) => _accessToken = token;

  @override
  void saveRefreshToken(String token) => _refreshToken = token;
}
