
import 'package:flutter/material.dart';

import '../../viewmodels/detalhes_solicitacao_viewmodel.dart';
import '../theme/app_colors.dart';
import 'adoption_form_screen.dart';

class DetalhesSolicitacaoView extends StatefulWidget {
  final String formularioId;

  const DetalhesSolicitacaoView({
    super.key,
    required this.formularioId,
  });

  @override
  State<DetalhesSolicitacaoView> createState() =>
      _DetalhesSolicitacaoViewState();
}

class _DetalhesSolicitacaoViewState
    extends State<DetalhesSolicitacaoView> {
  final viewModel = DetalhesSolicitacaoViewModel();

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


  Future<void> _baixarPdf() async {
    if (viewModel.gerandoPdf) return;

    try {
      await viewModel.baixarPdf(
        widget.formularioId,
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao gerar PDF: $error',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  String _textoStatus(String status) {
    switch (status) {
      case 'em_analise':
        return 'Em análise';
      case 'finalizado_ok':
        return 'Finalizado OK';
      case 'negado':
        return 'Negado';
      default:
        return 'Status desconhecido';
    }
  }

  Color _corStatus(String status) {
    switch (status) {
      case 'em_analise':
        return Colors.orange.shade800;
      case 'finalizado_ok':
        return Colors.green.shade700;
      case 'negado':
        return Colors.red.shade700;
      default:
        return AppColors.textGray;
    }
  }

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
            valor.isEmpty ? 'Não informado' : valor,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _editarFormulario() async {
    if (viewModel.buscandoAnimal) return;

    try {
      final animal = await viewModel.buscarAnimalParaEdicao(
        widget.formularioId,
      );

      if (!mounted) return;

      final formulario = viewModel.formulario;

      if (formulario == null ||
          formulario['status'] != 'em_analise') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Esta solicitação não está disponível para edição.',
            ),
          ),
        );
        return;
      }

      final alterou = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => AdoptionFormScreen(
            animal: animal,
            formulario: formulario,
          ),
        ),
      );

      if (!mounted) return;

      // Atualiza os dados após retornar da edição.
      await viewModel.carregarFormulario(widget.formularioId);

      if (!mounted) return;

      if (alterou == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Solicitação atualizada com sucesso!',
            ),
            backgroundColor: AppColors.primaryGreen,
          ),
        );
      }
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString().replaceFirst('Exception: ', ''),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detalhes da Solicitação'),
        backgroundColor: AppColors.cardBackground,
        foregroundColor: AppColors.textDark,
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

          if (viewModel.erro != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      viewModel.erro!,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () =>
                          viewModel.carregarFormulario(
                            widget.formularioId,
                          ),
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          final formulario = viewModel.formulario;

          if (formulario == null) {
            return const Center(
              child: Text('Formulário não encontrado.'),
            );
          }

          final animal = formulario['animalId'] is Map
              ? Map<String, dynamic>.from(
            formulario['animalId'],
          )
              : <String, dynamic>{};

          final nomeAnimal =
          (animal['nome'] ?? 'Animal não encontrado')
              .toString();

          final status =
          (formulario['status'] ?? '').toString();

          final corStatus = _corStatus(status);

          return RefreshIndicator(
            onRefresh: () => viewModel.carregarFormulario(
              widget.formularioId,
            ),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  color: AppColors.cardBackground,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 28,
                          backgroundColor:
                          AppColors.onboardingHero,
                          child: Icon(
                            Icons.pets,
                            color: AppColors.primaryGreen,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                nomeAnimal,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Solicitação de adoção',
                                style: TextStyle(
                                  color: AppColors.textGray,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: corStatus.withValues(
                                alpha: 0.12,
                              ),
                              borderRadius:
                              BorderRadius.circular(20),
                            ),
                            child: Text(
                              _textoStatus(status),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: corStatus,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Card(
                  color: AppColors.cardBackground,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dados do Formulário',
                          style: TextStyle(
                            color: AppColors.primaryGreen,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),

                        _campo(
                          'Nome completo',
                          (formulario['nome'] ?? '').toString(),
                        ),
                        _campo(
                          'E-mail',
                          (formulario['email'] ?? '').toString(),
                        ),
                        _campo(
                          'Telefone',
                          (formulario['telefone'] ?? '').toString(),
                        ),
                        _campo(
                          'Tipo de moradia',
                          (formulario['tipoMoradia'] ?? '')
                              .toString(),
                        ),
                        _campo(
                          'Tempo médio sozinho',
                          (formulario['tempoMedioSozinho'] ?? '')
                              .toString(),
                        ),
                        _campo(
                          'Mensagem',
                          (formulario['mensagem'] ?? '')
                              .toString(),
                        ),
                        _campo(
                          'Termos de adoção',
                          formulario['aceitarTermos'] == true
                              ? 'Aceitos'
                              : 'Não aceitos',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                if (viewModel.podeEditar) ...[
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: viewModel.buscandoAnimal
                          ? null
                          : _editarFormulario,
                      icon: const Icon(Icons.edit),
                      label: const Text('Editar Formulário'),
                      style: FilledButton.styleFrom(
                        backgroundColor:
                        AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        padding:
                        const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],


                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: viewModel.gerandoPdf
                        ? null
                        : _baixarPdf,
                    icon: viewModel.gerandoPdf
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primaryGreen,
                      ),
                    )
                        : const Icon(Icons.picture_as_pdf),
                    label: Text(
                      viewModel.gerandoPdf
                          ? 'Gerando PDF...'
                          : 'Baixar PDF',
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryGreen,
                      side: const BorderSide(
                        color: AppColors.primaryGreen,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                    ),
                  ),
                )

              ],
            ),
          );
        },
      ),
    );
  }
}
