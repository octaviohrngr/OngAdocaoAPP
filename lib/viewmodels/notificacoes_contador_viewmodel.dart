
import 'package:flutter/foundation.dart';

import '../data/repository/notificacao_repository.dart';

class NotificacoesContadorViewModel extends ChangeNotifier {
  final NotificacaoRepository _repository =
  NotificacaoRepository();

  int _quantidadeNaoLidas = 0;
  bool _disposed = false;

  int get quantidadeNaoLidas => _quantidadeNaoLidas;

  Future<void> carregarQuantidade() async {
    try {
      final quantidade = await _repository.contarNaoLidas();

      if (_disposed) return;

      _quantidadeNaoLidas = quantidade;
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao contar notificações: $e');
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
