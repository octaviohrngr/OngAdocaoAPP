
import 'package:ong_adocao_app/models/usuario.dart';
import '../services/auth_service.dart';
import '../services/auth_session.dart';

class AuthRepository {
  final AuthService _service;

  AuthRepository({AuthService? service})
      : _service = service ?? AuthService();

  /// POST /auth/login
  /// Em caso de sucesso guarda o token e o usuário na sessão.
  Future<Usuario> login({
    required String email,
    required String senha,
  }) async {

    final data = await _service.login(
      email: email,
      senha: senha,
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
