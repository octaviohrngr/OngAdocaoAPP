import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/page_dots.dart';
import '../widgets/primary_button.dart';
import 'login_screen.dart';

/// Tela 1: boas-vindas / onboarding.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  void _goToLogin(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.onboardingHero,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(28),
                        bottomRight: Radius.circular(28),
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.pets, size: 80, color: AppColors.accentGreen),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: TextButton(
                      onPressed: () => _goToLogin(context),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.85),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      ),
                      child: const Text(
                        'Pular',
                        style: TextStyle(color: AppColors.textDark, fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                        children: [
                          TextSpan(text: 'Bem-vindo ao '),
                          TextSpan(
                            text: 'Atipattas',
                            style: TextStyle(color: AppColors.accentGreen),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Encontre seu novo melhor amigo em Atibaia. '
                      'Conectamos você com animais locais em busca de um lar amoroso.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: AppColors.textGray, height: 1.4),
                    ),
                    const SizedBox(height: 20),
                    const PageDots(count: 3, currentIndex: 0),
                    const SizedBox(height: 28),
                    PrimaryButton(
                      label: 'Entrar',
                      onPressed: () => _goToLogin(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
