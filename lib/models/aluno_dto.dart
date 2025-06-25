class AlunoDTO {
  final int id;
  final String nome;
  final int usuarioId;
  final int turmaId;

  AlunoDTO({
    required this.id,
    required this.nome,
    required this.usuarioId,
    required this.turmaId,
  });

  factory AlunoDTO.fromJson(Map<String, dynamic> json) {
    return AlunoDTO(
      id: json['id'],
      nome: json['nome'] ?? '',  // protege contra null
      usuarioId: json['usuarioId'],
      turmaId: json['turmaId'],
    );
  }
}
