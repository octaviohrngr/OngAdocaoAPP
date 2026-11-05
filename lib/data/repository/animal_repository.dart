
import 'package:ong_adocao_app/models/animal.dart';
import '../services/animal_service.dart';
import '../network/requester.dart';

class AnimalRepository {
  final AnimalService _service = AnimalService();

  Future<List<Animal>> buscarAnimais() async {
    final response = await _service.buscarAnimais();

    final dynamic dados = response.data;


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

    final baseUrl = Requester.dio.options.baseUrl;
    final caminho = foto.startsWith('/') ? foto : '/$foto';

    return '$baseUrl$caminho';
  }
}
