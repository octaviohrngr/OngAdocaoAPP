
import 'package:flutter/material.dart';

import '../../models/evento.dart';
import '../theme/app_colors.dart';

class EventDetailsSheet extends StatelessWidget {
  final Evento evento;
  final String dataFormatada;
  final String horarioFormatado;
  final VoidCallback onTenhoInteresse;

  const EventDetailsSheet({
    super.key,
    required this.evento,
    required this.dataFormatada,
    required this.horarioFormatado,
    required this.onTenhoInteresse,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              evento.titulo,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 16),
            Text('Data: $dataFormatada'),
            Text('Horário: $horarioFormatado'),
            Text('Local: ${evento.localizacao}'),
            const SizedBox(height: 12),
            Text(evento.descricao),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                ),
                onPressed: onTenhoInteresse,
                child: const Text(
                  'Voltar para Home',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
