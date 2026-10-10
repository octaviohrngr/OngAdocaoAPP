
import 'package:flutter/material.dart';

import '../../services/auth_session.dart';
import 'login_screen.dart';
import 'animal_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedFilter = 'Tudo';
  String _searchText = '';

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
      available: true,
      gender: Icons.male,
      type: 'Cães',
      size: 'Grande',
    ),
    _AnimalPreview(
      name: 'Luna',
      breed: 'Gato',
      age: '2 anos',
      imageUrl:
      'https://images.unsplash.com/photo-1533738363-b7f9aef128ce',
      available: true,
      gender: Icons.female,
      type: 'Gatos',
      size: 'Pequeno',
    ),
    _AnimalPreview(
      name: 'Caramelo',
      breed: 'Vira-lata',
      age: '1 ano',
      imageUrl:
      'https://images.unsplash.com/photo-1544568100-847a948585b9',
      available: true,
      gender: Icons.male,
      type: 'Cães',
      size: 'Grande',
    ),
  ];

  static const Color _primaryGreen = Color(0xFF3BAA57);

  List<_AnimalPreview> get _filteredAnimals {
    return _animals.where((animal) {
      final matchesSearch =
          animal.name.toLowerCase().contains(_searchText.toLowerCase()) ||
              animal.breed.toLowerCase().contains(_searchText.toLowerCase());

      final matchesFilter = _selectedFilter == 'Tudo' ||
          animal.type == _selectedFilter ||
          animal.size == _selectedFilter;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _openAnimal(_AnimalPreview animal) {
    if (!AuthSession.isLoggedIn) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AnimalDetailScreen(
          name: animal.name,
          breed: animal.breed,
          age: animal.age,
          imageUrl: animal.imageUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final animalsToShow = _filteredAnimals;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: const [
            Icon(Icons.pets, color: _primaryGreen),
            SizedBox(width: 8),
            Text(
              'Atipattas',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 14,
              backgroundImage: NetworkImage('https://i.pravatar.cc/100'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Encontre seu novo\nmelhor amigo',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                onChanged: (value) {
                  setState(() => _searchText = value);
                },
                decoration: InputDecoration(
                  hintText: 'Buscar animais...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                    BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                    BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      setState(() => _selectedFilter = filter);
                    },
                    selectedColor: _primaryGreen,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: StadiumBorder(
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: _primaryGreen,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _AnimalPreview {
  final String name;
  final String breed;
  final String age;
  final String imageUrl;
  final bool available;
  final IconData gender;
  final String type;
  final String size;

  const _AnimalPreview({
    required this.name,
    required this.breed,
    required this.age,
    required this.imageUrl,
    required this.available,
    required this.gender,
    required this.type,
    required this.size,
  });
}

class _AnimalCard extends StatelessWidget {
  final _AnimalPreview animal;
  final VoidCallback onTap;

  const _AnimalCard({
    required this.animal,
    required this.onTap,
  });

  static const Color _primaryGreen = Color(0xFF3BAA57);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Image.network(
                    animal.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.pets, size: 40),
                    ),
                  ),
                ),
                if (animal.available)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _primaryGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 8,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Disponível',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        animal.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        animal.breed,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        animal.age,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Icon(animal.gender, color: Colors.grey[500]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
