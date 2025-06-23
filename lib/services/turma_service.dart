import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/turma_dto.dart';

class TurmaService {
  final String baseUrl = 'http://localhost:8080/api';

  Future<List<TurmaDTO>> listarTurmas() async {
    final response = await http.get(Uri.parse('$baseUrl/turmas'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => TurmaDTO.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar turmas: ${response.statusCode} - ${response.body}');
    }
  }
}
