import '../services/password_reset_service.dart';

class PasswordResetRepository {
  final PasswordResetService _service =
  PasswordResetService();

  Future<dynamic> solicitarCodigo(String email) {
    return _service.solicitarCodigo(email);
  }

  Future<dynamic> verificarCodigo({
    required String email,
    required String codigo,
  }) {
    return _service.verificarCodigo(
      email: email,
      codigo: codigo,
    );
  }

  Future<dynamic> redefinirSenha({
    required String email,
    required String codigo,
    required String resetToken,
    required String novaSenha,
  }) {
    return _service.redefinirSenha(
      email: email,
      codigo: codigo,
      resetToken: resetToken,
      novaSenha: novaSenha,
    );
  }
}