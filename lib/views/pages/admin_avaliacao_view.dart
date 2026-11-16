
import 'package:flutter/material.dart';

import '../../viewmodels/admin_avaliacao_viewmodel.dart';
import '../theme/app_colors.dart';

class AdminAvaliacaoView extends StatefulWidget {
  final String formularioId;

  const AdminAvaliacaoView({
    super.key,
    required this.formularioId,
  });

  @override
  State<AdminAvaliacaoView> createState() =>
      _AdminAvaliacaoViewState();
}

class _AdminAvaliacaoViewState
    extends State<AdminAvaliacaoView> {
  final AdminAvaliacaoViewModel viewModel =
  AdminAvaliacaoViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.carregarFormulario(widget.formularioId);
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  // Confirma a aprovação ou recusa da solicitação.
  Future<void> _avaliar(String status) async {
    final aprovar = status == 'finalizado_ok';

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            aprovar
                ? 'Aprovar solicitação?'
                : 'Negar solicitação?',
          ),
          content: Text(
            aprovar
                ? 'Deseja realmente aprovar esta adoção?'
                : 'Deseja realmente negar esta adoção?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
              ),
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );

    if (confirmar != true || !mounted) return;

    final sucesso = await viewModel.atualizarStatus(status);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          sucesso
              ? 'Status atualizado com sucesso!'
              : viewModel.erro ?? 'Erro ao atualizar status.',
        ),
        backgroundColor:
        sucesso ? AppColors.primaryGreen : Colors.red,
      ),
    );
  }

  // Exibe uma informação do formulário.
  Widget _campo(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              color: AppColors.textGray,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            valor.trim().isEmpty ? 'Não informado' : valor,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Cria uma seção visual para organizar os dados.
  Widget _secao({
    required String titulo,
    required IconData icone,
    required Widget conteudo,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icone,
                color: AppColors.primaryGreen,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          conteudo,
        ],
      ),
    );
  }

  // Converte o status para um texto legível.
  String _formatarStatus(String status) {
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

  // Exibe o status com uma cor diferente.
  Widget _status(String status) {
    Color cor;
    Color fundo;

    switch (status) {
      case 'finalizado_ok':
        cor = Colors.green.shade800;
        fundo = Colors.green.shade50;
        break;
      case 'negado':
        cor = Colors.red.shade800;
        fundo = Colors.red.shade50;
        break;
      default:
        cor = Colors.orange.shade900;
        fundo = Colors.orange.shade50;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _formatarStatus(status),
        style: TextStyle(
          color: cor,
          fontWeight: FontWeight.bold,
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
        title: const Text(
          'Avaliação da solicitação',
        ),
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.carregando) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final formulario = viewModel.formulario;

          if (formulario == null) {
            return Center(
              child: Text(
                viewModel.erro ??
                    'Solicitação não encontrada.',
                textAlign: TextAlign.center,
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 900,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.stretch,
                  children: [
                    // DADOS DO ANIMAL
                    _secao(
                      titulo: 'Dados do animal',
                      icone: Icons.pets,
                      conteudo: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          _campo(
                            'Animal solicitado',
                            formulario.nomeAnimal,
                          ),
                          const Text(
                            'Situação da solicitação',
                            style: TextStyle(
                              color: AppColors.textGray,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _status(formulario.status),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // DADOS DO ADOTANTE
                    _secao(
                      titulo: 'Dados do adotante',
                      icone: Icons.person_outline,
                      conteudo: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          _campo(
                            'Nome',
                            formulario.nome,
                          ),
                          _campo(
                            'E-mail',
                            formulario.email,
                          ),
                          _campo(
                            'Telefone',
                            formulario.telefone,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // RESPOSTAS DO FORMULÁRIO
                    _secao(
                      titulo: 'Respostas do formulário',
                      icone: Icons.description_outlined,
                      conteudo: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          _campo(
                            'Tipo de moradia',
                            formulario.tipoMoradia,
                          ),
                          _campo(
                            'Tempo médio sozinho',
                            formulario.tempoMedioSozinho,
                          ),
                          _campo(
                            'Mensagem do adotante',
                            formulario.mensagem,
                          ),
                          _campo(
                            'Aceitou os termos',
                            formulario.aceitarTermos
                                ? 'Sim'
                                : 'Não',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // AVALIAÇÃO DA ONG
                    _secao(
                      titulo: 'Avaliação da ONG',
                      icone: Icons.fact_check_outlined,
                      conteudo: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Decisão sobre a solicitação',
                            style: TextStyle(
                              color: AppColors.textDark,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            'Analise as informações do adotante antes de aprovar ou negar o pedido.',
                            style: TextStyle(
                              color: AppColors.textGray,
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(height: 24),

                          if (viewModel.salvando)
                            const Center(
                              child: CircularProgressIndicator(),
                            )
                          else if (viewModel.podeAvaliar)
                            Row(
                              children: [
                                // BOTÃO NEGAR
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () =>
                                        _avaliar('negado'),
                                    icon: const Icon(
                                      Icons.close,
                                    ),
                                    label: const Text('Negar'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.red,
                                      padding:
                                      const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                // BOTÃO APROVAR
                                Expanded(
                                  child: FilledButton.icon(
                                    onPressed: () =>
                                        _avaliar('finalizado_ok'),
                                    icon: const Icon(
                                      Icons.check,
                                    ),
                                    label: const Text('Aprovar'),
                                    style: FilledButton.styleFrom(
                                      backgroundColor:
                                      AppColors.primaryGreen,
                                      padding:
                                      const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            const Text(
                              'Esta solicitação já foi finalizada e não pode mais ser avaliada.',
                              style: TextStyle(
                                color: AppColors.textGray,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                          if (viewModel.erro != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              viewModel.erro!,
                              style: const TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
