
import '../../models/evento.dart';
import '../services/evento_service.dart';
import '../network/requester.dart';

class EventoRepository {
  final EventoService _service = EventoService();

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

  Future<List<Evento>> buscarEventos() async {
    final response = await _service.buscarEventos();
    final dynamic dados = response.data;

    final dynamic lista = dados is List
        ? dados
        : dados is Map
        ? dados['eventos']
        : null;

    if (lista is! List) {
      throw const FormatException(
        'Formato da lista de eventos inválido.',
      );
    }

    return lista.map((item) {
      final json = Map<String, dynamic>.from(item as Map);

      return Evento(
        id: (json['_id'] ?? json['id'] ?? '').toString(),
        titulo: (json['titulo'] ?? '').toString(),
        dataHora: DateTime.parse(json['dataHora'].toString()),
        localizacao: (json['localizacao'] ?? '').toString(),
        descricao: (json['descricao'] ?? '').toString(),
        foto: _urlFoto(json['foto']),
      );
    }).toList();
  }
}
