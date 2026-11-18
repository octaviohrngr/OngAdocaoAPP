
import '../../models/notificacao.dart';
import '../services/notificacao_service.dart';

class NotificacaoRepository {
  final NotificacaoService _service =
  NotificacaoService();

  Future<List<Notificacao>> buscarNotificacoes() async {
    final resposta = await _service.buscarNotificacoes();

    if (resposta is! List) {
      throw Exception(
        'Resposta inválida ao buscar notificações.',
      );
    }

    return resposta.map((item) {
      return Notificacao.fromJson(
        Map<String, dynamic>.from(item as Map),
      );
    }).toList();
  }

  Future<int> contarNaoLidas() async {
    final resposta = await _service.contarNaoLidas();

    if (resposta is! Map) {
      throw Exception(
        'Resposta inválida ao contar notificações.',
      );
    }

    final quantidade = resposta['quantidade'];

    if (quantidade is! int) {
      throw Exception(
        'Quantidade de notificações inválida.',
      );
    }

    return quantidade;
  }

  Future<void> marcarComoLida(String id) async {
    await _service.marcarComoLida(id);
  }

  Future<void> marcarSolicitacoesComoLidas() async {
    await _service.marcarSolicitacoesComoLidas();
  }
}

