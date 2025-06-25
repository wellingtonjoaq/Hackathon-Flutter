import 'dart:convert';
import 'package:hackathon_flutter/widgets/disciplines_admin_page.dart';
import 'package:http/http.dart' as http;
import '../models/disciplina_dto.dart';

class DisciplinaService {
  final String baseUrl = 'http://192.168.0.122:8080/api';

  Future<List<DisciplinaDTO>> listarDisciplinas() async {
    final response = await http.get(Uri.parse('$baseUrl/disciplinas'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => DisciplinaDTO.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar disciplinas');
    }
  }

  Future<void> deleteDisciplina(param0) async {}

  Future<List<DisciplinaDTO>> getDisciplinas() async {
    final response = await http.get(Uri.parse('$baseUrl/disciplinas'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => DisciplinaDTO.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar disciplinas');
    }
  }
}
