
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _key = 'animais_favoritos';

  Future<List<String>> carregarFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  Future<void> salvarFavoritos(List<String> favoritos) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, favoritos);
  }

  Future<bool> ehFavorito(String nomeAnimal) async {
    final favoritos = await carregarFavoritos();
    return favoritos.contains(nomeAnimal);
  }

  Future<void> alternarFavorito(String nomeAnimal) async {
    final favoritos = await carregarFavoritos();

    if (favoritos.contains(nomeAnimal)) {
      favoritos.remove(nomeAnimal);
    } else {
      favoritos.add(nomeAnimal);
    }

    await salvarFavoritos(favoritos);
  }
}
