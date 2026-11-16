import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../data/repository/auth_repository.dart';

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

    } catch (e) {
      debugPrint('Erro no login: $e');

      final mensagem = e.toString().replaceFirst(
        RegExp(r'^Exception:\s*'),
        '',
      );

      if (mensagem.contains('Sessão expirada')) {
        erro = 'E-mail ou senha incorretos.';
      } else {
        erro = mensagem;
      }

      return null;

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


}