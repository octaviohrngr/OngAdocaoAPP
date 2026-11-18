/*class Formulario {
  final String id;
  final String usuarioId;
  final String nome;
  final String email;
  final String telefone;
  final String tipoMoradia;
  final String tempoMedioSozinho;
  final String mensagem;
  final bool aceitarTermos;

  const Formulario({
    required this.id,
    required this.usuarioId,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.tipoMoradia,
    required this.tempoMedioSozinho,
    required this.mensagem,
    required this.aceitarTermos,
  });
}*/



class Formulario {
  final String id;
  final String usuarioId;
  final String animalId;
  final String nomeAnimal;
  final String fotoAnimal;
  final String nome;
  final String email;
  final String telefone;
  final String tipoMoradia;
  final String tempoMedioSozinho;
  final String mensagem;
  final bool aceitarTermos;
  final String status;
  final DateTime? createdAt;

  const Formulario({
    required this.id,
    required this.usuarioId,
    required this.animalId,
    required this.nomeAnimal,
    required this.fotoAnimal,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.tipoMoradia,
    required this.tempoMedioSozinho,
    required this.mensagem,
    required this.aceitarTermos,
    required this.status,
    this.createdAt,
  });

  factory Formulario.fromJson(Map<String, dynamic> json) {
    final usuario = json['usuarioId'];
    final animal = json['animalId'];

    String obterId(dynamic valor) {
      if (valor is Map) {
        return valor['_id']?.toString() ?? '';
      }
      return valor?.toString() ?? '';
    }

    String obterCampo(dynamic objeto, String campo) {
      if (objeto is Map) {
        return objeto[campo]?.toString() ?? '';
      }
      return '';
    }

    return Formulario(
      id: json['_id']?.toString() ?? '',
      usuarioId: obterId(usuario),
      animalId: obterId(animal),
      nomeAnimal: obterCampo(animal, 'nome'),
      fotoAnimal: obterCampo(animal, 'foto1'),
      nome: json['nome']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      telefone: json['telefone']?.toString() ?? '',
      tipoMoradia: json['tipoMoradia']?.toString() ?? '',
      tempoMedioSozinho:
      json['tempoMedioSozinho']?.toString() ?? '',
      mensagem: json['mensagem']?.toString() ?? '',
      aceitarTermos: json['aceitarTermos'] == true,
      status: json['status']?.toString() ?? 'em_analise',
      createdAt: DateTime.tryParse(
        json['createdAt']?.toString() ?? '',
      ),
    );
  }
}
