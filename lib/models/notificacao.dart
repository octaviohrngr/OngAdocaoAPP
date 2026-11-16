
class Notificacao {
  final String id;
  final String usuarioId;
  final String formularioId;
  final String titulo;
  final String mensagem;
  final String tipo;
  final bool lida;
  final DateTime? createdAt;

  const Notificacao({
    required this.id,
    required this.usuarioId,
    required this.formularioId,
    required this.titulo,
    required this.mensagem,
    required this.tipo,
    required this.lida,
    this.createdAt,
  });

  factory Notificacao.fromJson(
      Map<String, dynamic> json,
      ) {
    return Notificacao(
      id: json['_id']?.toString() ?? '',
      usuarioId: json['usuarioId']?.toString() ?? '',
      formularioId:
      json['formularioId']?.toString() ?? '',
      titulo: json['titulo']?.toString() ?? '',
      mensagem: json['mensagem']?.toString() ?? '',
      tipo: json['tipo']?.toString() ?? '',
      lida: json['lida'] == true,
      createdAt: DateTime.tryParse(
        json['createdAt']?.toString() ?? '',
      ),
    );
  }
}
