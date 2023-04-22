import 'dart:async';
import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:jambu/storage/storage.dart';
import 'package:jambu/user/user.dart';

/// Refreshes the access token if it gets invalidated.
class AuthChallengeAuthenticator extends Authenticator {
  AuthChallengeAuthenticator({
    required TokenStorage tokenStorage,
    required AuthRepository authRepository,
  })  : _tokenStorage = tokenStorage,
        _authRepository = authRepository;

  final TokenStorage _tokenStorage;
  final AuthRepository _authRepository;

  @override
  FutureOr<Request?> authenticate(
    Request request,
    Response<dynamic> response, [
    Request? originalRequest,
  ]) async {
    if (response.statusCode != HttpStatus.unauthorized) return null;

    // TODO(tim): Replace using refresh token
    await _authRepository.reauthenticate();
    final accessToken = await _tokenStorage.readAccessToken();

    if (accessToken == null) return null;

    return request.copyWith(
      headers: {
        ...request.headers,
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      },
    );
  }
}
