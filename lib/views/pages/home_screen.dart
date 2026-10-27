
import 'package:flutter/material.dart';

import '../../services/auth_session.dart';
import '../../services/favorites_service.dart';
import '../theme/app_colors.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import 'login_screen.dart';
import 'animal_detail_screen.dart';
import 'events_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedFilter = 'Tudo';
  String _searchText = '';

  final FavoritesService _favoritesService = FavoritesService();
  List<String> _favoritos = [];

  final List<String> _filters = [
    'Tudo',
    'Cães',
    'Gatos',
    'Pequeno',
    'Grande',
  ];

  final List<_AnimalPreview> _animals = const [
    _AnimalPreview(
      name: 'Bento',
      breed: 'Golden',
      age: '3 meses',
      imageUrl:
      'https://images.unsplash.com/photo-1552053831-71594a27632d',
      type: 'Cães',
      size: 'Grande',
      gender: Icons.male,
    ),
    _AnimalPreview(
      name: 'Luna',
      breed: 'Gato',
      age: '2 anos',
      imageUrl:
      'https://images.unsplash.com/photo-1533738363-b7f9aef128ce',
      type: 'Gatos',
      size: 'Pequeno',
      gender: Icons.female,
    ),
    _AnimalPreview(
      name: 'Caramelo',
      breed: 'Vira-lata',
      age: '1 ano',
      imageUrl:
      'https://images.unsplash.com/photo-1544568100-847a948585b9',
      type: 'Cães',
      size: 'Grande',
      gender: Icons.male,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _carregarFavoritos();
  }

  Future<void> _carregarFavoritos() async {
    final favoritos = await _favoritesService.carregarFavoritos();

    if (!mounted) return;

    setState(() {
      _favoritos = favoritos;
    });
  }

  Future<void> _alternarFavorito(String nomeAnimal) async {
    await _favoritesService.alternarFavorito(nomeAnimal);

    final favoritos = await _favoritesService.carregarFavoritos();

    if (!mounted) return;

    setState(() {
      _favoritos = favoritos;
    });
  }

  List<_AnimalPreview> get _filteredAnimals {
    return _animals.where((animal) {
      final texto = _searchText.toLowerCase();

      final matchesSearch =
          animal.name.toLowerCase().contains(texto) ||
              animal.breed.toLowerCase().contains(texto);

      final matchesFilter = _selectedFilter == 'Tudo' ||
          animal.type == _selectedFilter ||
          animal.size == _selectedFilter;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _openAnimal(_AnimalPreview animal) {
    if (!AuthSession.isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AnimalDetailScreen(
          name: animal.name,
          breed: animal.breed,
          age: animal.age,
          imageUrl: animal.imageUrl,
        ),
      ),
    ).then((_) {
      _carregarFavoritos();
    });
  }

  void _navigate(int index) {
    if (index == 0) return;

    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const EventsScreen(),
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
          builder: (_) => const ProfileScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final animalsToShow = _filteredAnimals;

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
                  builder: (_) => const ProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
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
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                },
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
                padding:
                const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filters.length,
                separatorBuilder: (_, __) =>
                const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = filter == _selectedFilter;

                  return ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
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
                padding:
                const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: animalsToShow.length,
                itemBuilder: (context, index) {
                  final animal = animalsToShow[index];

                  return _AnimalCard(
                    animal: animal,
                    onTap: () => _openAnimal(animal),
                    isFavorite:
                    _favoritos.contains(animal.name),
                    onFavoriteTap: () =>
                        _alternarFavorito(animal.name),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 0,
        onTap: _navigate,
      ),
    );
  }
}

class _AnimalPreview {
  final String name;
  final String breed;
  final String age;
  final String imageUrl;
  final String type;
  final String size;
  final IconData gender;

  const _AnimalPreview({
    required this.name,
    required this.breed,
    required this.age,
    required this.imageUrl,
    required this.type,
    required this.size,
    required this.gender,
  });
}

class _AnimalCard extends StatelessWidget {
  final _AnimalPreview animal;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  const _AnimalCard({
    required this.animal,
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
                    animal.imageUrl,
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
                      backgroundColor:
                      Colors.white.withOpacity(0.9),
                    ),
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: isFavorite
                          ? Colors.red
                          : AppColors.primaryGreen,
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
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          animal.name,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${animal.breed} • ${animal.age}',
                          style: const TextStyle(
                            color: AppColors.textGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    animal.gender,
                    color: AppColors.primaryGreen,
                  ),
                  const SizedBox(width: 6),
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
