import 'gabarito_dto.dart';

class ProvaDTO {
  final int? id;
  final String titulo;
  final int turmaId;
  final int disciplinaId;
  final String data;
  final int bimestre; // <-- Adicionado
  final String? turmaNome;
  final String? disciplinaNome;
  final List<GabaritoDTO>? gabarito;

  ProvaDTO({
    this.id,
    required this.titulo,
    required this.turmaId,
    required this.disciplinaId,
    required this.data,
    required this.bimestre, // <-- Adicionado
    this.turmaNome,
    this.disciplinaNome,
    this.gabarito,
  });

  // Envio para backend
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'turmaId': turmaId,
      'disciplinaId': disciplinaId,
      'data': data,
      'bimestre': bimestre, // <-- Adicionado
      'gabarito': gabarito?.map((g) => g.toJson()).toList(),
    };
  }

  // Leitura do backend
  factory ProvaDTO.fromJson(Map<String, dynamic> json) {
    return ProvaDTO(
      id: json['id'],
      titulo: json['titulo'],
      turmaId: json['turma']['id'],
      disciplinaId: json['disciplina']['id'],
      data: json['data'],
      bimestre: json['bimestre'] ?? 1, // <-- Adicionado (valor padrão 1 se não vier)
      turmaNome: json['turma']['nome'],
      disciplinaNome: json['disciplina']['nome'],
      gabarito: (json['gabarito'] as List<dynamic>?)
          ?.map((e) => GabaritoDTO.fromJson(e))
          .toList(),
    );
  }
}
