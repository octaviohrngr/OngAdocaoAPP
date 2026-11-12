
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/evento.dart';
import '../../viewmodels/event_register_viewmodel.dart';
import '../theme/app_colors.dart';

class EventRegisterView extends StatefulWidget {
  final Evento? evento;

  const EventRegisterView({
    super.key,
    this.evento,
  });

  @override
  State<EventRegisterView> createState() => _EventRegisterViewState();
}

class _EventRegisterViewState extends State<EventRegisterView> {
  late final EventRegisterViewModel viewModel;
  final formKey = GlobalKey<FormState>();

  bool get editando => widget.evento != null;

  @override
  void initState() {
    super.initState();
    viewModel = EventRegisterViewModel(evento: widget.evento);
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  Future<void> selecionarDataHora() async {
    final agora = DateTime.now();

    final data = await showDatePicker(
      context: context,
      initialDate: viewModel.dataHora ?? agora,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (data == null || !mounted) return;

    final horario = await showTimePicker(
      context: context,
      initialTime: viewModel.dataHora != null
          ? TimeOfDay.fromDateTime(viewModel.dataHora!)
          : TimeOfDay.now(),
    );

    if (horario == null) return;

    viewModel.selecionarDataHora(
      DateTime(
        data.year,
        data.month,
        data.day,
        horario.hour,
        horario.minute,
      ),
    );
  }

  Future<void> salvar() async {
    if (!formKey.currentState!.validate()) return;

    final sucesso = await viewModel.salvarEvento(
      id: widget.evento?.id,
    );

    if (!mounted) return;

    if (sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            editando
                ? 'Evento atualizado com sucesso!'
                : 'Evento cadastrado com sucesso!',
          ),
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            viewModel.erro ?? 'Erro ao salvar evento.',
          ),
        ),
      );
    }
  }

  Widget campo({
    required String label,
    required TextEditingController controller,
    int linhas = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: linhas,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (valor) {
        if (valor == null || valor.trim().isEmpty) {
          return 'Preencha este campo.';
        }
        return null;
      },
    );
  }

  Widget campoFoto() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Foto do evento (opcional)',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(14),
          ),
          child: viewModel.foto != null
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: AppColors.primaryGreen,
                  size: 36,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  child: Text(
                    viewModel.foto!.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                TextButton(
                  onPressed: viewModel.removerFoto,
                  child: const Text('Remover foto'),
                ),
              ],
            ),
          )
              : viewModel.fotoAtual.isNotEmpty
              ? ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              viewModel.fotoAtual,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.image_outlined),
            ),
          )
              : const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                size: 45,
                color: AppColors.accentGreen,
              ),
              SizedBox(height: 8),
              Text('Nenhuma foto selecionada'),
            ],
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: viewModel.selecionarFoto,
          icon: const Icon(Icons.photo_library_outlined),
          label: Text(
            viewModel.fotoAtual.isNotEmpty || viewModel.foto != null
                ? 'Trocar foto'
                : 'Selecionar foto',
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          editando ? 'Editar Evento' : 'Cadastrar Evento',
        ),
        backgroundColor: AppColors.background,
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      editando
                          ? 'Atualizar Evento'
                          : 'Novo Evento',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Preencha as informações da atividade da ONG.',
                      style: TextStyle(
                        color: AppColors.textGray,
                      ),
                    ),
                    const SizedBox(height: 25),

                    campo(
                      label: 'Título do evento',
                      controller: viewModel.tituloController,
                    ),
                    const SizedBox(height: 16),

                    InkWell(
                      onTap: selecionarDataHora,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Data e horário',
                          filled: true,
                          fillColor: AppColors.inputFill,
                          suffixIcon: const Icon(
                            Icons.calendar_month_outlined,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        child: Text(
                          viewModel.dataHora == null
                              ? 'Selecione a data e o horário'
                              : DateFormat('dd/MM/yyyy HH:mm')
                              .format(viewModel.dataHora!),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    campo(
                      label: 'Localização',
                      controller: viewModel.localizacaoController,
                    ),
                    const SizedBox(height: 16),

                    campo(
                      label: 'Descrição',
                      controller: viewModel.descricaoController,
                      linhas: 4,
                    ),
                    const SizedBox(height: 22),

                    campoFoto(),
                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: viewModel.enviando
                            ? null
                            : salvar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: viewModel.enviando
                            ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : Text(
                          editando
                              ? 'Salvar Alterações'
                              : 'Cadastrar Evento',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
