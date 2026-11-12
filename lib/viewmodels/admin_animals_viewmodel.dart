
import 'package:flutter/material.dart';

import '../models/animal.dart';
import '../data/repository/animal_repository.dart';

class AdminAnimalsViewModel extends ChangeNotifier {
  final AnimalRepository _repository = AnimalRepository();

  List<Animal> animals = [];

  String busca = '';
  String filtroEspecie = 'Todos';

  bool carregando = false;
  String? erro;

  Future<void> carregarAnimais() async {
    carregando = true;
    erro = null;
    notifyListeners();

    try {
      animals = await _repository.buscarAnimais();
    } catch (e) {
      erro = 'Erro ao buscar animais: $e';
    }

    carregando = false;
    notifyListeners();
  }

  List<Animal> get animalsFiltrados {
    return animals.where((animal) {
      final correspondeNome = animal.nome
          .toLowerCase()
          .contains(busca.toLowerCase());

      final correspondeEspecie =
          filtroEspecie == 'Todos' ||
              animal.especie.toLowerCase() ==
                  filtroEspecie.toLowerCase();

      return correspondeNome && correspondeEspecie;
    }).toList();
  }

  void atualizarBusca(String valor) {
    busca = valor;
    notifyListeners();
  }

  void atualizarFiltroEspecie(String valor) {
    filtroEspecie = valor;
    notifyListeners();
  }

  Future<void> excluirAnimal(Animal animal) async {
    await _repository.excluirAnimal(animal.id);
    await carregarAnimais();
  }

  Future<void> editarAnimal(
      Animal animal,
      Map<String, dynamic> dados,
      ) async {
    await _repository.editarAnimal(animal.id, dados);
    await carregarAnimais();
  }
}
