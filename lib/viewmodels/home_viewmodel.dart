
import 'package:flutter/material.dart';
import 'package:ong_adocao_app/models/animal.dart';
import 'package:ong_adocao_app/data/services/auth_session.dart';
import 'package:ong_adocao_app/data/services/favorites_service.dart';
import 'package:ong_adocao_app/data/repository/animal_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final FavoritesService _favoritesService = FavoritesService();
  final AnimalRepository _animalRepository = AnimalRepository();

  String selectedFilter = 'Tudo';
  String searchText = '';
  List<String> favoritos = [];

  List<Animal> animals = [];

  bool isLoading = false;
  String? mensagemErro;

  final List<String> filters = [
    'Tudo',
    'Cães',
    'Gatos',
    'Pequeno',
    'Grande',
  ];

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  bool get usuarioLogado => AuthSession.isLoggedIn;

  // Buscar os animais cadastrados na API
  Future<void> carregarAnimais() async {
    isLoading = true;
    mensagemErro = null;
    notifyListeners();

    try {
      animals = await _animalRepository.buscarAnimais();
    } catch (e) {
      mensagemErro = 'Não foi possível carregar os animais.';
      debugPrint('Erro ao buscar animais: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Filtrar animais recebidos da API
  List<Animal> get filteredAnimals {
    return animals.where((animal) {
      final texto = searchText.trim().toLowerCase();

      final matchesSearch =
          animal.nome.toLowerCase().contains(texto) ||
              animal.raca.toLowerCase().contains(texto);

      final especie = animal.especie.trim().toLowerCase();
      final porte = animal.porte.trim().toLowerCase();

      bool matchesFilter = false;

      if (selectedFilter == 'Tudo') {
        matchesFilter = true;
      } else if (selectedFilter == 'Cães') {
        matchesFilter =
            especie == 'cães' ||
                especie == 'cão' ||
                especie == 'cachorro' ||
                especie == 'cachorros';
      } else if (selectedFilter == 'Gatos') {
        matchesFilter =
            especie == 'gato' ||
                especie == 'gatos';
      } else if (selectedFilter == 'Pequeno') {
        matchesFilter = porte == 'pequeno';
      } else if (selectedFilter == 'Grande') {
        matchesFilter = porte == 'grande';
      }

      return matchesSearch && matchesFilter;
    }).toList();
  }

  // Idade em meses
  String formatarIdade(int meses) {
    if (meses < 12) {
      return meses == 1 ? '1 mês' : '$meses meses';
    }

    final anos = meses ~/ 12;

    return anos == 1 ? '1 ano' : '$anos anos';
  }

  bool isFavorito(String nomeAnimal) {
    return favoritos.contains(nomeAnimal);
  }

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
