class Evento {
  final String id;
  final String titulo;
  final DateTime dataHora;
  final String localizacao;
  final String descricao;

  const Evento({
    required this.id,
    required this.titulo,
    required this.dataHora,
    required this.localizacao,
    required this.descricao,
  });
}