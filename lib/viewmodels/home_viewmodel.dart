import 'package:flutter/material.dart';
import 'package:ong_adocao_app/models/animal.dart';
import 'package:ong_adocao_app/services/auth_session.dart';
import 'package:ong_adocao_app/services/favorites_service.dart';

class HomeViewModel extends ChangeNotifier {
  final FavoritesService _favoritesService = FavoritesService();

  String selectedFilter = 'Tudo';
  String searchText = '';
  List<String> favoritos = [];

  final List<String> filters = [
    'Tudo',
    'Cães',
    'Gatos',
    'Pequeno',
    'Grande',
  ];

  final List<Animal> animals = const [
    Animal(
      id: '1',
      nome: 'Bento',
      especie: 'Cães',
      raca: 'Golden',
      idadeEstimada: 3,
      porte: 'Grande',
      foto1: 'https://images.unsplash.com/photo-1552053831-71594a27632d',
      foto2: '',
      temperamento: '',
      historicoVacina: '',
    ),
    Animal(
      id: '2',
      nome: 'Luna',
      especie: 'Gatos',
      raca: 'Gato',
      idadeEstimada: 24,
      porte: 'Pequeno',
      foto1: 'https://images.unsplash.com/photo-1533738363-b7f9aef128ce',
      foto2: '',
      temperamento: '',
      historicoVacina: '',
    ),
    Animal(
      id: '3',
      nome: 'Caramelo',
      especie: 'Cães',
      raca: 'Vira-lata',
      idadeEstimada: 12,
      porte: 'Grande',
      foto1: 'https://images.unsplash.com/photo-1544568100-847a948585b9',
      foto2: '',
      temperamento: '',
      historicoVacina: '',
    ),
  ];

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  // Evita erro se a tela for fechada antes de uma operação assíncrona terminar
  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  bool get usuarioLogado => AuthSession.isLoggedIn;

  List<Animal> get filteredAnimals {
    return animals.where((animal) {
      final texto = searchText.toLowerCase();

      final matchesSearch =
          animal.nome.toLowerCase().contains(texto) ||
              animal.raca.toLowerCase().contains(texto);

      final matchesFilter = selectedFilter == 'Tudo' ||
          animal.especie == selectedFilter ||
          animal.porte == selectedFilter;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  // idadeEstimada em meses: menos de 12 mostra meses, senão anos
  String formatarIdade(int meses) {
    if (meses < 12) {
      return meses == 1 ? '1 mês' : '$meses meses';
    }
    final anos = meses ~/ 12;
    return anos == 1 ? '1 ano' : '$anos anos';
  }

  bool isFavorito(String nomeAnimal) => favoritos.contains(nomeAnimal);

  void atualizarBusca(String valor) {
    searchText = valor;
    notifyListeners();
  }

  void atualizarFiltro(String valor) {
    selectedFilter = valor;
    notifyListeners();
  }

  Future<void> carregarFavoritos() async {
    favoritos = await _favoritesService.carregarFavoritos();
    notifyListeners();
  }

  Future<void> alternarFavorito(String nomeAnimal) async {
    await _favoritesService.alternarFavorito(nomeAnimal);
    await carregarFavoritos();
  }
}