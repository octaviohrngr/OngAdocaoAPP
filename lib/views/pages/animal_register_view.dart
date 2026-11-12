
import 'package:flutter/material.dart';
import '../../viewmodels/animal_register_viewmodel.dart';
import '../theme/app_colors.dart';

class AnimalRegisterView extends StatefulWidget {
  const AnimalRegisterView({super.key});

  @override
  State<AnimalRegisterView> createState() =>
      _AnimalRegisterViewState();
}

class _AnimalRegisterViewState extends State<AnimalRegisterView> {
  final viewModel = AnimalRegisterViewModel();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: AppColors.textGray,
        fontSize: 13,
      ),
      filled: true,
      fillColor: AppColors.inputFill,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 13,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _label(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  Widget _secao({
    required IconData icone,
    required String titulo,
    required Widget conteudo,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icone,
                color: AppColors.primaryGreen,
                size: 20,
              ),
              const SizedBox(width: 7),
              Text(
                titulo,
                style: const TextStyle(
                  color: AppColors.primaryGreen,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          conteudo,
        ],
      ),
    );
  }

  Widget _informacoesBasicas() {
    return _secao(
      icone: Icons.medical_services_outlined,
      titulo: 'Informações Básicas',
      conteudo: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Nome do Animal'),
          TextFormField(
            controller: viewModel.nomeController,
            validator: viewModel.validarNome,
            decoration: _inputDecoration('Ex: Rex'),
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    _label('Espécie'),
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: AppColors.inputFill,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          _especieBotao(
                            'Cachorro',
                            'cachorro',
                          ),
                          _especieBotao('Gato', 'gato'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    _label('Raça'),
                    TextFormField(
                      controller: viewModel.racaController,
                      validator: viewModel.validarRaca,
                      decoration:
                      _inputDecoration('SRD, Poodle...'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    _label('Idade Estimada'),
                    TextFormField(
                      controller: viewModel.idadeController,
                      keyboardType: TextInputType.number,
                      validator: viewModel.validarIdade,
                      decoration: _inputDecoration('Ex: 2 anos'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    _label('Porte'),
                    DropdownButtonFormField<String>(
                      value: viewModel.porte,
                      isExpanded: true,
                      decoration: _inputDecoration(''),
                      hint: const Text(
                        'Selecione...',
                        style: TextStyle(fontSize: 12),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'pequeno',
                          child: Text('Pequeno'),
                        ),
                        DropdownMenuItem(
                          value: 'médio',
                          child: Text('Médio'),
                        ),
                        DropdownMenuItem(
                          value: 'grande',
                          child: Text('Grande'),
                        ),
                      ],
                      onChanged: viewModel.selecionarPorte,
                      validator: (valor) =>
                      valor == null
                          ? 'Selecione o porte.'
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _especieBotao(String titulo, String valor) {
    final selecionado = viewModel.especie == valor;

    return Expanded(
      child: GestureDetector(
        onTap: () => viewModel.selecionarEspecie(valor),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selecionado
                ? AppColors.primaryGreen
                : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Text(
            titulo,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: selecionado
                  ? FontWeight.bold
                  : FontWeight.normal,
              color: selecionado
                  ? Colors.white
                  : AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }

  Widget _fotos() {
    return _secao(
      icone: Icons.add_a_photo_outlined,
      titulo: 'Fotos',
      conteudo: Column(
        children: [
          InkWell(
            onTap: viewModel.selecionarFotos,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.divider,
                  width: 1.5,
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColors.inputFill,
                    child: Icon(
                      Icons.cloud_upload_outlined,
                      size: 28,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Toque para fazer upload',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Selecione até 2 fotos (máx 5MB)',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (viewModel.fotos.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(
                viewModel.fotos.length,
                    (index) => _fotoSelecionada(index),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _fotoSelecionada(int index) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 85,
          height: 85,
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(10),
          ),
          child: FutureBuilder(
            future: viewModel.fotos[index].readAsBytes(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  snapshot.data!,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
        Positioned(
          top: -9,
          right: -9,
          child: GestureDetector(
            onTap: () => viewModel.removerFoto(index),
            child: const CircleAvatar(
              radius: 10,
              backgroundColor: Colors.red,
              child: Icon(
                Icons.close,
                size: 12,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _perfilSaude() {
    return _secao(
      icone: Icons.psychology_outlined,
      titulo: 'Perfil e Saúde',
      conteudo: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Temperamento (Selecione até 3)'),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: viewModel.opcoesTemperamento.map(
                  (opcao) {
                final selecionado =
                viewModel.temperamentos.contains(opcao);

                return FilterChip(
                  label: Text(opcao),
                  selected: selecionado,
                  onSelected: (_) =>
                      viewModel.alternarTemperamento(opcao),
                  selectedColor: AppColors.accentGreen,
                  backgroundColor: Colors.white,
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    color: selecionado
                        ? Colors.white
                        : AppColors.textDark,
                  ),
                  side: const BorderSide(
                    color: AppColors.divider,
                  ),
                );
              },
            ).toList(),
          ),
          const SizedBox(height: 18),
          _label('Histórico de Saúde / Observações'),
          TextFormField(
            controller: viewModel.historicoController,
            maxLines: 4,
            decoration: _inputDecoration(
              'Vacinas, vermífugos, problemas de saúde conhecidos...',
            ),
          ),
        ],
      ),
    );
  }



  Future<void> _cadastrar() async {
    if (!formKey.currentState!.validate()) return;

    if (!viewModel.validarCadastro()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.erro ?? 'Verifique os dados.'),
        ),
      );
      return;
    }

    await viewModel.cadastrarAnimal();

    if (!mounted) return;

    if (viewModel.erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(viewModel.erro!)),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Animal cadastrado com sucesso!'),
      ),
    );

    Navigator.pop(context, true);
  }



  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.cardBackground,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: const Row(
              children: [
                Icon(
                  Icons.pets,
                  color: AppColors.primaryGreen,
                ),
                SizedBox(width: 10),
                Text(
                  'Atipattas',
                  style: TextStyle(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.tune,
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
          body: Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Cadastrar Animal',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Adicione os detalhes do novo animal para adoção.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textGray,
                  ),
                ),
                const SizedBox(height: 22),
                _informacoesBasicas(),
                _fotos(),
                _perfilSaude(),
                const SizedBox(height: 14),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 46,
                  child: FilledButton.icon(
                    onPressed: viewModel.enviando
                        ? null
                        : _cadastrar,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    icon: const Icon(
                      Icons.check_circle_outline,
                      size: 18,
                    ),
                    label: const Text(
                      'Cadastrar Animal',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}
