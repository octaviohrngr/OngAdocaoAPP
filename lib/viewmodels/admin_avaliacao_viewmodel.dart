
import 'package:flutter/material.dart';

import '../models/formulario.dart';
import '../data/repository/formulario_repository.dart';

class AdminAvaliacaoViewModel extends ChangeNotifier {
  final FormularioRepository _repository =
  FormularioRepository();

  Formulario? _formulario;
  bool _carregando = false;
  String? _erro;

  Formulario? get formulario => _formulario;
  bool get carregando => _carregando;
  String? get erro => _erro;

  bool _salvando = false;

  bool get salvando => _salvando;

  bool get podeAvaliar =>
      _formulario?.status == 'em_analise';

  Future<bool> atualizarStatus(String status) async {
    if (_formulario == null || _salvando || !podeAvaliar) {
      return false;
    }

    _salvando = true;
    _erro = null;
    notifyListeners();

    final id = _formulario!.id;

    try {
      await _repository.atualizarStatus(id, status);

      final resposta = await _repository.buscarFormulario(id);
      _formulario = Formulario.fromJson(resposta);

      return true;
    } catch (e) {
      _erro = e.toString();
      return false;
    } finally {
      _salvando = false;
      notifyListeners();
    }
  }

  Future<void> carregarFormulario(String id) async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      final resposta = await _repository.buscarFormulario(id);
      debugPrint('FORMULARIO RECEBIDO: $resposta');

      _formulario = Formulario.fromJson(resposta);
    } catch (e) {
      _erro = e.toString();
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }
}
