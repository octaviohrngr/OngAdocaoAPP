import 'package:flutter/material.dart';

import '../../models/animal.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../theme/app_colors.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import 'login_view.dart';
import 'animal_detail_screen.dart';
import 'events_view.dart';
import 'profile_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeViewModel viewModel = HomeViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.carregarFavoritos();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  void _openAnimal(Animal animal) {
    if (!viewModel.usuarioLogado) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginView(),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AnimalDetailScreen(
          name: animal.nome,
          breed: animal.raca,
          age: viewModel.formatarIdade(animal.idadeEstimada),
          imageUrl: animal.foto1,
        ),
      ),
    ).then((_) {
      viewModel.carregarFavoritos();
    });
  }

  void _navigate(int index) {
    if (index == 0) return;

    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const EventsView(),
        ),
      );
    } else if (index == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Central de alertas em breve.'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Icon(
              Icons.pets,
              color: AppColors.primaryGreen,
            ),
            const SizedBox(width: 8),
            const Text(
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
            tooltip: 'Meu perfil',
            icon: const Icon(
              Icons.person_outline,
              color: AppColors.primaryGreen,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileView(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        // Reconstrói a tela quando o ViewModel avisar que algo mudou
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            final animalsToShow = viewModel.filteredAnimals;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
                  child: Text(
                    'Encontre seu novo\nmelhor amigo',
                    style: TextStyle(
                      fontSize: 25,
                      height: 1.2,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    onChanged: viewModel.atualizarBusca,
                    decoration: InputDecoration(
                      hintText: 'Buscar animais...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: viewModel.filters.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final filter = viewModel.filters[index];
                      final isSelected = filter == viewModel.selectedFilter;

                      return ChoiceChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (_) => viewModel.atualizarFiltro(filter),
                        selectedColor: AppColors.primaryGreen,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textDark,
                          fontWeight: FontWeight.w600,
                        ),
                        side: BorderSide.none,
                      );
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 18, 16, 10),
                  child: Text(
                    'Animais disponíveis',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                Expanded(
                  child: animalsToShow.isEmpty
                      ? const Center(
                    child: Text('Nenhum animal encontrado.'),
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: animalsToShow.length,
                    itemBuilder: (context, index) {
                      final animal = animalsToShow[index];

                      return _AnimalCard(
                        animal: animal,
                        idade: viewModel.formatarIdade(animal.idadeEstimada),
                        onTap: () => _openAnimal(animal),
                        isFavorite: viewModel.isFavorito(animal.nome),
                        onFavoriteTap: () =>
                            viewModel.alternarFavorito(animal.nome),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 0,
        onTap: _navigate,
      ),
    );
  }
}

class _AnimalCard extends StatelessWidget {
  final Animal animal;
  final String idade;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  const _AnimalCard({
    required this.animal,
    required this.idade,
    required this.onTap,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    animal.foto1,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.inputFill,
                      child: const Icon(
                        Icons.pets,
                        size: 45,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Disponível',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    tooltip: isFavorite
                        ? 'Remover dos favoritos'
                        : 'Adicionar aos favoritos',
                    onPressed: onFavoriteTap,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.9),
                    ),
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : AppColors.primaryGreen,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          animal.nome,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${animal.raca} • $idade',
                          style: const TextStyle(
                            color: AppColors.textGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.textGray,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}