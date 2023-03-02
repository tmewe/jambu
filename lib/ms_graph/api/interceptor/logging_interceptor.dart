import 'dart:async';
import 'dart:developer';

import 'package:chopper/chopper.dart';

class LoggingInterceptor implements RequestInterceptor {
  @override
  FutureOr<Request> onRequest(Request request) async {
    final requestMessage = '--> ${request.method} ${request.url}';
    log(requestMessage);
    return request;
  }
}
