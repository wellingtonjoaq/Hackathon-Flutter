class ProvaDTO {
  final int? id;
  final String titulo;
  final int turmaId;
  final int disciplinaId;
  final String data;

  // Dados adicionais para leitura (opcional, só usados ao listar provas)
  final String? turmaNome;
  final String? disciplinaNome;

  ProvaDTO({
    this.id,
    required this.titulo,
    required this.turmaId,
    required this.disciplinaId,
    required this.data,
    this.turmaNome,
    this.disciplinaNome,
  });

  // Para envio (POST)
  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'turmaId': turmaId,
      'disciplinaId': disciplinaId,
      'data': data,
    };
  }

  // Para leitura (GET)
  factory ProvaDTO.fromJson(Map<String, dynamic> json) {
    return ProvaDTO(
      id: json['id'],
      titulo: json['titulo'],
      turmaId: json['turma']['id'],
      disciplinaId: json['disciplina']['id'],
      data: json['data'],
      turmaNome: json['turma']['titulo'],
      disciplinaNome: json['disciplina']['titulo'],
    );
  }
}
