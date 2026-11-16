
import 'package:flutter/material.dart';

import '../../viewmodels/notificacoes_contador_viewmodel.dart';
import '../theme/app_colors.dart';

class AppBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool usuarioLogado;

  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.usuarioLogado,
  });

  @override
  State<AppBottomNavigationBar> createState() =>
      _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState
    extends State<AppBottomNavigationBar> {
  final NotificacoesContadorViewModel viewModel =
  NotificacoesContadorViewModel();

  @override
  void initState() {
    super.initState();

    if (widget.usuarioLogado) {
      viewModel.carregarQuantidade();
    }
  }

  @override
  void didUpdateWidget(
      covariant AppBottomNavigationBar oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.usuarioLogado && widget.usuarioLogado) {
      viewModel.carregarQuantidade();
    }
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  Widget _iconeNotificacoes(bool selecionado) {
    final quantidade = viewModel.quantidadeNaoLidas;

    return Badge(
      isLabelVisible: quantidade > 0,
      label: Text(
        quantidade > 99 ? '99+' : quantidade.toString(),
      ),
      backgroundColor: Colors.red,
      textColor: Colors.white,
      child: Icon(
        selecionado
            ? Icons.notifications
            : Icons.notifications_none,
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
          onTap: widget.onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.cardBackground,
          selectedItemColor: AppColors.primaryGreen,
          unselectedItemColor: AppColors.textGray,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          elevation: 8,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.event_note_outlined),
              activeIcon: Icon(Icons.event_note),
              label: 'Eventos',
            ),

            if (widget.usuarioLogado) ...[
              BottomNavigationBarItem(
                icon: _iconeNotificacoes(false),
                activeIcon: _iconeNotificacoes(true),
                label: 'Alertas',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Perfil',
              ),
            ],
          ],
        );
      },
    );
  }
}
