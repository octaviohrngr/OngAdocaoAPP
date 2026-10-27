
import 'package:flutter/material.dart';

import '../../services/favorites_service.dart';
import 'adoption_form_screen.dart';

class AnimalDetailScreen extends StatefulWidget {
  final String name;
  final String breed;
  final String age;
  final String imageUrl;

  const AnimalDetailScreen({
    super.key,
    required this.name,
    required this.breed,
    required this.age,
    required this.imageUrl,
  });

  @override
  State<AnimalDetailScreen> createState() =>
      _AnimalDetailScreenState();
}

class _AnimalDetailScreenState extends State<AnimalDetailScreen> {
  static const Color _primaryGreen = Color(0xFF3BAA57);

  final FavoritesService _favoritesService = FavoritesService();

  bool _isFavorite = false;
  bool _carregandoFavorito = true;

  @override
  void initState() {
    super.initState();
    _carregarFavorito();
  }

  Future<void> _carregarFavorito() async {
    final favorito =
    await _favoritesService.ehFavorito(widget.name);

    if (!mounted) return;

    setState(() {
      _isFavorite = favorito;
      _carregandoFavorito = false;
    });
  }

  Future<void> _alternarFavorito() async {
    await _favoritesService.alternarFavorito(widget.name);

    final favorito =
    await _favoritesService.ehFavorito(widget.name);

    if (!mounted) return;

    setState(() {
      _isFavorite = favorito;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite
              ? '${widget.name} adicionado aos favoritos!'
              : '${widget.name} removido dos favoritos.',
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
                      widget.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.pets,
                          size: 60,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: _CircleIconButton(
                      icon: Icons.arrow_back,
                      onTap: () => Navigator.maybePop(context),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    ),
                    Text(
                      widget.breed,
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
                          label: widget.age,
                        ),
                        const _InfoTag(
                          icon: Icons.straighten_outlined,
                          label: 'Porte grande',
                        ),
                        const _InfoTag(
                          icon: Icons.content_cut_outlined,
                          label: 'Pelagem longa',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Sobre ${widget.name}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.name} está esperando uma família que ofereça '
                          'carinho, atenção e um lar seguro. Cada animal tem '
                          'sua própria personalidade. Venha conhecê-lo e '
                          'descubra se vocês combinam!',
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
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics:
                      const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 2.6,
                      children: const [
                        _HealthCard(
                          icon: Icons.vaccines_outlined,
                          title: 'Vacinado',
                          subtitle: 'Em dia',
                          ok: true,
                        ),
                        _HealthCard(
                          icon: Icons.shield_outlined,
                          title: 'Vermifugado',
                          subtitle: 'Em dia',
                          ok: true,
                        ),
                        _HealthCard(
                          icon: Icons.cut_outlined,
                          title: 'Castrado',
                          subtitle: 'Pendente (idade)',
                          ok: false,
                        ),
                        _HealthCard(
                          icon: Icons.memory_outlined,
                          title: 'Microchip',
                          subtitle: 'Não possui',
                          ok: false,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Onde ele está?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.location_on_outlined,
                              color: _primaryGreen,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ONG Tudo por Patas',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[900],
                                  ),
                                ),
                                Text(
                                  'Atibaia, SP',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const AdoptionFormScreen(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.volunteer_activism_outlined,
                        ),
                        label: const Text('Quero Adotar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
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

class _HealthCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool ok;

  const _HealthCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.ok,
  });

  static const Color _primaryGreen = Color(0xFF3BAA57);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: ok
                ? _primaryGreen.withOpacity(0.15)
                : Colors.grey.shade300,
            child: Icon(
              icon,
              size: 16,
              color: ok ? _primaryGreen : Colors.grey[600],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
