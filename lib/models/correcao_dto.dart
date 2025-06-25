class CorrecaoDTO {
  final int? id;
  final int alunoId;
  final String alunoNome;
  final int provaId;
  final String provaTitulo;
  final double nota;
  final List<RespostaQuestaoDTO> detalhes;

  CorrecaoDTO({
    this.id,
    required this.alunoId,
    required this.alunoNome,
    required this.provaId,
    required this.provaTitulo,
    required this.nota,
    required this.detalhes,
  });

  factory CorrecaoDTO.fromJson(Map<String, dynamic> json) {
    return CorrecaoDTO(
      id: json['id'],
      alunoId: json['alunoId'],
      alunoNome: json['alunoNome'],
      provaId: json['provaId'],
      provaTitulo: json['provaTitulo'],
      nota: (json['nota'] as num).toDouble(),
      detalhes: (json['detalhes'] as List<dynamic>)
          .map((d) => RespostaQuestaoDTO.fromJson(d))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'alunoId': alunoId,
      'provaId': provaId,
      'nota': nota,
      'detalhes': detalhes.map((r) => r.toJson()).toList(),
    };
  }
}

class RespostaQuestaoDTO {
  final int numeroQuestao;
  final String resposta;
  final String respostaCorreta;
  final bool correta;

  RespostaQuestaoDTO({
    required this.numeroQuestao,
    required this.resposta,
    required this.respostaCorreta,
    required this.correta,
  });

  factory RespostaQuestaoDTO.fromJson(Map<String, dynamic> json) {
    return RespostaQuestaoDTO(
      numeroQuestao: json['numeroQuestao'],
      resposta: json['resposta'],
      respostaCorreta: json['respostaCorreta'],
      correta: json['correta'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numeroQuestao': numeroQuestao,
      'resposta': resposta,
      'respostaCorreta': respostaCorreta,
      'correta': correta,
    };
  }
}
