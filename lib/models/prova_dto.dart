import 'package:hackathon_flutter/models/gabarito_dto.dart';
import 'package:hackathon_flutter/models/bimestre.dart';

class ProvaDTO {
  final int? id;
  final String titulo;
  final DateTime data;
  final int turmaId;
  final int disciplinaId;
  final Bimestre bimestre;
  final String? nomeTurma;
  final String? nomeDisciplina;
  final List<GabaritoDTO> gabarito;

  ProvaDTO({
    this.id,
    required this.titulo,
    required this.data,
    required this.turmaId,
    required this.disciplinaId,
    required this.bimestre,
    this.nomeTurma,
    this.nomeDisciplina,
    required this.gabarito,
  });

  factory ProvaDTO.fromJson(Map<String, dynamic> json) {
    return ProvaDTO(
      id: json['id'] is int ? json['id'] : (json['id'] != null ? int.tryParse(json['id'].toString()) : null),
      titulo: json['titulo'] as String,
      data: DateTime.parse(json['data'] as String),
      turmaId: json['turmaId'] as int,
      disciplinaId: json['disciplinaId'] as int,
      bimestre: Bimestre.fromString(json['bimestre'] as String),
      nomeTurma: json['nomeTurma'] as String?,
      nomeDisciplina: json['nomeDisciplina'] as String?,
      gabarito: (json['gabarito'] as List<dynamic>?)
          ?.map((e) => GabaritoDTO.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'data': data.toIso8601String().split('T').first,
      'turmaId': turmaId,
      'disciplinaId': disciplinaId,
      'bimestre': bimestre.toString().split('.').last,
      'gabarito': gabarito.map((g) => g.toJson()).toList(),
    };
  }
}