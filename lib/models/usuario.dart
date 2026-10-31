
class Usuario {
  final String id;
  final String nome;
  final String email;
  final String telefone;
  final String tipo; // 'admin' ou 'adotante'

  const Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.tipo,
  });


  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'].toString(),
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      telefone: json['telefone'] ?? '',
      tipo: json['tipo'] ?? 'adotante',
    );
  }
}