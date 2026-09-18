/// Erro de autenticação com mensagem pronta para exibição.
class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Camada de autenticação simulada.
///
/// Troque o corpo dos métodos pela sua API (Firebase, REST etc.) —
/// as telas só dependem da assinatura, não da implementação.
class AuthService {
  const AuthService();

  /// Credenciais de teste enquanto não há backend.
  static const _testEmail = 'teste@atipattas.com';
  static const _testPassword = '123456';

  Future<void> signIn({required String email, required String password}) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));

    if (email.trim().toLowerCase() != _testEmail || password != _testPassword) {
      throw const AuthException('E-mail ou senha incorretos.');
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));

    if (email.trim().toLowerCase() == _testEmail) {
      throw const AuthException('Este e-mail já está cadastrado.');
    }
  }
}
