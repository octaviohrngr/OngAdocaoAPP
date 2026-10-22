/// Erro de autenticação com mensagem pronta para exibição.
class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AuthService {
  const AuthService();

  static const _testEmail = 'teste@atipattas.com';
  static const _testPassword = '123456';

  static const _adminEmail = 'admin@atipattas.com';
  static const _adminPassword = '123456';

  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 900),
    );

    final emailDigitado = email.trim().toLowerCase();

    if (emailDigitado == _adminEmail &&
        password == _adminPassword) {
      return 'admin';
    }

    if (emailDigitado == _testEmail &&
        password == _testPassword) {
      return 'usuario';
    }

    throw const AuthException(
      'E-mail ou senha incorretos.',
    );
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 900),
    );

    if (email.trim().toLowerCase() == _testEmail ||
        email.trim().toLowerCase() == _adminEmail) {
      throw const AuthException(
        'Este e-mail já está cadastrado.',
      );
    }
  }
}
