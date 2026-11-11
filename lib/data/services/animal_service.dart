
import '../network/requester.dart';

class AnimalService {
  final Requester _requester = Requester();


  Future<dynamic> cadastrarAnimal(
      Map<String, dynamic> dados,
      List<int> foto1,
      List<int> foto2,
      String nomeFoto1,
      String nomeFoto2,
      ) async {
    return await _requester.post(
      '/animais',
      dados,
      foto1: foto1,
      foto2: foto2,
      nomeFoto1: nomeFoto1,
      nomeFoto2: nomeFoto2,
    );
  }

  Future<dynamic> buscarAnimais() async {
    return await _requester.get('/animais');
  }

  Future<dynamic> editarAnimal(
      String id,
      Map<String, dynamic> dados,
      ) async {
    return await _requester.put('/animais/$id', dados);
  }

  Future<dynamic> excluirAnimal(String id) async {
    return await _requester.delete('/animais/$id');
  }
}
