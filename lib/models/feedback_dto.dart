import 'feedback_questao_dto.dart';

class FeedbackDTO {
  final int? provaId;
  final String tituloProva;
  final String nomeDisciplina;
  final String nomeTurma;
  final String dataProva;
  final double? notaFinal;

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
    final int? parsedProvaId = json['provaId'] is int
        ? json['provaId']
        : (json['provaId'] is double
        ? json['provaId']?.toInt()
        : (json['provaId'] != null ? int.tryParse(json['provaId'].toString()) : null));

    double? parsedNotaFinal;
    if (json['notaFinal'] is int) {
      parsedNotaFinal = json['notaFinal'].toDouble();
    } else if (json['notaFinal'] is double) {
      parsedNotaFinal = json['notaFinal'];
    } else if (json['notaFinal'] != null) {
      parsedNotaFinal = double.tryParse(json['notaFinal'].toString());
    }


    return FeedbackDTO(
      provaId: parsedProvaId,
      tituloProva: json['tituloProva'] as String,
      nomeDisciplina: json['nomeDisciplina'] as String,
      nomeTurma: json['nomeTurma'] as String,
      dataProva: json['dataProva'] as String,
      notaFinal: parsedNotaFinal,
      questoes: (json['questoes'] as List<dynamic>?)
          ?.map((e) => FeedbackQuestaoDTO.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}