// models/feedback_questao_dto.dart
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
      numeroQuestao: json['numeroQuestao'],
      respostaDadaAluno: json['respostaDadaAluno'],
      respostaCorreta: json['respostaCorreta'],
      correta: json['correta'],
    );
  }
}
