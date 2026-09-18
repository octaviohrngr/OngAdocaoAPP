import 'package:flutter/services.dart';

/// Formata o telefone como (00) 0000-0000 ou (00) 00000-0000
/// enquanto o usuário digita, sem depender de pacotes externos.
class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return newValue.copyWith(text: '');

    final limited = digits.length > 11 ? digits.substring(0, 11) : digits;
    final buffer = StringBuffer();

    for (var i = 0; i < limited.length; i++) {
      if (i == 0) buffer.write('(');
      if (i == 2) buffer.write(') ');
      // Celular (11 dígitos) separa depois do 5º; fixo, depois do 4º.
      if ((limited.length == 11 && i == 7) || (limited.length <= 10 && i == 6)) {
        buffer.write('-');
      }
      buffer.write(limited[i]);
    }

    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
