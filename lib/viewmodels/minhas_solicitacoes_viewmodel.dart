
import 'package:flutter/material.dart';
import '../data/repository/formulario_repository.dart';

class MinhasSolicitacoesViewModel extends ChangeNotifier {
  final FormularioRepository _repository = FormularioRepository();

  List<Map<String, dynamic>> _formularios = [];
  bool _carregando = false;
  String? _erro;

  List<Map<String, dynamic>> get formularios => _formularios;
  bool get carregando => _carregando;
  String? get erro => _erro;

  Future<void> carregarFormularios() async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      _formularios = await _repository.buscarFormularios();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }
}
