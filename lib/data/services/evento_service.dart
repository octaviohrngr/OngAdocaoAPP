
import '../network/requester.dart';

class EventoService {
  final Requester _requester = Requester();

  Future<dynamic> buscarEventos() async {
    return await _requester.get('/eventos');
  }

  Future<dynamic> cadastrarEvento(
      Map<String, dynamic> dados, {
        List<int>? foto,
        String? nomeFoto,
      }) async {
    return await _requester.post(
      '/eventos',
      dados,
      foto: foto,
      nomeFoto: nomeFoto,
    );
  }

  Future<dynamic> editarEvento(
      String id,
      Map<String, dynamic> dados, {
        List<int>? foto,
        String? nomeFoto,
      }) async {
    return await _requester.put(
      '/eventos/$id',
      dados,
      foto: foto,
      nomeFoto: nomeFoto,
    );
  }

  Future<dynamic> excluirEvento(String id) async {
    return await _requester.delete('/eventos/$id');
  }

  String get baseUrl => _requester.baseUrl;
}
