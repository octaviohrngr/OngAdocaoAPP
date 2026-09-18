import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

/// Campo de texto padrão do app.
///
/// Usa [TextFormField], então funciona dentro de um [Form] e exibe a
/// mensagem de erro retornada pelo [validator] logo abaixo do campo.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffix,
    this.keyboardType,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
    this.focusNode,
    this.inputFormatters,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;

  OutlineInputBorder _border({Color? color}) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: color == null
            ? BorderSide.none
            : BorderSide(color: color, width: 1.2),
      );

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      inputFormatters: inputFormatters,
      enabled: enabled,
      // Revalida a cada digitação, mas só depois da primeira tentativa de envio.
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(color: AppColors.textDark),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.inputFill,
        prefixIcon: Icon(icon, color: AppColors.textGray, size: 20),
        suffixIcon: suffix,
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textGray, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        border: _border(),
        enabledBorder: _border(),
        disabledBorder: _border(),
        focusedBorder: _border(color: AppColors.accentGreen),
        errorBorder: _border(color: errorColor),
        focusedErrorBorder: _border(color: errorColor),
        errorStyle: TextStyle(color: errorColor, fontSize: 12),
      ),
    );
  }
}

/// Rótulo usado acima dos campos de formulário.
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key, this.bold = true});

  final String text;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
          color: AppColors.textDark,
        ),
      ),
    );
  }
}

/// Botão que alterna a visibilidade da senha.
class PasswordToggle extends StatelessWidget {
  const PasswordToggle({super.key, required this.obscured, required this.onPressed});

  final bool obscured;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        size: 20,
        color: AppColors.textGray,
      ),
      tooltip: obscured ? 'Mostrar senha' : 'Ocultar senha',
      onPressed: onPressed,
    );
  }
}
