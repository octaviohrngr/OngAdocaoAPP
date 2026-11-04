import 'package:ong_adocao_app/models/usuario.dart';


class AuthSession {
  static bool isLoggedIn = false;
  static String? userRole;
  static String? token; // JWT devolvido pela API
  static Usuario? usuario;

  static void limpar() {
    isLoggedIn = false;
    userRole = null;
    token = null;
    usuario = null;
  }
}