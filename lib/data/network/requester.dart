
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_session.dart';

class Requester {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:3000',
    ),
  )..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Primeiro procura o token na sessão atual.
        String? token = AuthSession.token;

        // Se não encontrar, procura no armazenamento local.
        if (token == null || token.isEmpty) {
          final prefs = await SharedPreferences.getInstance();
          token = prefs.getString('token');
        }

        // Envia o token para a API.
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        handler.next(options);
      },
    ),
  );
}
