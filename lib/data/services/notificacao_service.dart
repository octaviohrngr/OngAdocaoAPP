
import '../network/requester.dart';

class NotificacaoService {
  final Requester _requester = Requester();

  Future<dynamic> buscarNotificacoes() async {
    return await _requester.get('/notificacoes');
  }

  Future<dynamic> contarNaoLidas() async {
    return await _requester.get('/notificacoes/nao-lidas');
  }

  Future<dynamic> marcarComoLida(String id) async {
    return await _requester.patch(
      '/notificacoes/$id/lida',
      {},
    );
  }

  Future<void> marcarSolicitacoesComoLidas() async {
    await _requester.patch(
      '/notificacoes/solicitacoes/lidas',
      {},
    );
  }
}
