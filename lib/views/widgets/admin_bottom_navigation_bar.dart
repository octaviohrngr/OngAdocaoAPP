
import 'package:flutter/material.dart';
import '../../data/repository/notificacao_repository.dart';
import '../../viewmodels/notificacoes_contador_viewmodel.dart';
import '../theme/app_colors.dart';

class AdminBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AdminBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<AdminBottomNavigationBar> createState() =>
      _AdminBottomNavigationBarState();
}

class _AdminBottomNavigationBarState
    extends State<AdminBottomNavigationBar> {
  final viewModel = NotificacoesContadorViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.carregarQuantidade();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  Widget _iconeAdocao(bool selecionado) {
    return Badge(
      isLabelVisible: viewModel.quantidadeNaoLidas > 0,
      backgroundColor: Colors.red,
      label: Text(
        viewModel.quantidadeNaoLidas > 99
            ? '99+'
            : '${viewModel.quantidadeNaoLidas}',
      ),
      child: Icon(
        selecionado
            ? Icons.volunteer_activism
            : Icons.volunteer_activism_outlined,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return BottomNavigationBar(
          currentIndex: widget.currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primaryGreen,
          unselectedItemColor: AppColors.textGray,

          onTap: (index) async {
            if (index == 2) {
              try {
                final repository = NotificacaoRepository();

                await repository.marcarSolicitacoesComoLidas();

                await viewModel.carregarQuantidade();

                debugPrint(
                  'Contador atualizado: '
                      '${viewModel.quantidadeNaoLidas}',
                );
              } catch (e) {
                debugPrint(
                  'Erro ao limpar avisos de adoção: $e',
                );
              }
            }

            if (!mounted) return;

            widget.onTap(index);
          },

          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              label: 'Dashboard',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.pets),
              label: 'Animais',
            ),
            BottomNavigationBarItem(
              icon: _iconeAdocao(false),
              activeIcon: _iconeAdocao(true),
              label: 'Adoção',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              label: 'Eventos',
            ),
          ],
        );
      },
    );
  }

}
