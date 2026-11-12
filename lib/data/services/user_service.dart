
import '../network/requester.dart';

class UserService {
  final Requester _requester = Requester();

  Future<dynamic> cadastrarUsuario({
    required String nome,
    required String email,
    required String telefone,
    required String senha,
  }) async {
    return await _requester.post(
      '/usuarios',
      {
        'nome': nome,
        'email': email,
        'telefone': telefone,
        'senha': senha,
        'tipo': 'adotante',
      },
    );
  }


  Future<dynamic> atualizarUsuario(
      String id,
      Map<String, dynamic> dados,
      ) async {
    return await _requester.put(
      '/usuarios/$id',
      dados,
    );
  }
}
