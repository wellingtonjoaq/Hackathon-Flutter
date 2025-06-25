class UsuarioDTO {
  final int? id;
  final String nome;
  final String email;
  final String? senha;
  final String perfil;

  final int? turmaId;

  UsuarioDTO({
    this.id,
    required this.nome,
    required this.email,
    this.senha,
    required this.perfil,
    this.turmaId,
  });

  factory UsuarioDTO.fromJson(Map<String, dynamic> json) {
    return UsuarioDTO(
      id: json['id'] is int
          ? json['id']
          : (json['id'] != null ? int.tryParse(json['id'].toString()) : null),
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      perfil: json['perfil'] != null ? json['perfil'].toString() : '',
      turmaId: json['turmaId'] is int
          ? json['turmaId']
          : (json['turmaId'] != null ? int.tryParse(json['turmaId'].toString()) : null),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'nome': nome,
      'email': email,
      'perfil': perfil,
    };
    if (id != null) {
      data['id'] = id;
    }
    if (senha != null && senha!.isNotEmpty) {
      data['senha'] = senha;
    }
    if (turmaId != null) {
      data['turmaId'] = turmaId;
    }
    return data;
  }
}