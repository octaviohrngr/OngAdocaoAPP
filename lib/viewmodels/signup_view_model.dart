
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../data/repository/user_repository.dart';

class SignupViewModel extends ChangeNotifier {
  final UserRepository _repository = UserRepository();

  bool _isLoading = false;
  bool _acceptedTerms = false;
  bool _termsError = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? _mensagemErro;

  bool get isLoading => _isLoading;
  bool get acceptedTerms => _acceptedTerms;
  bool get termsError => _termsError;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;
  String? get mensagemErro => _mensagemErro;

  void alterarTermos(bool? valor) {
    _acceptedTerms = valor ?? false;
    if (_acceptedTerms) _termsError = false;
    notifyListeners();
  }

  void alternarSenha() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void alternarConfirmacao() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  Future<bool> cadastrarUsuario({
    required bool formularioValido,
    required String nome,
    required String email,
    required String telefone,
    required String senha,
  }) async {
    _termsError = !_acceptedTerms;
    _mensagemErro = null;
    notifyListeners();

    if (!formularioValido || !_acceptedTerms) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _repository.cadastrarUsuario(
        nome: nome.trim(),
        email: email.trim(),
        telefone: telefone.trim(),
        senha: senha,
      );

      return true;
    } on DioException catch (e) {
      final resposta = e.response?.data;

      if (resposta is Map) {
        _mensagemErro = (
            resposta['message'] ??
                resposta['erro'] ??
                resposta['error'] ??
                'Não foi possível realizar o cadastro.'
        ).toString();
      } else {
        _mensagemErro = 'Não foi possível conectar ao servidor.';
      }

      return false;
    } catch (e) {
      _mensagemErro = 'Ocorreu um erro ao cadastrar usuário.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
