import 'package:flutter/material.dart';
import '../../viewmodels/profile_viewmodel.dart';
import '../theme/app_colors.dart';
import 'adoption_form_screen.dart';
import 'events_view.dart';
import 'home_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileViewModel viewModel = ProfileViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Perfil com Opção de Voluntariado',
                style: TextStyle(
                  color: AppColors.textGray,
                  fontSize: 12,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                children: [
                  _header(),
                  const SizedBox(height: 12),
                  _profileCard(),
                  const SizedBox(height: 12),
                  _notificationsCard(),
                  const SizedBox(height: 12),
                  _optionsCard(context),
                  const SizedBox(height: 12),
                  _supportCard(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavigation(context),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(Icons.pets, color: AppColors.primaryGreen),
        const Text(
          'Atipattas',
          style: TextStyle(
            color: AppColors.primaryGreen,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.tune,
            color: AppColors.primaryGreen,
          ),
        ),
      ],
    );
  }

  Widget _profileCard() {
    return Card(
      color: AppColors.cardBackground,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 34,
              backgroundColor: AppColors.onboardingHero,
              child: Icon(
                Icons.person,
                size: 42,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              viewModel.nomeUsuario,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textDark,
              ),
            ),
            Text(
              viewModel.emailUsuario,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textGray,
              ),
            ),
            const SizedBox(height: 6),
            if (viewModel.adotanteVerificada)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFB8F2D0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '✓ Adotante Verificada',
                  style: TextStyle(
                    color: AppColors.primaryGreen,
                    fontSize: 10,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit, size: 14),
              label: const Text('Editar Perfil'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accentGreen,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notificationsCard() {
    return Card(
      color: AppColors.cardBackground,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.notifications_none,
                  color: AppColors.primaryGreen,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Central de Notificações',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${viewModel.quantidadeNotificacoes}',
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...viewModel.notificacoes.map(
                  (item) => _notificationItem(
                item['icon'] as IconData,
                item['title'] as String,
                item['message'] as String,
                item['time'] as String,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notificationItem(
      IconData icon,
      String title,
      String message,
      String time,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: const Color(0xFFD9E8B8),
            child: Icon(
              icon,
              size: 17,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textGray,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 9,
                    color: AppColors.textGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _optionsCard(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _option(
            Icons.person_outline,
            'Meus Dados',
                () {},
          ),
          _option(
            Icons.filter_list,
            'Filtros Salvos',
                () {},
          ),
          _option(
            Icons.favorite_border,
            'Favoritos',
                () {},
          ),
          _option(
            Icons.volunteer_activism_outlined,
            'Cadastrar-se como voluntário',
                () => _showMessage(context, 'Área de voluntariado em breve.'),
          ),
          const Divider(color: AppColors.divider, height: 1),
          _option(
            Icons.logout,
            'Sair da Conta',
                () => _showMessage(context, 'Ação de sair ainda não conectada.'),
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _option(
      IconData icon,
      String title,
      VoidCallback onTap, {
        Color color = AppColors.textDark,
      }) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(vertical: -2),
      leading: Icon(icon, size: 18, color: color),
      title: Text(
        title,
        style: TextStyle(fontSize: 12, color: color),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        size: 18,
        color: AppColors.textGray,
      ),
      onTap: onTap,
    );
  }

  Widget _supportCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFB96CF5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.volunteer_activism,
            color: Colors.white,
            size: 25,
          ),
          SizedBox(height: 6),
          Text(
            'Precisa de ajuda?',
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
          SizedBox(height: 4),
          Text(
            'Nossa equipe de suporte está aqui para você.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            'Falar com Suporte',
            style: TextStyle(
              fontSize: 11,
              color: Colors.white,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomNavigation(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 3,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primaryGreen,
      unselectedItemColor: AppColors.textGray,
      backgroundColor: AppColors.cardBackground,
      selectedFontSize: 10,
      unselectedFontSize: 10,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const HomeView(),
            ),
                (route) => false,
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const EventsView(),
            ),
          );
        } else if (index == 2) {
          _showMessage(
            context,
            'Central de notificações em breve.',
          );
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event_note_outlined),
          label: 'Eventos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_none),
          label: 'Alertas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }

  static void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}