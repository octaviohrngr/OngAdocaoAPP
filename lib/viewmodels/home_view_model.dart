import 'package:flutter/material.dart';
import '../models/animal.dart';

class HomeViewModel extends ChangeNotifier {
  bool isLoading = false;

  List<Animal> animais = [
    Animal(
      id: '1',
      nome: 'Bento',
      especie: 'cachorro',
      raca: 'Vira-lata',
      idadeEstimada: 2,
      porte: 'médio',
      foto1:
      'https://images.unsplash.com/photo-1552053831-71594a27632d',
      foto2:
      'https://images.unsplash.com/photo-1558788353-f76d92427f16',
      temperamento: 'Dócil e brincalhão',
      historicoVacina: 'Vacinas em dia',
    ),
    Animal(
      id: '2',
      nome: 'Luna',
      especie: 'gato',
      raca: 'SRD',
      idadeEstimada: 1,
      porte: 'pequeno',
      foto1:
      'https://images.unsplash.com/photo-1518791841217-8f162f1e1131',
      foto2:
      'https://images.unsplash.com/photo-1573865526739-10659fec78a5',
      temperamento: 'Carinhosa e tranquila',
      historicoVacina: 'Vacinas em dia',
    ),
  ];

  void carregarAnimais() {
    isLoading = true;
    notifyListeners();

    // Por enquanto usamos os dados mockados.

    isLoading = false;
    notifyListeners();
  }
}