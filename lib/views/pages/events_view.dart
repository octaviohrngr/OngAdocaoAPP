
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'adoption_form_screen.dart';
import 'home_view.dart';
import 'profile_screen.dart';

class EventsView extends StatelessWidget {
  const EventsView({super.key});

  static const List<Map<String, String>> events = [
    {
      'title': 'Feira de Adoção Atipattas',
      'date': '18 OUT 2026',
      'time': '09:00 às 15:00',
      'location': 'Praça da Matriz, Atibaia',
      'description':
      'Conheça cães e gatos que estão esperando por uma família. '
          'Converse com os voluntários e descubra como adotar.',
      'icon': 'pets',
    },
    {
      'title': 'Encontro de Tutores',
      'date': '24 OUT 2026',
      'time': '14:00 às 17:00',
      'location': 'Parque Edmundo Zanoni, Atibaia',
      'description':
      'Uma tarde para tutores, famílias e seus animais se encontrarem '
          'e compartilharem experiências.',
      'icon': 'groups',
    },
    {
      'title': 'Campanha de Arrecadação',
      'date': '31 OUT 2026',
      'time': '10:00 às 16:00',
      'location': 'Centro de Atibaia',
      'description':
      'Ajude os animais acolhidos doando ração, cobertores e produtos '
          'de higiene.',
      'icon': 'volunteer',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primaryGreen,
        title: const Text(
          'Eventos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Encontre seu próximo evento',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Participe das ações e ajude os animais da nossa região.',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textGray,
            ),
          ),
          const SizedBox(height: 20),
          ...events.map(
                (event) => _eventCard(context, event),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.cardBackground,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: AppColors.textGray,
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

          } else if (index == 2) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Central de notificações em breve.'),
              ),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const ProfileView(),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note_outlined),
            activeIcon: Icon(Icons.event_note),
            label: 'Eventos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            activeIcon: Icon(Icons.notifications),
            label: 'Alertas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),

    );
  }

  Widget _eventCard(
      BuildContext context,
      Map<String, String> event,
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
            child: Icon(
              _eventIcon(event['icon']!),
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
                    event['date']!,
                    style: const TextStyle(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  event['title']!,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                _eventInfo(Icons.access_time, event['time']!),
                const SizedBox(height: 7),
                _eventInfo(Icons.location_on_outlined, event['location']!),
                const SizedBox(height: 12),
                Text(
                  event['description']!,
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
                    onPressed: () => _showDetails(context, event),
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
        Icon(icon, size: 17, color: AppColors.accentGreen),
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

  IconData _eventIcon(String icon) {
    switch (icon) {
      case 'groups':
        return Icons.groups;
      case 'volunteer':
        return Icons.volunteer_activism;
      default:
        return Icons.pets;
    }
  }

  void _showDetails(
      BuildContext context,
      Map<String, String> event,
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
                  event['title']!,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 16),
                Text('Data: ${event['date']}'),
                Text('Horário: ${event['time']}'),
                Text('Local: ${event['location']}'),
                const SizedBox(height: 12),
                Text(event['description']!),
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
                          builder: (_) => const AdoptionFormScreen(),
                        ),
                      );
                    },
                    child: const Text('Tenho interesse em adotar'),
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
