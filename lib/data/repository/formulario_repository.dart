import '../services/formulario_service.dart';

class FormularioRepository {
  final FormularioService _service = FormularioService();

  Future<dynamic> criarFormulario(
      Map<String, dynamic> dados,
      ) async {
    return await _service.criarFormulario(dados);
  }
}