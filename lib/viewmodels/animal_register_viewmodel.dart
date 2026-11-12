
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/repository/animal_repository.dart';

class AnimalRegisterViewModel extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  final AnimalRepository _repository = AnimalRepository();
  final nomeController = TextEditingController();
  final racaController = TextEditingController();
  final idadeController = TextEditingController();
  final historicoController = TextEditingController();

  String especie = 'cachorro';
  String? porte;
  final List<String> temperamentos = [];
  final List<XFile> fotos = [];

  bool enviando = false;
  String? erro;

  final List<String> opcoesTemperamento = [
    'Brincalhão',
    'Calmo',
    'Assustado',
    'Sociável',
  ];

  void selecionarEspecie(String valor) {
    especie = valor;
    notifyListeners();
  }

  void selecionarPorte(String? valor) {
    porte = valor;
    notifyListeners();
  }

  void alternarTemperamento(String valor) {
    if (temperamentos.contains(valor)) {
      temperamentos.remove(valor);
    } else if (temperamentos.length < 3) {
      temperamentos.add(valor);
    }
    notifyListeners();
  }

  Future<void> selecionarFotos() async {
    try {
      final selecionadas = await _picker.pickMultiImage(
        imageQuality: 80,
      );

      final vagas = 2 - fotos.length;

      if (vagas <= 0) {
        erro = 'São permitidas somente duas fotos.';
      } else {
        fotos.addAll(selecionadas.take(vagas));
        erro = selecionadas.length > vagas
            ? 'Somente duas fotos são permitidas.'
            : null;
      }

      notifyListeners();
    } catch (e) {
      erro = 'Não foi possível selecionar as imagens.';
      notifyListeners();
    }
  }

  void removerFoto(int index) {
    if (index >= 0 && index < fotos.length) {
      fotos.removeAt(index);
      notifyListeners();
    }
  }

  String? validarNome(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe o nome do animal.';
    }
    return null;
  }

  String? validarRaca(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe a raça do animal.';
    }
    return null;
  }

  String? validarIdade(String? valor) {
    final idade = int.tryParse(valor?.trim() ?? '');

    if (idade == null || idade < 0) {
      return 'Informe uma idade válida em anos.';
    }
    return null;
  }

  // Mantemos idadeEstimada em meses, como na Home.
  int get idadeEmMeses =>
      (int.tryParse(idadeController.text.trim()) ?? 0) * 12;

  String get temperamento =>
      temperamentos.join(', ');

  bool validarCadastro() {
    if (nomeController.text.trim().isEmpty ||
        racaController.text.trim().isEmpty ||
        validarIdade(idadeController.text) != null ||
        porte == null) {
      erro = 'Preencha todos os campos obrigatórios.';
      notifyListeners();
      return false;
    }

    if (fotos.length != 2) {
      erro = 'Selecione duas fotos do animal.';
      notifyListeners();
      return false;
    }

    erro = null;
    notifyListeners();
    return true;
  }


  Future<void> cadastrarAnimal() async {
    if (!validarCadastro()) return;

    enviando = true;
    erro = null;
    notifyListeners();

    try {
      final foto1 = await fotos[0].readAsBytes();
      final foto2 = await fotos[1].readAsBytes();

      final dados = {
        'nome': nomeController.text.trim(),
        'especie': especie,
        'raca': racaController.text.trim(),
        'idadeEstimada': int.parse(idadeController.text.trim()),
        'porte': porte,
        'temperamento': temperamento,
        'historicoVacina': historicoController.text.trim(),
      };

      await _repository.cadastrarAnimal(
        dados,
        foto1,
        foto2,
        fotos[0].name,
        fotos[1].name,
      );
    } catch (e) {
      erro = 'Erro ao cadastrar animal: $e';
    } finally {
      enviando = false;
      notifyListeners();
    }
  }


  @override
  void dispose() {
    nomeController.dispose();
    racaController.dispose();
    idadeController.dispose();
    historicoController.dispose();
    super.dispose();
  }
}
