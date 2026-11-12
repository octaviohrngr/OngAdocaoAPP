
import 'package:flutter/material.dart';

import '../../models/animal.dart';
import '../../viewmodels/admin_animals_viewmodel.dart';
import '../theme/app_colors.dart';
import 'animal_register_view.dart';
import 'admin_events_view.dart';

class AdminAnimalsView extends StatefulWidget {
  const AdminAnimalsView({super.key});

  @override
  State<AdminAnimalsView> createState() =>
      _AdminAnimalsViewState();
}

class _AdminAnimalsViewState extends State<AdminAnimalsView> {
  final viewModel = AdminAnimalsViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.carregarAnimais();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  Future<void> _abrirCadastro() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AnimalRegisterView(),
      ),
    );

    if (mounted) {
      await viewModel.carregarAnimais();
    }
  }

  Future<void> _editarAnimal(Animal animal) async {
    final nome = TextEditingController(text: animal.nome);
    final raca = TextEditingController(text: animal.raca);
    final idade = TextEditingController(
      text: '${animal.idadeEstimada}',
    );
    final temperamento = TextEditingController(
      text: animal.temperamento,
    );
    final historico = TextEditingController(
      text: animal.historicoVacina,
    );

    String especie = animal.especie.toLowerCase();
    String porte = animal.porte.toLowerCase();

    if (!['cachorro', 'gato'].contains(especie)) {
      especie = 'cachorro';
    }

    if (!['pequeno', 'médio', 'grande'].contains(porte)) {
      porte = 'pequeno';
    }

    final salvar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, atualizar) {
            return AlertDialog(
              title: const Text('Editar animal'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nome,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                      ),
                    ),
                    TextField(
                      controller: raca,
                      decoration: const InputDecoration(
                        labelText: 'Raça',
                      ),
                    ),
                    TextField(
                      controller: idade,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Idade estimada',
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      value: especie,
                      decoration: const InputDecoration(
                        labelText: 'Espécie',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'cachorro',
                          child: Text('Cachorro'),
                        ),
                        DropdownMenuItem(
                          value: 'gato',
                          child: Text('Gato'),
                        ),
                      ],
                      onChanged: (valor) {
                        if (valor != null) {
                          atualizar(() => especie = valor);
                        }
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: porte,
                      decoration: const InputDecoration(
                        labelText: 'Porte',
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
                      onChanged: (valor) {
                        if (valor != null) {
                          atualizar(() => porte = valor);
                        }
                      },
                    ),
                    TextField(
                      controller: temperamento,
                      decoration: const InputDecoration(
                        labelText: 'Temperamento',
                      ),
                    ),
                    TextField(
                      controller: historico,
                      decoration: const InputDecoration(
                        labelText: 'Histórico de vacina',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.pop(dialogContext, false),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () =>
                      Navigator.pop(dialogContext, true),
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );

    if (salvar == true && mounted) {
      final idadeValor = int.tryParse(idade.text);

      if (nome.text.trim().isEmpty ||
          raca.text.trim().isEmpty ||
          idadeValor == null ||
          idadeValor < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Informe nome, raça e idade válidos.'),
          ),
        );
      } else {
        try {
          await viewModel.editarAnimal(animal, {
            'nome': nome.text.trim(),
            'raca': raca.text.trim(),
            'idadeEstimada': idadeValor,
            'especie': especie,
            'porte': porte,
            'temperamento': temperamento.text.trim(),
            'historicoVacina': historico.text.trim(),
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Animal atualizado!'),
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erro ao atualizar: $e')),
            );
          }
        }
      }
    }

    nome.dispose();
    raca.dispose();
    idade.dispose();
    temperamento.dispose();
    historico.dispose();
  }

  Future<void> _excluirAnimal(Animal animal) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Excluir animal'),
          content: Text('Deseja excluir ${animal.nome}?'),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, true),
              child: const Text(
                'Excluir',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      try {
        await viewModel.excluirAnimal(animal);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Animal excluído!'),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao excluir: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.pets, color: AppColors.primaryGreen),
            SizedBox(width: 8),
            Text(
              'Atipattas',
              style: TextStyle(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            final animais = viewModel.animalsFiltrados;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Animais Cadastrados',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Gerencie o perfil dos animais da ONG.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textGray,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _abrirCadastro,
                          icon: const Icon(Icons.add),
                          label: const Text('Adicionar Novo Animal'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          DropdownButtonFormField<String>(
                            value: viewModel.filtroEspecie,
                            decoration: const InputDecoration(
                              labelText: 'Filtrar por espécie',
                              isDense: true,
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Todos',
                                child: Text('Todos'),
                              ),
                              DropdownMenuItem(
                                value: 'cachorro',
                                child: Text('Cachorro'),
                              ),
                              DropdownMenuItem(
                                value: 'gato',
                                child: Text('Gato'),
                              ),
                            ],
                            onChanged: (valor) {
                              if (valor != null) {
                                viewModel.atualizarFiltroEspecie(valor);
                              }
                            },
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            decoration: const InputDecoration(
                              hintText: 'Buscar por nome...',
                              prefixIcon: Icon(Icons.search),
                              isDense: true,
                            ),
                            onChanged: viewModel.atualizarBusca,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: viewModel.carregando
                      ? const Center(
                    child: CircularProgressIndicator(),
                  )
                      : viewModel.erro != null
                      ? Center(child: Text(viewModel.erro!))
                      : animais.isEmpty
                      ? const Center(
                    child: Text('Nenhum animal encontrado.'),
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: animais.length,
                    itemBuilder: (context, index) {
                      final animal = animais[index];

                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 14),
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              animal.foto1,
                              height: 170,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) {
                                return Container(
                                  height: 170,
                                  color: Colors.grey.shade200,
                                  child: const Center(
                                    child: Icon(
                                      Icons.pets,
                                      size: 48,
                                    ),
                                  ),
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          animal.nome,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                            FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        onSelected: (opcao) {
                                          if (opcao == 'editar') {
                                            _editarAnimal(animal);
                                          }
                                          if (opcao == 'excluir') {
                                            _excluirAnimal(animal);
                                          }
                                        },
                                        itemBuilder: (context) =>
                                        const [
                                          PopupMenuItem(
                                            value: 'editar',
                                            child: Text('Editar'),
                                          ),
                                          PopupMenuItem(
                                            value: 'excluir',
                                            child: Text('Excluir'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${animal.especie} • Porte ${animal.porte}',
                                    style: const TextStyle(
                                      color: AppColors.textGray,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Chip(
                                    label: Text('Cadastrado'),
                                    visualDensity:
                                    VisualDensity.compact,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: AppColors.textGray,
        onTap: (index) {
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminEventsView(),
              ),
            );
          } else if (index != 1) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Essa seção será conectada no próximo passo.',
                ),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Animais',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.volunteer_activism_outlined),
            label: 'Adoção',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Eventos',
          ),
        ],
      ),
    );
  }
}
