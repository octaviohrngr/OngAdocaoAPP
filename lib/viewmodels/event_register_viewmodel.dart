
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/evento.dart';
import '../data/repository/evento_repository.dart';

class EventRegisterViewModel extends ChangeNotifier {
  final EventoRepository _repository = EventoRepository();
  final ImagePicker _picker = ImagePicker();

  final tituloController = TextEditingController();
  final localizacaoController = TextEditingController();
  final descricaoController = TextEditingController();

  DateTime? dataHora;
  XFile? foto;
  String fotoAtual = '';

  bool enviando = false;
  String? erro;

  EventRegisterViewModel({Evento? evento}) {
    if (evento != null) {
      tituloController.text = evento.titulo;
      localizacaoController.text = evento.localizacao;
      descricaoController.text = evento.descricao;
      dataHora = evento.dataHora.toLocal();
      fotoAtual = evento.foto;
    }
  }

  void selecionarDataHora(DateTime valor) {
    dataHora = valor;
    notifyListeners();
  }

  Future<void> selecionarFoto() async {
    try {
      final imagem = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (imagem != null) {
        foto = imagem;
        erro = null;
        notifyListeners();
      }
    } catch (e) {
      erro = 'Não foi possível selecionar a imagem.';
      notifyListeners();
    }
  }

  void removerFoto() {
    foto = null;
    notifyListeners();
  }

  bool validarCadastro() {
    if (tituloController.text.trim().isEmpty ||
        localizacaoController.text.trim().isEmpty ||
        descricaoController.text.trim().isEmpty ||
        dataHora == null) {
      erro = 'Preencha todos os campos obrigatórios.';
      notifyListeners();
      return false;
    }

    erro = null;
    notifyListeners();
    return true;
  }

  Future<bool> salvarEvento({String? id}) async {
    if (!validarCadastro()) return false;

    enviando = true;
    erro = null;
    notifyListeners();

    try {
      final dados = <String, dynamic>{
        'titulo': tituloController.text.trim(),
        'dataHora': dataHora!.toUtc().toIso8601String(),
        'localizacao': localizacaoController.text.trim(),
        'descricao': descricaoController.text.trim(),
      };

      final bytes = await foto?.readAsBytes();

      if (id == null) {
        await _repository.cadastrarEvento(
          dados,
          foto: bytes,
          nomeFoto: foto?.name,
        );
      } else {
        await _repository.editarEvento(
          id,
          dados,
          foto: bytes,
          nomeFoto: foto?.name,
        );
      }

      return true;
    } catch (e) {
      erro = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      enviando = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    tituloController.dispose();
    localizacaoController.dispose();
    descricaoController.dispose();
    super.dispose();
  }
}
