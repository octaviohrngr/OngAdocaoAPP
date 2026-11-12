
import '../../models/evento.dart';
import '../services/evento_service.dart';


class EventoRepository {
  final EventoService _service = EventoService();

  Future<List<Evento>> buscarEventos() async {
    final resposta = await _service.buscarEventos();

    final dynamic dados;

    if (resposta is List) {
      dados = resposta;
    } else if (resposta is Map) {
      dados = resposta['eventos'];
    } else {
      throw Exception('Resposta inválida da API.');
    }

    if (dados is! List) {
      throw Exception('Lista de eventos inválida.');
    }

    return dados.map((item) {
      final json = Map<String, dynamic>.from(item as Map);
      final evento = Evento.fromJson(json);

      String foto = evento.foto;

      if (foto.isNotEmpty &&
          !foto.startsWith('http://') &&
          !foto.startsWith('https://')) {

        final nomeArquivo = foto.startsWith('/')
            ? foto.substring(1)
            : foto;

        final caminho = nomeArquivo.startsWith('uploads/')
            ? nomeArquivo
            : 'uploads/$nomeArquivo';

        final baseUrl = _service.baseUrl.replaceFirst(RegExp(r'/$'), '');

        foto = '$baseUrl/$caminho';
      }

      return Evento(
        id: evento.id,
        titulo: evento.titulo,
        dataHora: evento.dataHora,
        localizacao: evento.localizacao,
        descricao: evento.descricao,
        foto: foto,
      );
    }).toList();
  }

  Future<void> cadastrarEvento(
      Map<String, dynamic> dados, {
        List<int>? foto,
        String? nomeFoto,
      }) async {
    await _service.cadastrarEvento(
      dados,
      foto: foto,
      nomeFoto: nomeFoto,
    );
  }

  Future<void> editarEvento(
      String id,
      Map<String, dynamic> dados, {
        List<int>? foto,
        String? nomeFoto,
      }) async {
    await _service.editarEvento(
      id,
      dados,
      foto: foto,
      nomeFoto: nomeFoto,
    );
  }

  Future<void> excluirEvento(String id) async {
    await _service.excluirEvento(id);
  }
}
