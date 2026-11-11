
import 'package:flutter/material.dart';
import '../data/repository/user_repository.dart';
import '../models/usuario.dart';
import '../data/services/auth_session.dart';
import '../data/services/favorites_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final FavoritesService _favoritesService = FavoritesService();

  Usuario? get usuario => AuthSession.usuario;

  String get nomeUsuario => usuario?.nome ?? 'Usuário';
  String get emailUsuario => usuario?.email ?? '';
  String get telefoneUsuario => usuario?.telefone ?? '';
  String get tipoUsuario => usuario?.tipo ?? '';

  List<String> _favoritos = [];

  List<String> get favoritos => List.unmodifiable(_favoritos);

  bool _carregando = false;
  bool get carregando => _carregando;

  Future<void> carregarFavoritos() async {
    _carregando = true;
    notifyListeners();

    try {
      _favoritos = await _favoritesService.carregarFavoritos();
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  Future<void> removerFavorito(String nomeAnimal) async {
    await _favoritesService.alternarFavorito(nomeAnimal);
    await carregarFavoritos();
  }

  void atualizarUsuarioLocal(Usuario usuarioAtualizado) {
    AuthSession.usuario = usuarioAtualizado;
    notifyListeners();
  }

  void sairDaConta() {
    AuthSession.limpar();
    notifyListeners();
  }

  final UserRepository _userRepository = UserRepository();

  bool _salvando = false;
  bool get salvando => _salvando;

  String? _erro;
  String? get erro => _erro;

  Future<bool> atualizarPerfil({
    required String nome,
    required String email,
    required String telefone,
  }) async {
    final usuarioAtual = AuthSession.usuario;

    if (usuarioAtual == null) {
      _erro = 'Usuário não autenticado.';
      notifyListeners();
      return false;
    }

    _salvando = true;
    _erro = null;
    notifyListeners();

    try {
      final usuarioAtualizado =
      await _userRepository.atualizarUsuario(
        id: usuarioAtual.id,
        nome: nome.trim(),
        email: email.trim(),
        telefone: telefone.trim(),
      );

      AuthSession.usuario = usuarioAtualizado;

      notifyListeners();
      return true;
    } catch (e) {
      _erro = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _salvando = false;
      notifyListeners();
    }
  }
}
