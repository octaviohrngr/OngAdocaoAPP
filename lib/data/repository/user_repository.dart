import '../services/user_service.dart';
import '../../models/usuario.dart';

class UserRepository {
  final UserService _userService = UserService();
  final UserService _service = UserService();


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

  Future<Usuario> atualizarUsuario({
  required String id,
  required String nome,
  required String email,
  required String telefone,
  }) async {
    final response = await _service.atualizarUsuario(
      id,
      {
        'nome': nome,
        'email': email,
        'telefone': telefone,
      },
    );

    return Usuario.fromJson(
      Map<String, dynamic>.from(response['usuario']),
    );
  }
}
