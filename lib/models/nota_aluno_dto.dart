class NotaAlunoDetalheDTO {
  final int provaId;
  final String tituloProva;
  final String nomeDisciplina;
  final String nomeTurma;
  final String bimestre;
  final String dataProva;
  final double notaObtida;

  NotaAlunoDetalheDTO({
    required this.provaId,
    required this.tituloProva,
    required this.nomeDisciplina,
    required this.nomeTurma,
    required this.bimestre,
    required this.dataProva,
    required this.notaObtida,
  });

  factory NotaAlunoDetalheDTO.fromJson(Map<String, dynamic> json) {
    return NotaAlunoDetalheDTO(
      provaId: json['provaId'],
      tituloProva: json['tituloProva'] ?? '',
      nomeDisciplina: json['nomeDisciplina'] ?? '',
      nomeTurma: json['nomeTurma'] ?? '',
      bimestre: json['bimestre'] ?? '',
      dataProva: json['dataProva'] ?? '',
      notaObtida: (json['notaObtida'] ?? 0).toDouble(),
    );
  }
}
