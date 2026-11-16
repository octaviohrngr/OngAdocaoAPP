
import 'package:flutter/material.dart';

import '../../models/notificacao.dart';
import '../../viewmodels/notificacoes_viewmodel.dart';
import '../theme/app_colors.dart';

class NotificacoesView extends StatefulWidget {
  const NotificacoesView({super.key});

  @override
  State<NotificacoesView> createState() =>
      _NotificacoesViewState();
}

class _NotificacoesViewState
    extends State<NotificacoesView> {
  final NotificacoesViewModel viewModel =
  NotificacoesViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.carregarNotificacoes();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  Future<void> _abrirNotificacao(
      Notificacao notificacao,
      ) async {
    if (notificacao.lida) return;

    final sucesso =
    await viewModel.marcarComoLida(notificacao.id);

    if (!mounted) return;

    if (!sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            viewModel.erro ??
                'Erro ao atualizar notificação.',
          ),
        ),
      );
    }
  }

  Widget _cardNotificacao(Notificacao notificacao) {
    final aprovada =
        notificacao.tipo == 'adocao_aprovada';

    return Card(
      color: AppColors.cardBackground,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: viewModel.marcandoComoLida(notificacao.id)
            ? null
            : () => _abrirNotificacao(notificacao),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: aprovada
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                child: Icon(
                  aprovada
                      ? Icons.check_circle_outline
                      : Icons.info_outline,
                  color: aprovada
                      ? AppColors.primaryGreen
                      : Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notificacao.titulo,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        if (!notificacao.lida)
                          Container(
                            width: 9,
                            height: 9,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notificacao.mensagem,
                      style: const TextStyle(
                        color: AppColors.textGray,
                        fontSize: 14,
                      ),
                    ),
                    if (viewModel.marcandoComoLida(
                      notificacao.id,
                    )) ...[
                      const SizedBox(height: 10),
                      const LinearProgressIndicator(
                        color: AppColors.primaryGreen,
                      ),
                    ],
                    if (!notificacao.lida) ...[
                      const SizedBox(height: 10),
                      const Text(
                        'Toque para marcar como lida',
                        style: TextStyle(
                          color: AppColors.primaryGreen,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        foregroundColor: AppColors.textDark,
        title: const Text('Minhas notificações'),
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.carregando) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryGreen,
              ),
            );
          }

          if (viewModel.erro != null &&
              viewModel.notificacoes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(viewModel.erro!),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed:
                    viewModel.carregarNotificacoes,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: viewModel.carregarNotificacoes,
            child: viewModel.notificacoes.isEmpty
                ? ListView(
              children: const [
                SizedBox(height: 120),
                Icon(
                  Icons.notifications_none,
                  size: 64,
                  color: AppColors.textGray,
                ),
                SizedBox(height: 16),
                Center(
                  child: Text(
                    'Nenhuma notificação disponível.',
                    style: TextStyle(
                      color: AppColors.textGray,
                    ),
                  ),
                ),
              ],
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: viewModel.notificacoes.length,
              itemBuilder: (context, index) {
                final notificacao =
                viewModel.notificacoes[index];

                return _cardNotificacao(notificacao);
              },
            ),
          );
        },
      ),
    );
  }
}
