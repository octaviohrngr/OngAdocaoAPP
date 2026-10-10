class Formulario {
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
}