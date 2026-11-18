
import 'package:flutter/material.dart';

import '../models/animal.dart';
import '../data/repository/animal_repository.dart';
import '../data/repository/formulario_repository.dart';
import '../data/services/formulario_pdf_service.dart';

class DetalhesSolicitacaoViewModel extends ChangeNotifier {
  final FormularioRepository _formularioRepository =
  FormularioRepository();

  final AnimalRepository _animalRepository =
  AnimalRepository();

  Map<String, dynamic>? _formulario;
  bool _carregando = false;
  bool _buscandoAnimal = false;
  String? _erro;

  Map<String, dynamic>? get formulario => _formulario;
  bool get carregando => _carregando;
  bool get buscandoAnimal => _buscandoAnimal;
  String? get erro => _erro;

  bool get podeEditar =>
      _formulario?['status'] == 'em_analise';

  Future<void> carregarFormulario(String id) async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      _formulario =
      await _formularioRepository.buscarFormulario(id);
    } catch (e) {
      _formulario = null;
      _erro = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  Future<Animal> buscarAnimalParaEdicao(String formularioId) async {
    if (_buscandoAnimal) {
      throw Exception('Aguarde a busca do animal.');
    }

    _buscandoAnimal = true;
    notifyListeners();

    try {
      // Consulta novamente a API para obter o status atualizado.
      final formularioAtualizado =
      await _formularioRepository.buscarFormulario(
        formularioId,
      );

      _formulario = formularioAtualizado;

      if (formularioAtualizado['status'] != 'em_analise') {
        throw Exception(
          'Esta solicitação foi finalizada e não pode mais ser editada.',
        );
      }

      final animalDados = formularioAtualizado['animalId'];

      if (animalDados is! Map) {
        throw Exception(
          'Animal vinculado à solicitação não encontrado.',
        );
      }

      final animalId =
      (animalDados['_id'] ?? animalDados['id'] ?? '')
          .toString();

      if (animalId.isEmpty) {
        throw Exception('ID do animal inválido.');
      }

      // Reutiliza o metodo que já existe no seu repository.
      final animais = await _animalRepository.buscarAnimais();

      for (final animal in animais) {
        if (animal.id == animalId) {
          return animal;
        }
      }

      throw Exception(
        'Não foi possível encontrar o animal desta solicitação.',
      );
    } finally {
      _buscandoAnimal = false;
      notifyListeners();
    }
  }


  final FormularioPdfService _pdfService =
  FormularioPdfService();

  bool _gerandoPdf = false;

  bool get gerandoPdf => _gerandoPdf;

  Future<void> baixarPdf(String formularioId) async {
    if (_gerandoPdf) return;

    _gerandoPdf = true;
    notifyListeners();

    try {
      // Busca novamente o formulário para gerar
      // o PDF com os dados e o status atualizados.
      final formularioAtualizado =
      await _formularioRepository.buscarFormulario(
        formularioId,
      );

      _formulario = formularioAtualizado;

      await _pdfService.baixarFormulario(
        formularioAtualizado,
      );
    } finally {
      _gerandoPdf = false;
      notifyListeners();
    }
  }

}
