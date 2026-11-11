
import 'package:ong_adocao_app/models/animal.dart';
import '../services/animal_service.dart';
import '../network/requester.dart';

class AnimalRepository {
  final AnimalService _service = AnimalService();

  Future<void> cadastrarAnimal(
      Map<String, dynamic> dados,
      List<int> foto1,
      List<int> foto2,
      String nomeFoto1,
      String nomeFoto2,
      ) async {
    await _service.cadastrarAnimal(
      dados,
      foto1,
      foto2,
      nomeFoto1,
      nomeFoto2,
    );
  }


  Future<void> editarAnimal(
      String id,
      Map<String, dynamic> dados,
      ) async {
    await _service.editarAnimal(id, dados);
  }

  Future<void> excluirAnimal(String id) async {
    await _service.excluirAnimal(id);
  }


  Future<List<Animal>> buscarAnimais() async {
    final dados = await _service.buscarAnimais();



    final dynamic lista = dados is List
        ? dados
        : dados is Map
        ? dados['animais']
        : null;

    if (lista is! List) {
      throw const FormatException(
        'Formato da lista de animais inválido.',
      );
    }

    return lista.map((item) {
      final json = Map<String, dynamic>.from(item as Map);

      return Animal(
        id: (json['_id'] ?? json['id'] ?? '').toString(),
        nome: (json['nome'] ?? '').toString(),
        especie: (json['especie'] ?? '').toString(),
        raca: (json['raca'] ?? '').toString(),
        idadeEstimada:
        int.tryParse('${json['idadeEstimada'] ?? 0}') ?? 0,
        porte: (json['porte'] ?? '').toString(),
        foto1: _urlFoto(json['foto1']),
        foto2: _urlFoto(json['foto2']),
        temperamento: (json['temperamento'] ?? '').toString(),
        historicoVacina:
        (json['historicoVacina'] ?? '').toString(),
      );
    }).toList();
  }

  String _urlFoto(dynamic valor) {
    final foto = (valor ?? '').toString();

    if (foto.isEmpty) return '';

    if (foto.startsWith('http://') ||
        foto.startsWith('https://')) {
      return foto;
    }

    final baseUrl = Requester().baseUrl;

    final nomeArquivo = foto.startsWith('/')
        ? foto.substring(1)
        : foto;

    final caminho = nomeArquivo.startsWith('uploads/')
        ? nomeArquivo
        : 'uploads/$nomeArquivo';

    return '$baseUrl/$caminho';
  }
}
