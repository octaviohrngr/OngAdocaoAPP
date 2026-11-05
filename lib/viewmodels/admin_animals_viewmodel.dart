import 'package:flutter/material.dart';

class AdminAnimalsViewModel extends ChangeNotifier {
  final List<Map<String, String>> animals = [
    {
      'nome': 'Bolinha',
      'especie': 'Cão',
      'sexo': 'Macho',
      'porte': 'Médio',
      'status': 'Disponível',
      'foto':
      'https://images.unsplash.com/photo-1552053831-71594a27632d?w=800',
    },
    {
      'nome': 'Luna',
      'especie': 'Gato',
      'sexo': 'Fêmea',
      'porte': 'Pequeno',
      'status': 'Em Processo',
      'foto':
      'https://images.unsplash.com/photo-1513360371669-4adf3dd7dff8?w=800',
    },
    {
      'nome': 'Rex',
      'especie': 'Cão',
      'sexo': 'Macho',
      'porte': 'Grande',
      'status': 'Adotado',
      'foto':
      'https://images.unsplash.com/photo-1551717743-49959800b1f6?w=800',
    },
    {
      'nome': 'Mia',
      'especie': 'Gato',
      'sexo': 'Fêmea',
      'porte': 'Pequeno',
      'status': 'Disponível',
      'foto':
      'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=800',
    },
  ];

  String busca = '';
  String filtroEspecie = 'Todos';
  String filtroStatus = 'Todos';

  List<Map<String, String>> get animalsFiltrados {
    return animals.where((animal) {
      final nome = animal['nome']!.toLowerCase();
      final correspondeNome = nome.contains(busca.toLowerCase());

      final correspondeEspecie =
          filtroEspecie == 'Todos' || animal['especie'] == filtroEspecie;

      final correspondeStatus =
          filtroStatus == 'Todos' || animal['status'] == filtroStatus;

      return correspondeNome && correspondeEspecie && correspondeStatus;
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

  void atualizarFiltroStatus(String valor) {
    filtroStatus = valor;
    notifyListeners();
  }

  // Se animalAtual for null, cadastra novo. Senão, edita.
  void salvarAnimal(
      Map<String, String>? animalAtual,
      Map<String, String> dados,
      ) {
    if (animalAtual == null) {
      animals.insert(0, dados);
    } else {
      final indice = animals.indexOf(animalAtual);
      if (indice != -1) {
        animals[indice] = dados;
      }
    }
    notifyListeners();
  }

  void excluirAnimal(Map<String, String> animal) {
    animals.remove(animal);
    notifyListeners();
  }
}