
import 'package:flutter/material.dart';

import '../models/notificacao.dart';
import '../data/repository/notificacao_repository.dart';

class NotificacoesViewModel extends ChangeNotifier {
  final NotificacaoRepository _repository =
  NotificacaoRepository();

  List<Notificacao> _notificacoes = [];
  bool _carregando = false;
  String? _erro;
  String? _marcandoId;

  List<Notificacao> get notificacoes => _notificacoes;
  bool get carregando => _carregando;
  String? get erro => _erro;

  int get quantidadeNaoLidas =>
      _notificacoes.where((n) => !n.lida).length;

  bool marcandoComoLida(String id) => _marcandoId == id;

  Future<void> carregarNotificacoes() async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      _notificacoes =
      await _repository.buscarNotificacoes();
    } catch (e) {
      _erro = 'Não foi possível carregar as notificações.';
      debugPrint('Erro ao buscar notificações: $e');
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  Future<bool> marcarComoLida(String id) async {
    if (_marcandoId != null) return false;

    _marcandoId = id;
    _erro = null;
    notifyListeners();

    try {
      await _repository.marcarComoLida(id);

      _notificacoes = _notificacoes.map((notificacao) {
        if (notificacao.id != id) return notificacao;

        return Notificacao(
          id: notificacao.id,
          usuarioId: notificacao.usuarioId,
          formularioId: notificacao.formularioId,
          titulo: notificacao.titulo,
          mensagem: notificacao.mensagem,
          tipo: notificacao.tipo,
          lida: true,
          createdAt: notificacao.createdAt,
        );
      }).toList();

      return true;
    } catch (e) {
      _erro = 'Não foi possível marcar a notificação como lida.';
      debugPrint('Erro ao marcar notificação: $e');
      return false;
    } finally {
      _marcandoId = null;
      notifyListeners();
    }
  }
}
