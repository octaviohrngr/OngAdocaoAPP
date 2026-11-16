
import 'package:flutter/material.dart';

import '../../models/evento.dart';
import '../theme/app_colors.dart';

class EventCard extends StatelessWidget {
  final Evento evento;
  final String dataFormatada;
  final String horarioFormatado;
  final IconData iconeEvento;
  final VoidCallback onVerDetalhes;

  const EventCard({
    super.key,
    required this.evento,
    required this.dataFormatada,
    required this.horarioFormatado,
    required this.iconeEvento,
    required this.onVerDetalhes,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 125,
            width: double.infinity,
            color: AppColors.onboardingHero,
            child: evento.foto.isNotEmpty
                ? Image.network(
              evento.foto,
              width: double.infinity,
              height: 125,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  iconeEvento,
                  size: 58,
                  color: AppColors.accentGreen,
                );
              },
            )
                : Icon(
              iconeEvento,
              size: 58,
              color: AppColors.accentGreen,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.inputFill,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    dataFormatada,
                    style: const TextStyle(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  evento.titulo,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                _eventInfo(
                  Icons.access_time,
                  horarioFormatado,
                ),
                const SizedBox(height: 7),
                _eventInfo(
                  Icons.location_on_outlined,
                  evento.localizacao,
                ),
                const SizedBox(height: 12),
                Text(
                  evento.descricao,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: AppColors.textGray,
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: onVerDetalhes,
                    child: const Text('Ver detalhes'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _eventInfo(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 17,
          color: AppColors.accentGreen,
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textGray,
            ),
          ),
        ),
      ],
    );
  }
}
