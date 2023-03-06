import 'dart:async';
import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:jambu/storage/storage.dart';

class AuthInterceptor implements RequestInterceptor {
  AuthInterceptor({
    required TokenStorage tokenStorage,
  }) : _tokenStorage = tokenStorage;

  final TokenStorage _tokenStorage;

  @override
  Future<Request> onRequest(Request request) async {
    final accessToken = await _tokenStorage.readAccessToken();
    if (accessToken != null) {
      final authRequest = applyHeader(
        request,
        HttpHeaders.authorizationHeader,
        'Bearer $accessToken',
      );
      return authRequest;
    }
    return request;
  }
}
