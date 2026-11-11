
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
}
