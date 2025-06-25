enum Bimestre {
  PRIMEIRO,
  SEGUNDO;

  String toDisplayString() {
    switch (this) {
      case Bimestre.PRIMEIRO:
        return 'Primeiro';
      case Bimestre.SEGUNDO:
        return 'Segundo';
    }
  }

  static Bimestre fromString(String value) {
    return Bimestre.values.firstWhere(
          (e) => e.toString().split('.').last == value.toUpperCase(),
      orElse: () => throw Exception('Bimestre inválido: $value'),
    );
  }
}