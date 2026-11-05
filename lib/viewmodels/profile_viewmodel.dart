import 'package:flutter/material.dart';

class ProfileViewModel {
  // ---------- Dados do usuário ----------
  final String nomeUsuario = 'Mariana Silva';
  final String emailUsuario = 'mariana.silva@email.com';
  final bool adotanteVerificada = true;

  // ---------- Notificações ----------
  final List<Map<String, dynamic>> notificacoes = [
    {
      'icon': Icons.pets,
      'title': 'Novo Alerta de Filtro',
      'message': '2 novos cães de porte médio disponíveis perto de você.',
      'time': 'Há 2 horas',
    },
    {
      'icon': Icons.check_circle_outline,
      'title': 'Pedido Aprovado!',
      'message':
      'Seu pedido de adoção para Rex foi aprovado pela ONG Amigos Leais.',
      'time': 'Ontem',
    },
    {
      'icon': Icons.business,
      'title': 'Instituição Verificada',
      'message': 'A Casa dos Focinhos foi verificada.',
      'time': 'Há 2 dias',
    },
  ];

  int get quantidadeNotificacoes => notificacoes.length;
}