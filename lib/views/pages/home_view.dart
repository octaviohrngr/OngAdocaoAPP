
import 'package:flutter/material.dart';

import '../../models/animal.dart';
import '../../viewmodels/home_viewmodel.dart';

import '../theme/app_colors.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/animal_card.dart';
import 'notificacoes_view.dart';
import 'login_view.dart';
import 'animal_detail_screen.dart';
import 'profile_screen.dart';
import 'events_view.dart';

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

    viewModel.carregarAnimais();
    viewModel.carregarFavoritos();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }


  void _openAnimal(Animal animal) {
    if (animal.status == 'adotado') {
      return;
    }

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
          animal: animal,
        ),
      ),
    ).then((_) async {
      if (!mounted) return;

      // Atualiza os animais com os dados mais recentes da API.
      await viewModel.carregarAnimais();

      if (!mounted) return;

      // Mantém a atualização dos favoritos.
      await viewModel.carregarFavoritos();
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
      if (!viewModel.usuarioLogado) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const NotificacoesView(),
          ),
        ).then((_) {
          if (mounted) {
            viewModel.carregarQuantidadeNotificacoes();
          }
        });
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const NotificacoesView(),
        ),
      );
    } else if (index == 3 && viewModel.usuarioLogado) {
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
            tooltip: viewModel.usuarioLogado
                ? 'Meu perfil'
                : 'Fazer login',
            icon: const Icon(
              Icons.person_outline,
              color: AppColors.primaryGreen,
            ),
            onPressed: () {
              if (viewModel.usuarioLogado) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfileView(),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginView(),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    itemCount: viewModel.filters.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final filter = viewModel.filters[index];
                      final isSelected =
                          filter == viewModel.selectedFilter;

                      return ChoiceChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (_) =>
                            viewModel.atualizarFiltro(filter),
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
                          style: const TextStyle(
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed:
                          viewModel.carregarAnimais,
                          child: const Text(
                            'Tentar novamente',
                          ),
                        ),
                      ],
                    ),
                  )
                      : animalsToShow.isEmpty
                      ? const Center(
                    child: Text(
                      'Nenhum animal encontrado.',
                    ),
                  )
                      : ListView.builder(
                    padding:
                    const EdgeInsets.fromLTRB(
                      16,
                      0,
                      16,
                      16,
                    ),
                    itemCount: animalsToShow.length,
                    itemBuilder: (context, index) {
                      final animal =
                      animalsToShow[index];

                      return AnimalCard(
                        animal: animal,
                        idade: viewModel.formatarIdade(
                          animal.idadeEstimada,
                        ),
                        onTap: () =>
                            _openAnimal(animal),
                        isFavorite:
                        viewModel.isFavorito(
                          animal.nome,
                        ),
                        onFavoriteTap: () =>
                            viewModel.alternarFavorito(
                              animal.nome,
                            ),
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
        usuarioLogado: viewModel.usuarioLogado,
      ),
    );
  }
}
