class GabaritoDTO {
  int? id;
  final int numeroQuestao;
  final String respostaCorreta;

  GabaritoDTO({
    this.id,
    required this.numeroQuestao,
    required this.respostaCorreta,
  });

  factory GabaritoDTO.fromJson(Map<String, dynamic> json) {
    return GabaritoDTO(
      id: json['id'] is int ? json['id'] : (json['id'] != null ? int.tryParse(json['id'].toString()) : null),
      numeroQuestao: json['numeroQuestao'] as int,
      respostaCorreta: json['respostaCorreta'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'numeroQuestao': numeroQuestao,
      'respostaCorreta': respostaCorreta,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}