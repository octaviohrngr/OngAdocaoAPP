
import 'package:flutter/material.dart';

import '../../viewmodels/minhas_solicitacoes_viewmodel.dart';
import '../theme/app_colors.dart';
import 'detalhes_solicitacao_view.dart';

class MinhasSolicitacoesView extends StatefulWidget {
  const MinhasSolicitacoesView({super.key});

  @override
  State<MinhasSolicitacoesView> createState() =>
      _MinhasSolicitacoesViewState();
}

class _MinhasSolicitacoesViewState
    extends State<MinhasSolicitacoesView> {

  final MinhasSolicitacoesViewModel viewModel =
  MinhasSolicitacoesViewModel();

  String _textoStatus(String status) {
    switch (status) {
      case 'finalizado_ok':
        return 'Finalizado OK';
      case 'negado':
        return 'Negado';
      case 'em_analise':
        return 'Em análise';
      default:
        return 'Status desconhecido';
    }
  }

  Color _corStatus(String status) {
    switch (status) {
      case 'finalizado_ok':
        return Colors.green;
      case 'negado':
        return Colors.red;
      case 'em_analise':
        return Colors.orange.shade800;
      default:
        return AppColors.textGray;
    }
  }

  @override
  void initState() {
    super.initState();
    viewModel.carregarFormularios();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text('Minhas Solicitações'),
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
                      onPressed: viewModel.carregarFormularios,
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (viewModel.formularios.isEmpty) {
            return const Center(
              child: Text(
                'Você ainda não enviou solicitações de adoção.',
                textAlign: TextAlign.center,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: viewModel.carregarFormularios,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: viewModel.formularios.length,
              itemBuilder: (context, index) {

                final formulario = viewModel.formularios[index];
                final status = (formulario['status'] ?? '').toString();

                final podeEditar = status == 'em_analise';
                final animal = formulario['animalId'] is Map
                    ? Map<String, dynamic>.from(
                  formulario['animalId'],
                )
                    : <String, dynamic>{};

                final nomeAnimal =
                (animal['nome'] ?? 'Animal não encontrado')
                    .toString();

                final data = DateTime.tryParse(
                  (formulario['createdAt'] ?? '').toString(),
                );

                final dataFormatada = data == null
                    ? 'Data não informada'
                    : '${data.day.toString().padLeft(2, '0')}/'
                    '${data.month.toString().padLeft(2, '0')}/'
                    '${data.year}';

                return Card(
                  color: AppColors.cardBackground,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),


                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),

                    leading: const CircleAvatar(
                      backgroundColor: AppColors.onboardingHero,
                      child: Icon(
                        Icons.pets,
                        color: AppColors.primaryGreen,
                      ),
                    ),

                    title: Text(
                      nomeAnimal,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),

                        Text(
                          'Solicitação enviada em $dataFormatada',
                          style: const TextStyle(
                            color: AppColors.textGray,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: _corStatus(status).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _textoStatus(status),
                            style: TextStyle(
                              color: _corStatus(status),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          podeEditar
                              ? 'Disponível para edição'
                              : 'Somente visualização e PDF',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textGray,
                          ),
                        ),
                      ],
                    ),

                    trailing: const Icon(
                      Icons.chevron_right,
                      color: AppColors.primaryGreen,
                    ),

                    onTap: () async {
                      final id = (formulario['_id'] ?? '').toString();

                      if (id.isEmpty) return;

                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetalhesSolicitacaoView(
                            formularioId: id,
                          ),
                        ),
                      );

                      if (!context.mounted) return;

                      await viewModel.carregarFormularios();
                    },
                  ),

                );
              },
            ),
          );
        },
      ),
    );
  }
}
