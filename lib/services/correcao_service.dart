import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/correcao_dto.dart';

class CorrecaoService {
  final String baseUrl = 'http://localhost:8080/api';

  /// Buscar correções com filtros opcionais
  Future<List<CorrecaoDTO>> buscarCorrecoes({int? alunoId, int? provaId}) async {
    final queryParams = <String, String>{};
    if (alunoId != null) queryParams['alunoId'] = alunoId.toString();
    if (provaId != null) queryParams['provaId'] = provaId.toString();

    final uri = Uri.parse('$baseUrl/respostas').replace(queryParameters: queryParams);

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => CorrecaoDTO.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar correções: ${response.body}');
    }
  }

  /// Excluir correção por ID
  Future<void> excluirCorrecao(int? id) async {
    if (id == null) throw Exception('ID inválido para exclusão');

    final uri = Uri.parse('$baseUrl/respostas/$id');
    final response = await http.delete(uri);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Erro ao excluir correção: ${response.body}');
    }
  }

  /// Criar uma nova correção (caso queira usar)
  Future<void> criarCorrecao(CorrecaoDTO dto) async {
    final uri = Uri.parse('$baseUrl/respostas');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erro ao criar correção: ${response.body}');
    }
  }
}
