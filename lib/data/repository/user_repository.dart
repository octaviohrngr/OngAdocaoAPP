import '../services/user_service.dart';

class UserRepository {
  final UserService _userService = UserService();

  Future<void> cadastrarUsuario({
    required String nome,
    required String email,
    required String telefone,
    required String senha,
  }) async {
    await _userService.cadastrarUsuario(
      nome: nome,
      email: email,
      telefone: telefone,
      senha: senha,
    );
  }
}
