class Animal {
  final String id;
  final String nome;
  final String especie;
  final String raca;
  final int idadeEstimada;
  final String porte;
  final String foto1;
  final String foto2;
  final String status;
  final String temperamento;
  final String historicoVacina;

  const Animal({
    required this.id,
    required this.nome,
    required this.especie,
    required this.raca,
    required this.idadeEstimada,
    required this.porte,
    required this.foto1,
    required this.foto2,
    this.status = 'disponivel',
    required this.temperamento,
    required this.historicoVacina,
  });
}