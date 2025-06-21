import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario_dto.dart';

class ApiService {
  // Substitua pelo seu IP real da rede local
  static const String baseUrl = 'http://192.168.3.6:8080';

  Future<UsuarioDTO?> login(String email, String senha) async {
    final url = Uri.parse('$baseUrl/api/login'); // <- CORRIGIDO

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'senha': senha,
        }),
      );

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          final usuario = UsuarioDTO.fromJson(data);
          print('Usuário logado: ${usuario.nome}, ${usuario.email}, perfil: ${usuario.perfil}');
          return usuario;
        } catch (e) {
          print('Erro ao processar JSON de login: $e');
          return null;
        }
      } else if (response.statusCode == 401) {
        print('Credenciais inválidas');
        return null;
      } else {
        print('Erro inesperado: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erro no login: $e');
      return null;
    }
  }
}
