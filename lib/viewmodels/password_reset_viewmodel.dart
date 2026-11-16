import 'package:flutter/material.dart';

import '../data/repository/password_reset_repository.dart';

class PasswordResetViewModel extends ChangeNotifier {
  final PasswordResetRepository _repository =
  PasswordResetRepository();

  bool _isLoading = false;
  String? _erro;

  bool get isLoading => _isLoading;
  String? get erro => _erro;

  Future<bool> solicitarCodigo(String email) async {
    _isLoading = true;
    _erro = null;
    notifyListeners();

    try {
      await _repository.solicitarCodigo(
        email.trim().toLowerCase(),
      );
      return true;
    } catch (e) {
      _erro = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> verificarCodigo({
    required String email,
    required String codigo,
  }) async {
    _isLoading = true;
    _erro = null;
    notifyListeners();

    try {
      final resposta = await _repository.verificarCodigo(
        email: email.trim().toLowerCase(),
        codigo: codigo,
      );

      if (resposta is Map &&
          resposta['tokenRecuperacao'] is String &&
          (resposta['tokenRecuperacao'] as String).isNotEmpty) {
        return resposta['tokenRecuperacao'] as String;
      }

      _erro = 'A API não confirmou o código.';
      return null;
    } catch (e) {
      _erro = e.toString().replaceFirst('Exception: ', '');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> redefinirSenha({
    required String email,
    required String codigo,
    required String resetToken,
    required String novaSenha,
  }) async {
    _isLoading = true;
    _erro = null;
    notifyListeners();

    try {
      final resposta = await _repository.redefinirSenha(
        email: email.trim().toLowerCase(),
        codigo: codigo,
        resetToken: resetToken,
        novaSenha: novaSenha,
      );

      if (resposta is Map &&
          resposta['sucesso'] == true) {
        return true;
      }

      _erro = 'A API não confirmou a alteração da senha.';
      return false;
    } catch (e) {
      _erro = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}