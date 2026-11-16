
import '../network/requester.dart';

class AuthService {
  final Requester _requester = Requester();

  Future<dynamic> login({
    required String email,
    required String senha,
  }) async {
    return await _requester.post(
      '/auth/login',
      {
        'email': email,
        'senha': senha,
      },
    );
  }
}
