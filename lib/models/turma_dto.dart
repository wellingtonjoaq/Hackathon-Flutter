class TurmaDTO {
  final int id;
  final String nome;

  TurmaDTO({required this.id, required this.nome});

  factory TurmaDTO.fromJson(Map<String, dynamic> json) {
    return TurmaDTO(
      id: json['id'],
      nome: json['nome'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
    };
  }
}
