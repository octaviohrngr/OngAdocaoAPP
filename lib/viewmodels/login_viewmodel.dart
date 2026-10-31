import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ong_adocao_app/lib/repository/auth_repository.dart';
import 'package:ong_adocao_app/services/api_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();

  bool hidePassword = true;
  bool isLoading = false;
  String? erro;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  // Evita erro se o login terminar depois da tela ser fechada
  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  void toggleHidePassword() {
    hidePassword = !hidePassword;
    notifyListeners();
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe seu e-mail.';
    }

    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim())) {
      return 'Digite um e-mail válido.';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe sua senha.';
    }

    if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres.';
    }

    return null;
  }

  /// Retorna o tipo do usuário ('admin' ou 'adotante') se o login der certo,
  /// ou null se der erro (a mensagem fica em [erro]).
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    isLoading = true;
    erro = null;
    notifyListeners();

    try {
      final usuario = await _repository.login(
        email: email.trim(),
        senha: password,
      );

      return usuario.tipo;
    } on ApiException catch (e) {
      debugPrint('Erro no login (API): ${e.statusCode} - ${e.message}');
      erro = e.message;
      return null;
    } catch (e) {
      debugPrint('Erro inesperado no login: $e');
      erro = 'Não foi possível entrar. Tente novamente.';
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}