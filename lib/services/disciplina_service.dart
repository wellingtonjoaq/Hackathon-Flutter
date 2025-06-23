import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/disciplina_dto.dart';

class DisciplinaService {
  final String baseUrl = 'http://localhost:8080/api';


  Future<List<DisciplinaDTO>> listarDisciplinas() async {
    final response = await http.get(Uri.parse('$baseUrl/disciplinas'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => DisciplinaDTO.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar disciplinas');
    }
  }
}
