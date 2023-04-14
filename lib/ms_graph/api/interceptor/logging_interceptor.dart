import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor implements RequestInterceptor, ResponseInterceptor {
  @override
  FutureOr<Request> onRequest(Request request) async {
    final requestMessage = '--> ${request.method} ${request.url}';
    debugPrint(requestMessage);
    // debugPrint(request.body.toString());
    return request;
  }

  @override
  FutureOr<Response<dynamic>> onResponse(Response<dynamic> response) {
    final responseError = response.error;
    final responseMessage = '<-- ${response.statusCode}';
    debugPrint(
      responseError != null
          ? '$responseMessage $responseError'
          : responseMessage,
    );
    return response;
  }
}
