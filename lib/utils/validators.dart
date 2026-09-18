/// Validadores reutilizáveis dos formulários.
///
/// Todos retornam `null` quando o valor é válido — contrato esperado
/// pelo `validator` do [TextFormField].
class Validators {
  Validators._();

  static final RegExp _emailRegExp = RegExp(
    r'^[\w.+-]+@[\w-]+\.[\w.-]+$',
  );

  static String? required(String? value, {String message = 'Campo obrigatório'}) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static String? email(String? value) {
    final empty = required(value, message: 'Informe seu e-mail');
    if (empty != null) return empty;
    if (!_emailRegExp.hasMatch(value!.trim())) return 'E-mail inválido';
    return null;
  }

  static String? password(String? value, {int minLength = 6}) {
    final empty = required(value, message: 'Informe sua senha');
    if (empty != null) return empty;
    if (value!.length < minLength) {
      return 'A senha deve ter pelo menos $minLength caracteres';
    }
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    final empty = required(value, message: 'Confirme sua senha');
    if (empty != null) return empty;
    if (value != original) return 'As senhas não coincidem';
    return null;
  }

  static String? fullName(String? value) {
    final empty = required(value, message: 'Informe seu nome');
    if (empty != null) return empty;
    final parts = value!.trim().split(RegExp(r'\s+'));
    if (parts.length < 2 || parts[1].isEmpty) return 'Informe nome e sobrenome';
    return null;
  }

  /// Aceita telefone brasileiro com 10 (fixo) ou 11 (celular) dígitos.
  static String? phone(String? value) {
    final empty = required(value, message: 'Informe seu telefone');
    if (empty != null) return empty;
    final digits = value!.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10 || digits.length > 11) return 'Telefone inválido';
    return null;
  }
}
