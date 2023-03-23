import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'package:jambu/ms_graph/model/model.dart';

@immutable
class MSBatchRequest extends Equatable {
  const MSBatchRequest({
    required this.id,
    required this.method,
    required this.url,
    this.body,
    this.headers,
  });

  factory MSBatchRequest.createOfficeEvent({
    required int id,
    required MSEvent event,
  }) {
    return MSBatchRequest(
      id: id,
      method: 'POST',
      url: '/me/events',
      headers: {'content-type': ContentType.json.mimeType},
      body: event.toMap(),
    );
  }

  factory MSBatchRequest.deleteOfficeEvent({
    required int id,
    required String eventId,
  }) {
    return MSBatchRequest(
      id: id,
      method: 'DELETE',
      url: '/me/events/$eventId',
    );
  }

  final int id;
  final String method;
  final String url;
  final Map<String, dynamic>? body;
  final Map<String, String>? headers;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id.toString(),
      'method': method,
      'url': url,
      if (body != null) 'body': body,
      if (headers != null) 'headers': headers,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  List<Object> get props {
    return [id, method, url];
  }

  @override
  bool get stringify => true;
}
