import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor implements RequestInterceptor, ResponseInterceptor {
  @override
  FutureOr<Request> onRequest(Request request) async {
    debugPrint('--> ${request.method} ${request.url}');
    return request;
  }

  @override
  FutureOr<Response<dynamic>> onResponse(Response<dynamic> response) {
    final responseError = response.error;
    if (responseError != null) {
      debugPrint('<-- ${response.statusCode} $responseError');
    }
    return response;
  }
}
