// lib/models/turma_dto.dart
class TurmaDTO {
  final int? id; // O ID pode ser nulo para novas turmas
  final String nome;
  final String periodo;
  final String curso;

  TurmaDTO({
    this.id,
    required this.nome,
    required this.periodo,
    required this.curso,
  });

  factory TurmaDTO.fromJson(Map<String, dynamic> json) {
    return TurmaDTO(
      // Tenta converter para int, ou retorna null se não for possível
      id: json['id'] is int ? json['id'] : (json['id'] != null ? int.tryParse(json['id'].toString()) : null),
      nome: json['nome'] ?? '',
      periodo: json['periodo'] ?? '',
      curso: json['curso'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'nome': nome,
      'periodo': periodo,
      'curso': curso,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TurmaDTO && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
