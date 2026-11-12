
import 'package:flutter/material.dart';

import '../models/evento.dart';
import '../data/repository/evento_repository.dart';

class AdminEventsViewModel extends ChangeNotifier {
  final EventoRepository _repository = EventoRepository();

  List<Evento> eventos = [];
  bool carregando = false;
  String? erro;
  String busca = '';

  List<Evento> get eventosFiltrados {
    final texto = busca.trim().toLowerCase();

    return eventos.where((evento) {
      return evento.titulo.toLowerCase().contains(texto) ||
          evento.localizacao.toLowerCase().contains(texto);
    }).toList();
  }

  void atualizarBusca(String valor) {
    busca = valor;
    notifyListeners();
  }

  Future<void> carregarEventos() async {
    carregando = true;
    erro = null;
    notifyListeners();

    try {
      eventos = await _repository.buscarEventos();
    } catch (e) {
      erro = e.toString().replaceFirst('Exception: ', '');
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<bool> excluirEvento(String id) async {
    try {
      await _repository.excluirEvento(id);
      await carregarEventos();
      return erro == null;
    } catch (e) {
      erro = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}
