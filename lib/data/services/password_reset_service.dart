
import '../network/requester.dart';

class PasswordResetService {
  final Requester _requester = Requester();

  Future<dynamic> solicitarCodigo(String email) {
    return _requester.post(
      '/auth/solicitar-codigo',
      {'email': email},
    );
  }

  Future<dynamic> verificarCodigo({
    required String email,
    required String codigo,
  }) {
    return _requester.post(
      '/auth/verificar-codigo',
      {
        'email': email,
        'codigo': codigo,
      },
    );
  }

  Future<dynamic> redefinirSenha({
    required String email,
    required String codigo,
    required String resetToken,
    required String novaSenha,
  }) {
    return _requester.post(
      '/auth/redefinir-senha',
      {
        'email': email,
        'tokenRecuperacao': resetToken,
        'novaSenha': novaSenha,
      },
    );
  }
}
