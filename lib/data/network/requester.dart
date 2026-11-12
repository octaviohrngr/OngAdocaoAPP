
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../services/auth_session.dart';

class Requester {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.68.75.42:3000/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Requester() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Pega o token do usuário autenticado.
          String? token = AuthSession.token;

          if (token == null || token.isEmpty) {
            final prefs = await SharedPreferences.getInstance();
            token = prefs.getString('token');
          }

          // Envia o token para a API.
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          debugPrint('REQUISIÇÃO: ${options.method} ${options.path}');
          debugPrint('TOKEN PRESENTE: ${token != null && token.isNotEmpty}');
          handler.next(options);
        },
      ),
    );
  }

  // Buscar dados.
  Future<dynamic> get(String path) async {
    final response = await _dio.get(path);
    return response.data;
  }

  // Cadastrar dados.


  Future<dynamic> post(
      String path,
      Map<String, dynamic> body, {
        List<int>? foto1,
        List<int>? foto2,
        String? nomeFoto1,
        String? nomeFoto2,
        List<int>? foto,
        String? nomeFoto,
      }) async {
    try {
      dynamic dados = body;

      if (foto1 != null && foto2 != null) {
        dados = FormData.fromMap({
          ...body,
          'fotos': [
            MultipartFile.fromBytes(
              foto1,
              filename: nomeFoto1,
            ),
            MultipartFile.fromBytes(
              foto2,
              filename: nomeFoto2,
            ),
          ],
        });
      } else if (foto != null) {
        dados = FormData.fromMap({
          ...body,
          'foto': MultipartFile.fromBytes(
            foto,
            filename: nomeFoto,
          ),
        });
      }

      final response = await _dio.post(path, data: dados);
      return response.data;
    } on DioException catch (e) {
      throw Exception(mensagemErro(e));
    }
  }

  Future<dynamic> put(
      String path,
      Map<String, dynamic> body, {
        List<int>? foto,
        String? nomeFoto,
      }) async {
    try {
      dynamic dados = body;

      if (foto != null) {
        dados = FormData.fromMap({
          ...body,
          'foto': MultipartFile.fromBytes(
            foto,
            filename: nomeFoto,
          ),
        });
      }

      final response = await _dio.put(path, data: dados);
      return response.data;
    } on DioException catch (e) {
      debugPrint('STATUS HTTP: ${e.response?.statusCode}');
      debugPrint('RESPOSTA DA API: ${e.response?.data}');
      debugPrint('TIPO DO ERRO: ${e.type}');
      throw Exception(mensagemErro(e));
    }
  }
  // Excluir dados.
  Future<dynamic> delete(String path) async {
    final response = await _dio.delete(path);
    return response.data;
  }


  // Endereço da API, usado para carregar imagens.
  String get baseUrl => _dio.options.baseUrl;
}

String mensagemErro(DioException erro) {
  final status = erro.response?.statusCode;

  if (erro.type == DioExceptionType.connectionError) {
    return 'Não foi possível conectar à API.';
  }

  if (erro.type == DioExceptionType.connectionTimeout ||
      erro.type == DioExceptionType.receiveTimeout ||
      erro.type == DioExceptionType.sendTimeout) {
    return 'O servidor demorou para responder.';
  }

  if (status == 400) {
    return 'Dados inválidos. Verifique o cadastro.';
  }

  if (status == 401) {
    return 'Sessão expirada. Faça login novamente.';
  }

  if (status == 403) {
    return 'Você não tem permissão para realizar essa operação.';
  }

  if (status == 404) {
    return 'Recurso não encontrado na API.';
  }

  if (status == 413) {
    return 'As imagens ultrapassaram o tamanho permitido.';
  }

  if (status == 500) {
    return 'Erro interno da API.';
  }

  return 'Não foi possível completar a operação.';
}
