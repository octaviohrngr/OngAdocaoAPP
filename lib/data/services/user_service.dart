
import 'package:dio/dio.dart';
import '../network/requester.dart';




class UserService {
  final Dio _dio = Requester.dio;

  Future<Response> cadastrarUsuario({
    required String nome,
    required String email,
    required String telefone,
    required String senha,
  }) async {
    return await _dio.post(
      '/usuarios',
      data: {
        'nome': nome,
        'email': email,
        'telefone': telefone,
        'senha': senha,
        'tipo': 'adotante',
      },
    );
  }
}
