import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AdminAnimalsScreen extends StatefulWidget {
  const AdminAnimalsScreen({super.key});

  @override
  State<AdminAnimalsScreen> createState() =>
      _AdminAnimalsScreenState();
}

class _AdminAnimalsScreenState extends State<AdminAnimalsScreen> {
  final List<Map<String, String>> _animals = [
    {
      'nome': 'Bolinha',
      'especie': 'Cão',
      'sexo': 'Macho',
      'porte': 'Médio',
      'status': 'Disponível',
      'foto':
      'https://images.unsplash.com/photo-1552053831-71594a27632d?w=800',
    },
    {
      'nome': 'Luna',
      'especie': 'Gato',
      'sexo': 'Fêmea',
      'porte': 'Pequeno',
      'status': 'Em Processo',
      'foto':
      'https://images.unsplash.com/photo-1513360371669-4adf3dd7dff8?w=800',
    },
    {
      'nome': 'Rex',
      'especie': 'Cão',
      'sexo': 'Macho',
      'porte': 'Grande',
      'status': 'Adotado',
      'foto':
      'https://images.unsplash.com/photo-1551717743-49959800b1f6?w=800',
    },
    {
      'nome': 'Mia',
      'especie': 'Gato',
      'sexo': 'Fêmea',
      'porte': 'Pequeno',
      'status': 'Disponível',
      'foto':
      'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=800',
    },
  ];

  String _busca = '';
  String _filtroEspecie = 'Todos';
  String _filtroStatus = 'Todos';

  List<Map<String, String>> get _animalsFiltrados {
    return _animals.where((animal) {
      final nome = animal['nome']!.toLowerCase();
      final correspondeNome =
      nome.contains(_busca.toLowerCase());

      final correspondeEspecie =
          _filtroEspecie == 'Todos' ||
              animal['especie'] == _filtroEspecie;

      final correspondeStatus =
          _filtroStatus == 'Todos' ||
              animal['status'] == _filtroStatus;

      return correspondeNome &&
          correspondeEspecie &&
          correspondeStatus;
    }).toList();
  }

  Future<void> _abrirFormulario({
    Map<String, String>? animal,
  }) async {
    final nomeController = TextEditingController(
      text: animal?['nome'] ?? '',
    );

    final fotoController = TextEditingController(
      text: animal?['foto'] ?? '',
    );

    String especie = animal?['especie'] ?? 'Cão';
    String sexo = animal?['sexo'] ?? 'Macho';
    String porte = animal?['porte'] ?? 'Médio';
    String status = animal?['status'] ?? 'Disponível';

    final resultado = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, atualizarDialogo) {
            return AlertDialog(
              title: Text(
                animal == null
                    ? 'Cadastrar animal'
                    : 'Editar animal',
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome do animal',
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: especie,
                      decoration: const InputDecoration(
                        labelText: 'Espécie',
                      ),
                      items: ['Cão', 'Gato'].map((opcao) {
                        return DropdownMenuItem(
                          value: opcao,
                          child: Text(opcao),
                        );
                      }).toList(),
                      onChanged: (valor) {
                        if (valor != null) {
                          atualizarDialogo(() {
                            especie = valor;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: sexo,
                      decoration: const InputDecoration(
                        labelText: 'Sexo',
                      ),
                      items: ['Macho', 'Fêmea'].map((opcao) {
                        return DropdownMenuItem(
                          value: opcao,
                          child: Text(opcao),
                        );
                      }).toList(),
                      onChanged: (valor) {
                        if (valor != null) {
                          atualizarDialogo(() {
                            sexo = valor;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: porte,
                      decoration: const InputDecoration(
                        labelText: 'Porte',
                      ),
                      items: [
                        'Pequeno',
                        'Médio',
                        'Grande',
                      ].map((opcao) {
                        return DropdownMenuItem(
                          value: opcao,
                          child: Text(opcao),
                        );
                      }).toList(),
                      onChanged: (valor) {
                        if (valor != null) {
                          atualizarDialogo(() {
                            porte = valor;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: status,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                      ),
                      items: [
                        'Disponível',
                        'Em Processo',
                        'Adotado',
                      ].map((opcao) {
                        return DropdownMenuItem(
                          value: opcao,
                          child: Text(opcao),
                        );
                      }).toList(),
                      onChanged: (valor) {
                        if (valor != null) {
                          atualizarDialogo(() {
                            status = valor;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: fotoController,
                      decoration: const InputDecoration(
                        labelText: 'URL da foto',
                        hintText: 'https://...',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, false);
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nomeController.text.trim().isEmpty) {
                      return;
                    }

                    Navigator.pop(dialogContext, true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );

    if (resultado == true && mounted) {
      setState(() {
        final dados = <String, String>{
          'nome': nomeController.text.trim(),
          'especie': especie,
          'sexo': sexo,
          'porte': porte,
          'status': status,
          'foto': fotoController.text.trim(),
        };

        if (animal == null) {
          _animals.insert(0, dados);
        } else {
          final indice = _animals.indexOf(animal);
          if (indice != -1) {
            _animals[indice] = dados;
          }
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Animal salvo com sucesso!'),
        ),
      );
    }

    nomeController.dispose();
    fotoController.dispose();
  }

  Future<void> _excluirAnimal(
      Map<String, String> animal,
      ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir animal'),
          content: Text(
            'Deseja excluir ${animal['nome']}?',
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
        );
      },
    );

    if (confirmar == true && mounted) {
      setState(() {
        _animals.remove(animal);
      });
    }
  }

  Color _corStatus(String status) {
    switch (status) {
      case 'Disponível':
        return AppColors.primaryGreen;
      case 'Em Processo':
        return Colors.orange.shade700;
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Icon(
              Icons.pets,
              color: AppColors.primaryGreen,
            ),
            const SizedBox(width: 8),
            const Text(
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16, 20, 16, 12,
              ),
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
                    'Gerencie o perfil e status dos animais da ONG.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textGray,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _abrirFormulario(),
                      icon: const Icon(Icons.add),
                      label: const Text(
                        'Adicionar Novo Animal',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: _filtroEspecie,
                        decoration: const InputDecoration(
                          labelText: 'Filtrar por espécie',
                          isDense: true,
                        ),
                        items: [
                          'Todos',
                          'Cão',
                          'Gato',
                        ].map((opcao) {
                          return DropdownMenuItem(
                            value: opcao,
                            child: Text(opcao),
                          );
                        }).toList(),
                        onChanged: (valor) {
                          if (valor != null) {
                            setState(() {
                              _filtroEspecie = valor;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _filtroStatus,
                        decoration: const InputDecoration(
                          labelText: 'Filtrar por status',
                          isDense: true,
                        ),
                        items: [
                          'Todos',
                          'Disponível',
                          'Em Processo',
                          'Adotado',
                        ].map((opcao) {
                          return DropdownMenuItem(
                            value: opcao,
                            child: Text(opcao),
                          );
                        }).toList(),
                        onChanged: (valor) {
                          if (valor != null) {
                            setState(() {
                              _filtroStatus = valor;
                            });
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
                        onChanged: (valor) {
                          setState(() {
                            _busca = valor;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _animalsFiltrados.isEmpty
                  ? const Center(
                child: Text('Nenhum animal encontrado.'),
              )
                  : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _animalsFiltrados.length,
                itemBuilder: (context, index) {
                  final animal = _animalsFiltrados[index];

                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.only(
                      bottom: 14,
                    ),
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Image.network(
                              animal['foto']!,
                              height: 170,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (
                                  context,
                                  error,
                                  stackTrace,
                                  ) {
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
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                padding:
                                const EdgeInsets
                                    .symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: _corStatus(
                                    animal['status']!,
                                  ),
                                  borderRadius:
                                  BorderRadius
                                      .circular(6),
                                ),
                                child: Text(
                                  animal['status']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                                      animal['nome']!,
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
                                        _abrirFormulario(
                                          animal: animal,
                                        );
                                      } else if (opcao ==
                                          'excluir') {
                                        _excluirAnimal(animal);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'editar',
                                        child: Text('Editar'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'excluir',
                                        child: Text('Excluir'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                '${animal['especie']} • '
                                    '${animal['sexo']} • '
                                    'Porte ${animal['porte']}',
                                style: const TextStyle(
                                  color: AppColors.textGray,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 6,
                                children: const [
                                  Chip(
                                    label: Text('Cadastrado'),
                                    visualDensity:
                                    VisualDensity.compact,
                                  ),
                                ],
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
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: AppColors.textGray,
        onTap: (index) {
          if (index != 1) {
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