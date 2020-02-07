import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class NetworkClient extends BaseClient {
  NetworkClient({
    Client client,
    @required this.baseUrl,
    this.headers = const {},
  }) : this._client = client ?? Client();

  final Client _client;
  final String baseUrl;
  final Map<String, String> headers;

  @override
  Future<Response> post(url,
      {Map<String, String> headers, body, Encoding encoding}) {
    return super
        .post('$baseUrl$url', headers: headers, body: body, encoding: encoding);
  }

  @override
  Future<Response> get(url, {Map<String, String> headers}) {
    return super.get('$baseUrl$url', headers: headers);
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    request.headers.addAll(headers);
    return _client.send(request);
  }
}
