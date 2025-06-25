import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/prova_dto.dart';

class ProvaService {
  final String baseUrl = 'http://localhost:8080/api';



  /// Cria uma nova prova (POST)
  Future<void> criarProva(ProvaDTO prova) async {
    final response = await http.post(
      Uri.parse('$baseUrl/provas'), // URL corrigida para plural "provas"
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(prova.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erro ao criar prova: ${response.body}');
    }
  }

  /// Lista todas as provas (GET)
  Future<List<ProvaDTO>> listarProvas() async {
    final response = await http.get(Uri.parse('$baseUrl/provas')); // URL corrigida para plural "provas"

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ProvaDTO.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar provas: ${response.body}');
    }
  }
}
