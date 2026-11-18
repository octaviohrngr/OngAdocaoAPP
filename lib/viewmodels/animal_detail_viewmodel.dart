import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnimalDetailViewModel extends ChangeNotifier {
  bool jaSolicitou = false;

  Future<void> verificarSolicitacao(
      String animalId,
      String usuarioId,
      ) async {
    final prefs = await SharedPreferences.getInstance();

    jaSolicitou =
        prefs.getBool('adocao_${usuarioId}_$animalId') ?? false;

    notifyListeners();
  }

  Future<void> registrarSolicitacao(
      String animalId,
      String usuarioId,
      ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('adocao_${usuarioId}_$animalId', true);

    jaSolicitou = true;
    notifyListeners();
  }
}