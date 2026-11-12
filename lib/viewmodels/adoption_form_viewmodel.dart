
import 'package:flutter/material.dart';

import '../models/animal.dart';
import '../data/repository/formulario_repository.dart';

class AdoptionFormViewModel extends ChangeNotifier {
  final FormularioRepository _repository =
  FormularioRepository();

  bool _isLoading = false;
  String? _mensagemErro;

  bool get isLoading => _isLoading;
  String? get mensagemErro => _mensagemErro;

  Future<bool> enviarSolicitacao({
    required Animal animal,
    required String nome,
    required String email,
    required String telefone,
    required String tipoMoradia,
    required String tempoMedioSozinho,
    required String mensagem,
    required bool aceitarTermos,
  }) async {
    if (_isLoading) return false;

    _isLoading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      final dados = <String, dynamic>{
        'animalId': animal.id,
        'nome': nome.trim(),
        'email': email.trim(),
        'telefone': telefone.trim(),
        'tipoMoradia': tipoMoradia,
        'tempoMedioSozinho': tempoMedioSozinho,
        'mensagem': mensagem.trim(),
        'aceitarTermos': aceitarTermos,
      };

      final resposta = await _repository.criarFormulario(
        dados,
      );

      if (resposta is Map &&
          resposta['formulario'] != null) {
        return true;
      }

      _mensagemErro =
      'A API não confirmou o cadastro do formulário.';
      return false;
    } catch (error) {
      _mensagemErro = error.toString().replaceFirst(
        'Exception: ',
        '',
      );
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
