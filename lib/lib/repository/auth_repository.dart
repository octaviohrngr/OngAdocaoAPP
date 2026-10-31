import 'package:ong_adocao_app/models/usuario.dart';
import 'package:ong_adocao_app/services/api_service.dart';
import 'package:ong_adocao_app/services/auth_session.dart';

class AuthRepository {
  final ApiService _api;

  AuthRepository({ApiService? api}) : _api = api ?? ApiService();

  /// POST /auth/login
  /// Em caso de sucesso guarda o token e o usuário na sessão.
  Future<Usuario> login({
    required String email,
    required String senha,
  }) async {
    final data = await _api.post(
      '/auth/login',
      body: {'email': email, 'senha': senha},
    );

    final usuario = Usuario.fromJson(data['usuario']);

    AuthSession.token = data['token'];
    AuthSession.usuario = usuario;
    AuthSession.userRole = usuario.tipo;
    AuthSession.isLoggedIn = true;

    return usuario;
  }

  void logout() {
    AuthSession.limpar();
  }
}
