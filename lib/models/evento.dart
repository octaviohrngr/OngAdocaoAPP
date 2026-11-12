


class Evento {
  final String id;
  final String titulo;
  final DateTime dataHora;
  final String localizacao;
  final String descricao;
  final String foto;

  const Evento({
    required this.id,
    required this.titulo,
    required this.dataHora,
    required this.localizacao,
    required this.descricao,
    required this.foto,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      titulo: (json['titulo'] ?? '').toString(),
      dataHora: DateTime.tryParse(
        (json['dataHora'] ?? '').toString(),
      ) ??
          DateTime.now(),
      localizacao: (json['localizacao'] ?? '').toString(),
      descricao: (json['descricao'] ?? '').toString(),
      foto: (json['foto'] ?? '').toString(),
    );
  }
}

