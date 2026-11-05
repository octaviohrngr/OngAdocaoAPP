
import 'package:flutter/material.dart';
import 'package:ong_adocao_app/models/evento.dart';
import 'package:ong_adocao_app/data/repository/evento_repository.dart';

class EventsViewModel extends ChangeNotifier {
  final EventoRepository _repository = EventoRepository();

  List<Evento> eventos = [];

  bool isLoading = false;
  String? mensagemErro;

  bool _disposed = false;

  static const List<String> _meses = [
    'JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN',
    'JUL', 'AGO', 'SET', 'OUT', 'NOV', 'DEZ',
  ];

  Future<void> carregarEventos() async {
    isLoading = true;
    mensagemErro = null;
    notifyListeners();

    try {
      eventos = await _repository.buscarEventos();
    } catch (e) {
      mensagemErro = 'Não foi possível carregar os eventos.';
      debugPrint('Erro ao buscar eventos: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

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
    final titulo = evento.titulo.toLowerCase();

    if (titulo.contains('encontro')) {
      return Icons.groups;
    }

    if (titulo.contains('arrecadação') ||
        titulo.contains('doação')) {
      return Icons.volunteer_activism;
    }

    return Icons.pets;
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
