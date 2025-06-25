import 'feedback_questao_dto.dart';

class FeedbackDTO {
  final int provaId;
  final String tituloProva;
  final String nomeDisciplina;
  final String nomeTurma;
  final String dataProva;
  final double notaFinal;
  final List<FeedbackQuestaoDTO> questoes;

  FeedbackDTO({
    required this.provaId,
    required this.tituloProva,
    required this.nomeDisciplina,
    required this.nomeTurma,
    required this.dataProva,
    required this.notaFinal,
    required this.questoes,
  });

  factory FeedbackDTO.fromJson(Map<String, dynamic> json) {
    return FeedbackDTO(
      provaId: json['provaId'],
      tituloProva: json['tituloProva'],
      nomeDisciplina: json['nomeDisciplina'],
      nomeTurma: json['nomeTurma'],
      dataProva: json['dataProva'],
      notaFinal: json['notaFinal'].toDouble(),
      questoes: (json['questoes'] as List)
          .map((e) => FeedbackQuestaoDTO.fromJson(e))
          .toList(),
    );
  }
}
