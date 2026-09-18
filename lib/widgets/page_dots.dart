import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Indicador de páginas do onboarding.
class PageDots extends StatelessWidget {
  const PageDots({super.key, required this.count, required this.currentIndex});

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) => _Dot(active: index == currentIndex)),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: active ? 18 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: active ? AppColors.primaryGreen : AppColors.divider,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
