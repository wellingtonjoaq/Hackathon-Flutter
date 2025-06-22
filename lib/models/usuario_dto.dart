class UsuarioDTO {
  final int id;
  final String nome;
  final String email;
  final String perfil;

  UsuarioDTO({
    required this.id,
    required this.nome,
    required this.email,
    required this.perfil,
  });

  factory UsuarioDTO.fromJson(Map<String, dynamic> json) {
    return UsuarioDTO(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      perfil: json['perfil'] != null ? json['perfil'].toString() : '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'perfil': perfil,
    };
  }
}
