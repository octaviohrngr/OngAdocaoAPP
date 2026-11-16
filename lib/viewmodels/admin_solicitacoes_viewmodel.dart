
import 'package:flutter/material.dart';

import '../models/formulario.dart';
import '../data/repository/formulario_repository.dart';
import '../data/repository/notificacao_repository.dart';

class AdminSolicitacoesViewModel extends ChangeNotifier {
  final FormularioRepository _repository = FormularioRepository();

  final NotificacaoRepository _notificacaoRepository =
  NotificacaoRepository();

  List<Formulario> _solicitacoes = [];

  bool _isLoading = false;
  String? _mensagemErro;
  String _filtro = 'Todas';
  String _busca = '';

  // Utilizado para atualizar o contador da barra inferior.
  int _versaoNotificacoes = 0;

  List<Formulario> get solicitacoes => _solicitacoes;
  bool get isLoading => _isLoading;
  String? get mensagemErro => _mensagemErro;
  String get filtro => _filtro;
  String get busca => _busca;

  int get versaoNotificacoes => _versaoNotificacoes;

  final List<String> filtros = [
    'Todas',
    'Em análise',
    'Aprovadas',
    'Negadas',
  ];

  // Carrega as solicitações de adoção da API.
  Future<void> carregarSolicitacoes() async {
    _isLoading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      final resposta = await _repository.buscarFormularios();

      _solicitacoes = resposta
          .map((json) => Formulario.fromJson(json))
          .toList();
    } catch (e) {
      _mensagemErro = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Marca as notificações de novas solicitações como lidas.
  // Executado quando o administrador abre a tela de Adoção.
  Future<void> marcarNotificacoesComoLidas() async {
    try {
      await _notificacaoRepository.marcarSolicitacoesComoLidas();

      // Força a barra inferior a consultar o contador novamente.
      _versaoNotificacoes++;
      notifyListeners();

      debugPrint(
        'Notificações de adoção marcadas como lidas.',
      );
    } catch (e) {
      debugPrint(
        'Erro ao marcar notificações de adoção como lidas: $e',
      );
    }
  }

  // Atualiza o filtro selecionado.
  void alterarFiltro(String filtro) {
    _filtro = filtro;
    notifyListeners();
  }

  // Atualiza o texto utilizado na pesquisa.
  void atualizarBusca(String texto) {
    _busca = texto.toLowerCase().trim();
    notifyListeners();
  }

  // Retorna apenas as solicitações que correspondem
  // ao filtro e à pesquisa.
  List<Formulario> get solicitacoesFiltradas {
    return _solicitacoes.where((solicitacao) {
      bool correspondeStatus = true;

      if (_filtro == 'Em análise') {
        correspondeStatus =
            solicitacao.status == 'em_analise';
      } else if (_filtro == 'Aprovadas') {
        correspondeStatus =
            solicitacao.status == 'finalizado_ok';
      } else if (_filtro == 'Negadas') {
        correspondeStatus =
            solicitacao.status == 'negado';
      }

      final correspondeBusca =
          solicitacao.nome.toLowerCase().contains(_busca) ||
              solicitacao.nomeAnimal.toLowerCase().contains(_busca);

      return correspondeStatus && correspondeBusca;
    }).toList();
  }

  // Quantidade de solicitações ainda em análise.
  int get pendentes => _solicitacoes
      .where((s) => s.status == 'em_analise')
      .length;

  // Converte o status da API para o texto apresentado.
  String statusFormatado(String status) {
    switch (status) {
      case 'em_analise':
        return 'Em análise';
      case 'finalizado_ok':
        return 'Aprovada';
      case 'negado':
        return 'Negada';
      default:
        return status;
    }
  }
}
