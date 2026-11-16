
import 'package:flutter/material.dart';

import '../../models/animal.dart';
import '../theme/app_colors.dart';

class AnimalCard extends StatelessWidget {
  final Animal animal;
  final String idade;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  String get textoStatus {
    switch (animal.status) {
      case 'em_processo':
        return 'Em Processo';
      case 'adotado':
        return 'Adotado';
      default:
        return 'Disponível';
    }
  }

  Color get corStatus {
    switch (animal.status) {
      case 'em_processo':
        return Colors.amber.shade700;
      case 'adotado':
        return Colors.grey;
      default:
        return AppColors.primaryGreen;
    }
  }

  const AnimalCard({
    super.key,
    required this.animal,
    required this.idade,
    required this.onTap,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [

                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: PageView(
                    children: [
                      Image.network(
                        animal.foto1,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.inputFill,
                          child: const Icon(Icons.pets, size: 45),
                        ),
                      ),
                      Image.network(
                        animal.foto2,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.inputFill,
                          child: const Icon(Icons.pets, size: 45),
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: corStatus,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      textoStatus,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    tooltip: isFavorite
                        ? 'Remover dos favoritos'
                        : 'Adicionar aos favoritos',
                    onPressed: onFavoriteTap,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.9),
                    ),
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: isFavorite
                          ? Colors.red
                          : AppColors.primaryGreen,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          animal.nome,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${animal.raca} • $idade',
                          style: const TextStyle(
                            color: AppColors.textGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.textGray,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
