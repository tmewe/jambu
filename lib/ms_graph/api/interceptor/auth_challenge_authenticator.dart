import 'dart:async';
import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:jambu/repository/repository.dart';
import 'package:jambu/storage/storage.dart';

/// Refreshes the access token if it gets invalidated.
class AuthChallengeAuthenticator extends Authenticator {
  AuthChallengeAuthenticator({
    required TokenStorage tokenStorage,
    required UserRepository userRepository,
  })  : _tokenStorage = tokenStorage,
        _userRepository = userRepository;

  final TokenStorage _tokenStorage;
  final UserRepository _userRepository;

  @override
  FutureOr<Request?> authenticate(
    Request request,
    Response<dynamic> response, [
    Request? originalRequest,
  ]) async {
    if (response.statusCode != HttpStatus.unauthorized) return null;

    // TODO(tim): Replace using refresh token
    await _userRepository.reauthenticate();
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
