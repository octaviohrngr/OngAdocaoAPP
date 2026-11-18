
import '../network/requester.dart';

class FormularioService {
  final Requester _requester = Requester();

  Future<dynamic> criarFormulario(
      Map<String, dynamic> dados,
      ) async {
    return await _requester.post(
      '/formularios',
      dados,
    );
  }

  Future<dynamic> buscarFormularios() async {
    return await _requester.get('/formularios');
  }

  Future<dynamic> buscarFormulario(String id) async {
    return await _requester.get('/formularios/$id');
  }

  Future<dynamic> atualizarFormulario(
      String id,
      Map<String, dynamic> dados,
      ) async {
    return await _requester.put(
      '/formularios/$id',
      dados,
    );
  }

  Future<dynamic> atualizarStatus(
      String id,
      String status,
      ) async {
    return await _requester.patch(
      '/formularios/$id/status',
      {'status': status},
    );
  }
}
