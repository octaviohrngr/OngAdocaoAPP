import '../services/formulario_service.dart';

class FormularioRepository {
  final FormularioService _service = FormularioService();

  Future<dynamic> criarFormulario(
      Map<String, dynamic> dados,
      ) async {
    return await _service.criarFormulario(dados);
  }
  Future<List<Map<String, dynamic>>> buscarFormularios() async {
    final resposta = await _service.buscarFormularios();

    if (resposta is! List) {
      throw Exception('Lista de formulários inválida.');
    }

    return resposta.map((item) {
      return Map<String, dynamic>.from(item as Map);
    }).toList();
  }

  Future<Map<String, dynamic>> buscarFormulario(
      String id,
      ) async {
    final resposta = await _service.buscarFormulario(id);

    return Map<String, dynamic>.from(resposta as Map);
  }

  Future<void> atualizarFormulario(
      String id,
      Map<String, dynamic> dados,
      ) async {
    await _service.atualizarFormulario(id, dados);
  }


  Future<dynamic> atualizarStatus(
      String id,
      String status,
      ) async {
    return await _service.atualizarStatus(id, status);
  }

}