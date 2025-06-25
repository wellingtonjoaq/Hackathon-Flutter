import 'dart:convert';

import 'package:hackathon_flutter/models/usuario_dto.dart';
import 'package:http/http.dart' as http;

class UsuarioService {

  final String baseUrl = 'http://192.168.0.122:8080/api';

  Future<void> deleteUsuario(param0) async {}

  Future<List<UsuarioDTO>> getUsuarios() async {
    final response = await http.get(Uri.parse('$baseUrl/provas')); // URL corrigida para plural "provas"

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => UsuarioDTO.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar provas: ${response.body}');
    }
  }
  }
