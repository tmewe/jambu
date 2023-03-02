// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String? readAccessToken() {
    return _accessToken;
  }

  @override
  String? readRefreshToken() => _refreshToken;

  @override
  void saveAccessToken(String token) {
    _accessToken = token;
  }

  @override
  void saveRefreshToken(String token) => _refreshToken = token;
}

class SecureTokenStorage implements TokenStorage {
  final _storage = const FlutterSecureStorage();
  final _accessTokenKey = 'access_token';
  final _refreshTokenKey = 'refresh_token';

  @override
  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  // https://github.com/mogol/flutter_secure_storage/issues/381
  @override
  Future<String?> readAccessToken() async {
    return _storage.read(key: _accessTokenKey);
  }

  @override
  Future<String?> readRefreshToken() async {
    return _storage.read(key: _refreshTokenKey);
  }

  @override
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }
}

class SharedPrefsTokenStorage implements TokenStorage {
  SharedPrefsTokenStorage({
    required SharedPreferences sharedPrefs,
  }) : _sharedPrefs = sharedPrefs;

  final SharedPreferences _sharedPrefs;
  final _accessTokenKey = 'access_token';
  final _refreshTokenKey = 'refresh_token';

  @override
  FutureOr<void> clearTokens() {
    _sharedPrefs
      ..remove(_accessTokenKey)
      ..remove(_refreshTokenKey);
  }

  @override
  Future<String?> readAccessToken() async {
    final token = _sharedPrefs.getString(_accessTokenKey);
    return token;
  }

  @override
  Future<String?> readRefreshToken() async {
    return _sharedPrefs.getString(_refreshTokenKey);
  }

  @override
  Future<void> saveAccessToken(String token) async {
    await _sharedPrefs.setString(_accessTokenKey, token);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await _sharedPrefs.setString(_refreshTokenKey, token);
  }
}
