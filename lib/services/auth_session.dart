
class AuthSession {
  static bool isLoggedIn = false;

  static String? userRole;

  static bool get isAdmin => userRole == 'admin';

  static void logout() {
    isLoggedIn = false;
    userRole = null;
  }
}