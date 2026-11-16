
import 'package:flutter/material.dart';

import '../../viewmodels/admin_solicitacoes_viewmodel.dart';
import '../theme/app_colors.dart';
import '../widgets/solicitacao_card.dart';
import '../widgets/admin_bottom_navigation_bar.dart';

import 'admin_avaliacao_view.dart';
import 'admin_animals_view.dart';
import 'admin_events_view.dart';

class AdminSolicitacoesView extends StatefulWidget {
  const AdminSolicitacoesView({super.key});

  @override
  State<AdminSolicitacoesView> createState() =>
      _AdminSolicitacoesViewState();
}

class _AdminSolicitacoesViewState
    extends State<AdminSolicitacoesView> {
  final AdminSolicitacoesViewModel viewModel =
  AdminSolicitacoesViewModel();

  @override
  void initState() {
    super.initState();

    // Carrega as solicitações cadastradas.
    viewModel.carregarSolicitacoes();

    // Marca como lidas as notificações de novas solicitações.
    viewModel.marcarNotificacoesComoLidas();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  // Abre a tela de avaliação da solicitação selecionada.
  Future<void> _abrirSolicitacao(String id) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdminAvaliacaoView(
          formularioId: id,
        ),
      ),
    );

    if (mounted) {
      await viewModel.carregarSolicitacoes();
    }
  }

  // Navegação entre as telas administrativas.
  void _navegar(int index) {
    if (index == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Dashboard ainda não implementado.',
          ),
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const AdminAnimalsView(),
        ),
      );
    } else if (index == 2) {
      // Já estamos na tela de Adoção.
      return;
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const AdminEventsView(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,

          appBar: AppBar(
            backgroundColor: AppColors.cardBackground,
            title: const Text(
              'Solicitações de Adoção',
              style: TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gerenciar solicitações',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  '${viewModel.pendentes} solicitações em análise',
                  style: const TextStyle(
                    color: AppColors.textGray,
                  ),
                ),

                const SizedBox(height: 18),

                TextField(
                  onChanged: viewModel.atualizarBusca,
                  decoration: InputDecoration(
                    hintText: 'Buscar por animal ou adotante',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: AppColors.inputFill,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                SizedBox(
                  height: 45,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: viewModel.filtros.map((filtro) {
                      final selecionado =
                          viewModel.filtro == filtro;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(filtro),
                          selected: selecionado,
                          onSelected: (_) {
                            viewModel.alterarFiltro(filtro);
                          },
                          selectedColor: AppColors.primaryGreen,
                          labelStyle: TextStyle(
                            color: selecionado
                                ? Colors.white
                                : AppColors.textDark,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 18),

                Expanded(
                  child: viewModel.isLoading
                      ? const Center(
                    child: CircularProgressIndicator(),
                  )
                      : viewModel.mensagemErro != null
                      ? Center(
                    child: Text(
                      viewModel.mensagemErro!,
                      textAlign: TextAlign.center,
                    ),
                  )
                      : viewModel.solicitacoesFiltradas.isEmpty
                      ? const Center(
                    child: Text(
                      'Nenhuma solicitação encontrada.',
                    ),
                  )
                      : RefreshIndicator(
                    onRefresh:
                    viewModel.carregarSolicitacoes,
                    child: ListView.builder(
                      itemCount: viewModel
                          .solicitacoesFiltradas.length,
                      itemBuilder: (context, index) {
                        final formulario = viewModel
                            .solicitacoesFiltradas[index];

                        return SolicitacaoCard(
                          formulario: formulario,
                          onTap: () =>
                              _abrirSolicitacao(
                                formulario.id,
                              ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Barra inferior compartilhada do administrador.
          // A chave muda após marcar notificações como lidas,
          // fazendo o contador consultar a API novamente.
          bottomNavigationBar: AdminBottomNavigationBar(
            key: ValueKey(viewModel.versaoNotificacoes),
            currentIndex: 2,
            onTap: _navegar,
          ),
        );
      },
    );
  }
}
