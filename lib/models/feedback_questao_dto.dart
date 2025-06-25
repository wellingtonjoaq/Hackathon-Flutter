class FeedbackQuestaoDTO {
  final int numeroQuestao;
  final String respostaDadaAluno;
  final String respostaCorreta;
  final bool correta;

  FeedbackQuestaoDTO({
    required this.numeroQuestao,
    required this.respostaDadaAluno,
    required this.respostaCorreta,
    required this.correta,
  });

  factory FeedbackQuestaoDTO.fromJson(Map<String, dynamic> json) {
    return FeedbackQuestaoDTO(
      numeroQuestao: json['numeroQuestao'] as int,
      respostaDadaAluno: json['respostaDadaAluno'] as String,
      respostaCorreta: json['respostaCorreta'] as String,
      correta: json['correta'] as bool,
    );
  }
}