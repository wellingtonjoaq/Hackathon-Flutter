class GabaritoDTO {
  int numeroQuestao;
  String respostaCorreta;

  GabaritoDTO({
    required this.numeroQuestao,
    required this.respostaCorreta,
  });

  factory GabaritoDTO.fromJson(Map<String, dynamic> json) {
    return GabaritoDTO(
      numeroQuestao: json['numeroQuestao'],
      respostaCorreta: json['respostaCorreta'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numeroQuestao': numeroQuestao,
      'respostaCorreta': respostaCorreta,
    };
  }
}
