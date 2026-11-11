
import 'package:flutter/material.dart';

import '../../models/usuario.dart';
import '../../viewmodels/profile_viewmodel.dart';
import '../theme/app_colors.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import 'home_view.dart';
import 'events_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileViewModel viewModel = ProfileViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.carregarFavoritos();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: const Row(
              children: [
                Icon(Icons.pets, color: AppColors.primaryGreen),
                SizedBox(width: 8),
                Text(
                  'Atipattas',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _profileCard(),
              const SizedBox(height: 16),
              _optionsCard(),
              const SizedBox(height: 16),
              _supportCard(),
            ],
          ),
          bottomNavigationBar: AppBottomNavigationBar(
            currentIndex: 3,
            usuarioLogado: true,
            onTap: _navegar,
          ),
        );
      },
    );
  }

  Widget _profileCard() {
    return Card(
      color: AppColors.cardBackground,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 34,
              backgroundColor: AppColors.onboardingHero,
              child: Icon(
                Icons.person,
                size: 42,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              viewModel.nomeUsuario,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              viewModel.emailUsuario,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textGray,
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _editarPerfil,
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('Editar Perfil'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accentGreen,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionsCard() {
    return Card(
      color: AppColors.cardBackground,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _option(
            Icons.person_outline,
            'Meus Dados',
            _mostrarMeusDados,
          ),
          _option(
            Icons.favorite_border,
            'Favoritos',
            _mostrarFavoritos,
          ),
          const Divider(
            color: AppColors.divider,
            height: 1,
          ),
          _option(
            Icons.logout,
            'Sair da Conta',
            _sairDaConta,
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _option(
      IconData icon,
      String titulo,
      VoidCallback onTap, {
        Color color = AppColors.textDark,
      }) {
    return ListTile(
      dense: true,
      leading: Icon(icon, color: color, size: 20),
      title: Text(
        titulo,
        style: TextStyle(color: color, fontSize: 13),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textGray,
      ),
      onTap: onTap,
    );
  }

  void _mostrarMeusDados() {
    final usuario = viewModel.usuario;

    if (usuario == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Meus Dados',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 20),
                _dado('Nome', usuario.nome),
                _dado('E-mail', usuario.email),
                _dado('Telefone', usuario.telefone),
                _dado('Tipo de usuário', usuario.tipo),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _editarPerfil();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                    ),
                    child: const Text('Editar meus dados'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _dado(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textGray,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  void _editarPerfil() {
    final usuario = viewModel.usuario;

    if (usuario == null) return;

    final nomeController =
    TextEditingController(text: usuario.nome);
    final emailController =
    TextEditingController(text: usuario.email);
    final telefoneController =
    TextEditingController(text: usuario.telefone);

    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardBackground,
      builder: (modalContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            MediaQuery.of(modalContext).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Editar Perfil',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome completo',
                      border: OutlineInputBorder(),
                    ),
                    validator: (valor) =>
                    valor == null || valor.trim().isEmpty
                        ? 'Informe seu nome'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      border: OutlineInputBorder(),
                    ),
                    validator: (valor) {
                      if (valor == null ||
                          !valor.contains('@')) {
                        return 'Informe um e-mail válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: telefoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Telefone',
                      border: OutlineInputBorder(),
                    ),
                    validator: (valor) =>
                    valor == null || valor.trim().isEmpty
                        ? 'Informe seu telefone'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }

                        final sucesso = await viewModel.atualizarPerfil(
                          nome: nomeController.text,
                          email: emailController.text,
                          telefone: telefoneController.text,
                        );

                        if (!mounted || !modalContext.mounted) return;

                        if (sucesso) {
                          Navigator.pop(modalContext);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Perfil atualizado com sucesso!'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                viewModel.erro ?? 'Erro ao atualizar perfil.',
                              ),
                            ),
                          );
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                      ),
                      child: const Text('Salvar Alterações'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      nomeController.dispose();
      emailController.dispose();
      telefoneController.dispose();
    });
  }

  void _mostrarFavoritos() async {
    await viewModel.carregarFavoritos();

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Meus Favoritos',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListenableBuilder(
                      listenable: viewModel,
                      builder: (context, _) {
                        if (viewModel.favoritos.isEmpty) {
                          return const Center(
                            child: Text(
                              'Você ainda não favoritou nenhum animal.',
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: viewModel.favoritos.length,
                          itemBuilder: (context, index) {
                            final nome =
                            viewModel.favoritos[index];

                            return ListTile(
                              leading: const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                              title: Text(nome),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  viewModel.removerFavorito(nome);
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _sairDaConta() {
    viewModel.sairDaConta();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeView(),
      ),
          (route) => false,
    );
  }

  void _navegar(int index) {
    if (index == 0) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeView(),
        ),
            (route) => false,
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const EventsView(),
        ),
      );
    } else if (index == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Central de notificações em breve.'),
        ),
      );
    }
  }

  Widget _supportCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accentGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        children: [
          Icon(Icons.support_agent, color: Colors.white),
          SizedBox(height: 6),
          Text(
            'Precisa de ajuda?',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Nossa equipe de suporte está aqui para você.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
