
import 'package:flutter/material.dart';


import '../../models/evento.dart';
import '../../viewmodels/admin_events_viewmodel.dart';
import '../theme/app_colors.dart';
import 'event_register_view.dart';

class AdminEventsView extends StatefulWidget {
  const AdminEventsView({super.key});

  @override
  State<AdminEventsView> createState() => _AdminEventsViewState();
}

class _AdminEventsViewState extends State<AdminEventsView> {
  final viewModel = AdminEventsViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.carregarEventos();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  Future<void> abrirFormulario({Evento? evento}) async {
    final resultado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EventRegisterView(evento: evento),
      ),
    );

    if (!mounted) return;

    if (resultado == true) {
      await viewModel.carregarEventos();
    }
  }

  Future<void> confirmarExclusao(Evento evento) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir evento'),
        content: Text(
          'Deseja realmente excluir o evento "${evento.titulo}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    final sucesso = await viewModel.excluirEvento(evento.id);

    if (!mounted) return;

    mostrarMensagem(
      sucesso
          ? 'Evento excluído com sucesso!'
          : viewModel.erro ?? 'Erro ao excluir evento.',
    );
  }

  Widget construirCard(Evento evento) {
    final dataFormatada =
        '${evento.dataHora.day.toString().padLeft(2, '0')}/${evento.dataHora.month.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: evento.foto.isNotEmpty
                      ? Image.network(
                    evento.foto,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        imagemPadrao(),
                  )
                      : imagemPadrao(),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 13,
                        color: AppColors.primaryGreen,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        dataFormatada,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  evento.titulo,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  color: AppColors.textDark,
                ),
                onSelected: (opcao) {
                  if (opcao == 'editar') {
                    abrirFormulario(evento: evento);
                  } else if (opcao == 'excluir') {
                    confirmarExclusao(evento);
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'editar',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 18),
                        SizedBox(width: 8),
                        Text('Editar'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'excluir',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Excluir',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 16,
                color: AppColors.primaryGreen,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  evento.localizacao,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textGray,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            evento.descricao,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget imagemPadrao() {
    return Container(
      color: AppColors.inputFill,
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          size: 45,
          color: AppColors.accentGreen,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Gerenciar Eventos - ONG'),
        backgroundColor: AppColors.background,
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            return RefreshIndicator(
              onRefresh: viewModel.carregarEventos,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Text(
                    'Eventos e Campanhas',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Gerencie as próximas atividades da sua ONG.',
                    style: TextStyle(
                      color: AppColors.textGray,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      onPressed: () => abrirFormulario(),
                      icon: const Icon(Icons.add),
                      label: const Text('Novo Evento'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    onChanged: viewModel.atualizarBusca,
                    decoration: InputDecoration(
                      hintText: 'Pesquisar eventos...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: AppColors.cardBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (viewModel.carregando)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else if (viewModel.erro != null)
                    Column(
                      children: [
                        Text(viewModel.erro!),
                        TextButton(
                          onPressed: viewModel.carregarEventos,
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    )
                  else if (viewModel.eventosFiltrados.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Text('Nenhum evento encontrado.'),
                        ),
                      )
                    else
                      ...viewModel.eventosFiltrados.map(
                        construirCard,
                      ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
