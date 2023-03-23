import 'dart:convert';

class MSBatchRequest {
  MSBatchRequest({
    required this.id,
    required this.method,
    required this.url,
    this.body,
    this.headers,
  });

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
}
