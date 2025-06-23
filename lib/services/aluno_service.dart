import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/aluno_dto.dart';

class AlunoService {
  // Atualize o IP para o IP local da sua máquina se usar em dispositivo físico/emulador
  final String baseUrl = 'http://10.0.2.2:8080/api';

  Future<List<AlunoDTO>> listarAlunos() async {
    final response = await http.get(Uri.parse('$baseUrl/alunos'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => AlunoDTO.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar alunos. Status: ${response.statusCode}');
    }
  }
}
