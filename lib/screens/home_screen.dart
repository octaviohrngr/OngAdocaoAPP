import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'onboarding_screen.dart';

/// Destino após o login. Placeholder até a listagem de animais existir.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            Icon(Icons.pets, color: AppColors.primaryGreen, size: 20),
            SizedBox(width: 6),
            Text(
              'Atipattas',
              style: TextStyle(
                color: AppColors.primaryGreen,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Sair',
            icon: const Icon(Icons.logout, color: AppColors.textGray, size: 20),
            onPressed: () {
              // Limpa a pilha e volta ao início.
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.pets, size: 64, color: AppColors.accentGreen),
              SizedBox(height: 16),
              Text(
                'Login realizado!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Aqui entra a listagem de animais disponíveis para adoção.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.textGray, height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
