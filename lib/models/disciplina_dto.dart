class DisciplinaDTO {
  final int id;
  final String nome;

  DisciplinaDTO({required this.id, required this.nome});

  factory DisciplinaDTO.fromJson(Map<String, dynamic> json) {
    return DisciplinaDTO(
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
