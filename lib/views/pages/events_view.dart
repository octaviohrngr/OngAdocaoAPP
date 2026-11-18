
import 'package:flutter/material.dart';

import 'notificacoes_view.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/event_card.dart';
import '../widgets/event_details_sheet.dart';

import '../../data/services/auth_session.dart';
import '../../models/evento.dart';
import '../../viewmodels/events_viewmodel.dart';

import '../theme/app_colors.dart';

import 'home_view.dart';
import 'profile_screen.dart';
import 'login_view.dart';

class EventsView extends StatefulWidget {
  const EventsView({super.key});

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  final EventsViewModel viewModel = EventsViewModel();

  bool get usuarioLogado =>
      AuthSession.token != null &&
          AuthSession.token!.isNotEmpty;

  @override
  void initState() {
    super.initState();
    viewModel.carregarEventos();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }


  void _navigate(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeView(),
        ),
      );
    }

    else if (index == 1) {
      return;
    }

    else if (index == 2 && usuarioLogado) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const NotificacoesView(),
        ),
      );
    }

    else if (index == 3 && usuarioLogado) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const ProfileView(),
        ),
      );
    }
  }


  void _showDetails(Evento evento) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      isScrollControlled: true,
      builder: (sheetContext) {
        return EventDetailsSheet(
          evento: evento,
          dataFormatada: viewModel.formatarData(
            evento.dataHora,
          ),
          horarioFormatado: viewModel.formatarHorario(
            evento.dataHora,
          ),
          onTenhoInteresse: () {
            Navigator.pop(sheetContext);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const HomeView(),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            Icon(
              Icons.pets,
              color: AppColors.primaryGreen,
            ),
            SizedBox(width: 8),
            Text(
              'Atipattas',
              style: TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: usuarioLogado
                ? 'Meu perfil'
                : 'Fazer login',
            icon: const Icon(
              Icons.person_outline,
              color: AppColors.primaryGreen,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => usuarioLogado
                      ? const ProfileView()
                      : const LoginView(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(
                  16, 16, 16, 0,
                ),
                child: Text(
                  'Encontre seu próximo evento',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(
                  16, 6, 16, 20,
                ),
                child: Text(
                  'Participe das ações e ajude os animais da nossa região.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textGray,
                  ),
                ),
              ),
              Expanded(
                child: viewModel.isLoading
                    ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryGreen,
                  ),
                )
                    : viewModel.mensagemErro != null
                    ? Center(
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Text(
                        viewModel.mensagemErro!,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed:
                        viewModel.carregarEventos,
                        child: const Text(
                          'Tentar novamente',
                        ),
                      ),
                    ],
                  ),
                )
                    : viewModel.eventos.isEmpty
                    ? const Center(
                  child: Text(
                    'Nenhum evento encontrado.',
                  ),
                )
                    : ListView.builder(
                  padding:
                  const EdgeInsets.fromLTRB(
                    16, 0, 16, 16,
                  ),
                  itemCount:
                  viewModel.eventos.length,
                  itemBuilder: (context, index) {
                    final evento =
                    viewModel.eventos[index];

                    return EventCard(
                      evento: evento,
                      dataFormatada:
                      viewModel.formatarData(
                        evento.dataHora,
                      ),
                      horarioFormatado:
                      viewModel.formatarHorario(
                        evento.dataHora,
                      ),
                      iconeEvento:
                      viewModel.iconeEvento(
                        evento,
                      ),
                      onVerDetalhes: () =>
                          _showDetails(evento),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 1,
        usuarioLogado: usuarioLogado,
        onTap: _navigate,
      ),
    );
  }
}
