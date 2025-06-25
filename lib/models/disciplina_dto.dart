class DisciplinaDTO {
  final int? id;
  final String nome;
  final int? professorId;
  final String? nomeProfessor;

  DisciplinaDTO({
    this.id,
    required this.nome,
    this.professorId,
    this.nomeProfessor,
  });

  factory DisciplinaDTO.fromJson(Map<String, dynamic> json) {
    return DisciplinaDTO(
      id: json['id'] is int ? json['id'] : (json['id'] != null ? int.tryParse(json['id'].toString()) : null),
      nome: json['nome'] ?? '',
      professorId: json['professorId'] is int ? json['professorId'] : (json['professorId'] != null ? int.tryParse(json['professorId'].toString()) : null),
      nomeProfessor: json['nomeProfessor'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'nome': nome,
    };
    if (id != null) {
      data['id'] = id;
    }
    if (professorId != null) {
      data['professorId'] = professorId;
    }
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DisciplinaDTO && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}