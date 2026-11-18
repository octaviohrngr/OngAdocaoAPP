
import 'package:flutter/material.dart';

import '../../models/animal.dart';
import '../../data/services/favorites_service.dart';
import '../../data/services/auth_session.dart';
import '../../data/network/requester.dart';
import '../../viewmodels/animal_detail_viewmodel.dart';

import '../theme/app_colors.dart';
import 'adoption_form_screen.dart';

class AnimalDetailScreen extends StatefulWidget {
  final Animal animal;

  const AnimalDetailScreen({
    super.key,
    required this.animal,
  });

  @override
  State<AnimalDetailScreen> createState() =>
      _AnimalDetailScreenState();
}

class _AnimalDetailScreenState
    extends State<AnimalDetailScreen> {
  static const Color _primaryGreen = AppColors.primaryGreen;

  final FavoritesService _favoritesService = FavoritesService();

  final AnimalDetailViewModel _viewModel =
  AnimalDetailViewModel();

  bool _isFavorite = false;
  bool _carregandoFavorito = true;
  bool _verificandoSolicitacao = true;

  String _urlFoto(String foto) {
    if (foto.startsWith('http://') ||
        foto.startsWith('https://')) {
      return foto;
    }

    final base = Requester()
        .baseUrl
        .replaceAll(RegExp(r'/$'), '');

    final caminho =
    foto.startsWith('/') ? foto : '/$foto';

    return '$base$caminho';
  }

  @override
  void initState() {
    super.initState();

    _carregarFavorito();
    _verificarSolicitacao();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _verificarSolicitacao() async {
    final usuarioId = AuthSession.usuario?.id;

    if (usuarioId == null || usuarioId.isEmpty) {
      if (mounted) {
        setState(() {
          _verificandoSolicitacao = false;
        });
      }
      return;
    }

    try {
      await _viewModel.verificarSolicitacao(
        widget.animal.id,
        usuarioId,
      );
    } finally {
      if (mounted) {
        setState(() {
          _verificandoSolicitacao = false;
        });
      }
    }
  }

  Future<void> _abrirFormulario() async {
    final usuarioId = AuthSession.usuario?.id;

    if (usuarioId == null || usuarioId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Faça login para solicitar a adoção.',
          ),
        ),
      );
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdoptionFormScreen(
          animal: widget.animal,
        ),
      ),
    );

    if (!mounted) return;

    await _verificarSolicitacao();
  }

  Future<void> _carregarFavorito() async {
    final favorito = await _favoritesService.ehFavorito(
      widget.animal.nome,
    );

    if (!mounted) return;

    setState(() {
      _isFavorite = favorito;
      _carregandoFavorito = false;
    });
  }

  Future<void> _alternarFavorito() async {
    await _favoritesService.alternarFavorito(
      widget.animal.nome,
    );

    final favorito = await _favoritesService.ehFavorito(
      widget.animal.nome,
    );

    if (!mounted) return;

    setState(() {
      _isFavorite = favorito;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite
              ? '${widget.animal.nome} adicionado aos favoritos!'
              : '${widget.animal.nome} removido dos favoritos.',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Image.network(
                      _urlFoto(widget.animal.foto1),
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Container(
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.pets,
                            size: 60,
                          ),
                        );
                      },
                    ),
                  ),

                  Positioned(
                    top: 12,
                    left: 12,
                    child: _CircleIconButton(
                      icon: Icons.arrow_back,
                      onTap: () =>
                          Navigator.maybePop(context),
                    ),
                  ),

                  Positioned(
                    top: 12,
                    right: 12,
                    child: Row(
                      children: [
                        _CircleIconButton(
                          icon: Icons.share,
                          onTap: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Compartilhamento em breve.',
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(width: 8),

                        _CircleIconButton(
                          icon: _isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          onTap: _carregandoFavorito
                              ? () {}
                              : _alternarFavorito,
                          iconColor: _isFavorite
                              ? Colors.red
                              : Colors.black87,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.animal.nome,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    ),

                    Text(
                      widget.animal.raca,
                      style: const TextStyle(
                        color: _primaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _InfoTag(
                          icon: Icons.cake_outlined,
                          label:
                          '${widget.animal.idadeEstimada} anos',
                        ),

                        _InfoTag(
                          icon: Icons.straighten_outlined,
                          label:
                          'Porte ${widget.animal.porte}',
                        ),

                        _InfoTag(
                          icon: Icons.pets_outlined,
                          label: widget.animal.especie,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Text(
                      'Sobre ${widget.animal.nome}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      widget.animal.temperamento.isNotEmpty
                          ? widget.animal.temperamento
                          : 'Temperamento não informado.',
                      style: TextStyle(
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      'Saúde e Cuidados',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.animal.historicoVacina.isNotEmpty
                            ? widget.animal.historicoVacina
                            : 'Histórico de vacinação não informado.',
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    ListenableBuilder(
                      listenable: _viewModel,
                      builder: (context, child) {
                        final jaSolicitou =
                            _viewModel.jaSolicitou;

                        final adotado =
                            widget.animal.status == 'adotado';

                        final bloqueado =
                            _verificandoSolicitacao ||
                                jaSolicitou ||
                                adotado;

                        String textoBotao = 'Quero Adotar';

                        if (_verificandoSolicitacao) {
                          textoBotao = 'Verificando...';
                        } else if (jaSolicitou) {
                          textoBotao =
                          'Solicitação já enviada';
                        } else if (adotado) {
                          textoBotao = 'Animal adotado';
                        }

                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: bloqueado
                                ? null
                                : _abrirFormulario,
                            icon: const Icon(
                              Icons.volunteer_activism_outlined,
                            ),
                            label: Text(textoBotao),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              AppColors.primaryGreen,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor:
                              AppColors.primaryGreen
                                  .withOpacity(0.5),
                              disabledForegroundColor:
                              Colors.white,
                              padding:
                              const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(12),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 20,
          color: iconColor,
        ),
      ),
    );
  }
}

class _InfoTag extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoTag({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: Colors.grey[700],
          ),

          const SizedBox(width: 6),

          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
