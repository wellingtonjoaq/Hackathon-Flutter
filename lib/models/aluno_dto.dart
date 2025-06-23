import 'dart:convert';

class AlunoDTO {
  final int id;
  final String nome;
  final String matricula;
  final String? email; // Opcional

  AlunoDTO({
    required this.id,
    required this.nome,
    required this.matricula,
    this.email,
  });

  factory AlunoDTO.fromJson(Map<String, dynamic> json) {
    return AlunoDTO(
      id: json['id'],
      nome: json['nome'],
      matricula: json['matricula'],
      email: json['email'], // Pode ser nulo
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'matricula': matricula,
      'email': email,
    };
  }

  @override
  String toString() =>
      'AlunoDTO(id: $id, nome: $nome, matricula: $matricula, email: $email)';
}
