
import 'package:flutter/material.dart';

import '../../models/formulario.dart';
import '../theme/app_colors.dart';

class SolicitacaoCard extends StatelessWidget {
  final Formulario formulario;
  final VoidCallback onTap;

  const SolicitacaoCard({
    super.key,
    required this.formulario,
    required this.onTap,
  });

  String get statusTexto {
    switch (formulario.status) {
      case 'em_analise':
        return 'Em análise';
      case 'finalizado_ok':
        return 'Aprovada';
      case 'negado':
        return 'Negada';
      default:
        return formulario.status;
    }
  }

  Color get statusCor {
    switch (formulario.status) {
      case 'finalizado_ok':
        return Colors.green;
      case 'negado':
        return Colors.red;
      default:
        return AppColors.primaryGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 65,
                  height: 65,
                  child: formulario.fotoAnimal.isNotEmpty
                      ? Image.network(
                    formulario.fotoAnimal,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return const Icon(
                        Icons.pets,
                        size: 36,
                        color: AppColors.primaryGreen,
                      );
                    },
                  )
                      : const Icon(
                    Icons.pets,
                    size: 36,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formulario.nomeAnimal.isEmpty
                          ? 'Animal não informado'
                          : formulario.nomeAnimal,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Adotante: ${formulario.nome}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textGray,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      statusTexto,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusCor,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.primaryGreen,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
