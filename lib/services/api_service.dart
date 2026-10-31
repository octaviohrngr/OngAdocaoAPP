import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ong_adocao_app/services/auth_session.dart';

/// Erro devolvido pela API (ou de conexão), já com mensagem pronta para o usuário.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// Cliente HTTP único do app. Só fala com a API, não conhece telas.
class ApiService {
  // Emulador Android acessa o PC por 10.0.2.2.
  // Celular físico: troque pelo IP do PC, ex.: 'http://192.168.0.10:3000'.
  static String get baseUrl {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000';
    }
    return 'http://localhost:3000';
  }

  Future<dynamic> get(String path) => _send('GET', path);

  Future<dynamic> post(String path, {Map<String, dynamic>? body}) =>
      _send('POST', path, body: body);

  Future<dynamic> put(String path, {Map<String, dynamic>? body}) =>
      _send('PUT', path, body: body);

  Future<dynamic> delete(String path) => _send('DELETE', path);

  Future<dynamic> _send(
      String method,
      String path, {
        Map<String, dynamic>? body,
      }) async {
    final uri = Uri.parse('$baseUrl$path');

    final headers = <String, String>{
      'Content-Type': 'application/json',
      // Envia o token automaticamente quando o usuário está logado
      if (AuthSession.token != null)
        'Authorization': 'Bearer ${AuthSession.token}',
    };

    final corpo = body == null ? null : jsonEncode(body);

    final Future<http.Response> requisicao = switch (method) {
      'POST' => http.post(uri, headers: headers, body: corpo),
      'PUT' => http.put(uri, headers: headers, body: corpo),
      'DELETE' => http.delete(uri, headers: headers),
      _ => http.get(uri, headers: headers),
    };

    final http.Response response;

    try {
      response = await requisicao.timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw ApiException('Tempo de conexão esgotado. Tente novamente.');
    } on http.ClientException {
      throw ApiException('Não foi possível conectar ao servidor.');
    }

    dynamic data;
    if (response.body.isNotEmpty) {
      try {
        data = jsonDecode(utf8.decode(response.bodyBytes));
      } catch (_) {
        data = null;
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    // A API devolve os erros no campo "mensagem"
    final mensagem = (data is Map && data['mensagem'] is String)
        ? data['mensagem'] as String
        : 'Erro inesperado (${response.statusCode}).';

    throw ApiException(mensagem, statusCode: response.statusCode);
  }
}
