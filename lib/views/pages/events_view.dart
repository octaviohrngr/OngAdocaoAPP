
import 'package:flutter/material.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../../data/services/auth_session.dart';
import '../../models/evento.dart';
import '../../viewmodels/events_viewmodel.dart';
import '../theme/app_colors.dart';
import 'adoption_form_screen.dart';
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
            tooltip: AuthSession.token != null &&
                AuthSession.token!.isNotEmpty
                ? 'Meu perfil'
                : 'Fazer login',

            icon: const Icon(
              Icons.person_outline,
              color: AppColors.primaryGreen,
            ),

            onPressed: () {
              final usuarioLogado = AuthSession.token != null &&
                  AuthSession.token!.isNotEmpty;

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
                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                padding: EdgeInsets.fromLTRB(16, 6, 16, 20),
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
                        onPressed: viewModel.carregarEventos,
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
                  itemCount: viewModel.eventos.length,
                  itemBuilder: (context, index) {
                    final evento =
                    viewModel.eventos[index];

                    return _eventCard(
                      context,
                      evento,
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
        usuarioLogado: AuthSession.token != null &&
            AuthSession.token!.isNotEmpty,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const HomeView(),
              ),
            );
          } else if (index == 2 &&
              AuthSession.token != null &&
              AuthSession.token!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Central de notificações em breve.'),
              ),
            );
          } else if (index == 3 &&
              AuthSession.token != null &&
              AuthSession.token!.isNotEmpty) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const ProfileView(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _eventCard(
      BuildContext context,
      Evento evento,
      ) {
    return Card(
      color: AppColors.cardBackground,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            height: 125,
            width: double.infinity,
            color: AppColors.onboardingHero,
            child: evento.foto.isNotEmpty
                ? Image.network(
              evento.foto,
              width: double.infinity,
              height: 125,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  viewModel.iconeEvento(evento),
                  size: 58,
                  color: AppColors.accentGreen,
                );
              },
            )
                : Icon(
              viewModel.iconeEvento(evento),
              size: 58,
              color: AppColors.accentGreen,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.inputFill,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    viewModel.formatarData(evento.dataHora),
                    style: const TextStyle(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  evento.titulo,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                _eventInfo(
                  Icons.access_time,
                  viewModel.formatarHorario(evento.dataHora),
                ),
                const SizedBox(height: 7),
                _eventInfo(
                  Icons.location_on_outlined,
                  evento.localizacao,
                ),
                const SizedBox(height: 12),
                Text(
                  evento.descricao,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: AppColors.textGray,
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () =>
                        _showDetails(context, evento),
                    child: const Text('Ver detalhes'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _eventInfo(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 17,
          color: AppColors.accentGreen,
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textGray,
            ),
          ),
        ),
      ],
    );
  }

  void _showDetails(
      BuildContext context,
      Evento evento,
      ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  evento.titulo,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Data: ${viewModel.formatarData(evento.dataHora)}',
                ),
                Text(
                  'Horário: ${viewModel.formatarHorario(evento.dataHora)}',
                ),
                Text('Local: ${evento.localizacao}'),
                const SizedBox(height: 12),
                Text(evento.descricao),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HomeView(),
                        ),
                      );
                    },
                    child: const Text(
                      'Tenho interesse em adotar',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
