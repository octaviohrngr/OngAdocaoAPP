import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Botão contornado usado nos logins sociais (Google, Facebook).
class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.divider),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        icon: Icon(icon, size: 18, color: AppColors.textDark),
        label: Text(label, style: const TextStyle(color: AppColors.textDark, fontSize: 14)),
      ),
    );
  }
}
