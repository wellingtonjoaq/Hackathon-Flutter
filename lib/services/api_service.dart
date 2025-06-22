import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario_dto.dart';

class ApiService {
  // Altere para o IP do seu servidor local, se necessário
  static const String baseUrl = 'http://192.168.3.6:8080';

  Future<UsuarioDTO?> login(String email, String senha) async {
    final url = Uri.parse('$baseUrl/api/login');

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
          final Map<String, dynamic> data = jsonDecode(response.body);
          final usuario = UsuarioDTO.fromJson(data);
          print('[LOGIN OK] Usuário: ${usuario.nome}, Perfil: ${usuario.perfil}');
          return usuario;
        } catch (e) {
          print('[ERRO JSON] Erro ao processar resposta do servidor: $e');
          return null;
        }
      } else if (response.statusCode == 401) {
        print('[ERRO LOGIN] Credenciais inválidas');
        return null;
      } else {
        print('[ERRO HTTP] Código: ${response.statusCode} - Corpo: ${response.body}');
        return null;
      }
    } catch (e) {
      print('[EXCEÇÃO] Falha na conexão com o servidor: $e');
      return null;
    }
  }
}
