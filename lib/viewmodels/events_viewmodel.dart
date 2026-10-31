import 'package:flutter/material.dart';
import 'package:ong_adocao_app/models/evento.dart';

class EventsViewModel {
  final List<Evento> eventos = [
    Evento(
      id: '1',
      titulo: 'Feira de Adoção Atipattas',
      dataHora: DateTime(2026, 10, 18, 9, 0),
      localizacao: 'Praça da Matriz, Atibaia',
      descricao:
      'Conheça cães e gatos que estão esperando por uma família. '
          'Converse com os voluntários e descubra como adotar.',
    ),
    Evento(
      id: '2',
      titulo: 'Encontro de Tutores',
      dataHora: DateTime(2026, 10, 24, 14, 0),
      localizacao: 'Parque Edmundo Zanoni, Atibaia',
      descricao:
      'Uma tarde para tutores, famílias e seus animais se encontrarem '
          'e compartilharem experiências.',
    ),
    Evento(
      id: '3',
      titulo: 'Campanha de Arrecadação',
      dataHora: DateTime(2026, 10, 31, 10, 0),
      localizacao: 'Centro de Atibaia',
      descricao:
      'Ajude os animais acolhidos doando ração, cobertores e produtos '
          'de higiene.',
    ),
  ];

  static const List<String> _meses = [
    'JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN',
    'JUL', 'AGO', 'SET', 'OUT', 'NOV', 'DEZ',
  ];


  String formatarData(DateTime dataHora) {
    final dia = dataHora.day.toString().padLeft(2, '0');
    return '$dia ${_meses[dataHora.month - 1]} ${dataHora.year}';
  }


  String formatarHorario(DateTime dataHora) {
    final hora = dataHora.hour.toString().padLeft(2, '0');
    final minuto = dataHora.minute.toString().padLeft(2, '0');
    return '$hora:$minuto';
  }


  IconData iconeEvento(Evento evento) {
    switch (evento.id) {
      case '2':
        return Icons.groups;
      case '3':
        return Icons.volunteer_activism;
      default:
        return Icons.pets;
    }
  }
}