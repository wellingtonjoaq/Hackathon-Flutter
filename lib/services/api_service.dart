import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/aluno_dto.dart';
import '../models/bimestre.dart';
import '../models/disciplina_dto.dart';
import '../models/feedback_dto.dart';
import '../models/nota_aluno_dto.dart';
import '../models/prova_dto.dart';
import '../models/turma_dto.dart';
import '../models/usuario_dto.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.0.158:8080';

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
          print('Usuário: ${usuario.nome}, Perfil: ${usuario.perfil}');
          return usuario;
        } catch (e) {
          print('Erro ao processar resposta do servidor: $e');
          return null;
        }
      } else if (response.statusCode == 401) {
        print('Credenciais inválidas');
        return null;
      } else {
        print('Código: ${response.statusCode} - Corpo: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Falha na conexão com o servidor: $e');
      return null;
    }
  }

  Future<List<NotaAlunoDetalheDTO>> fetchNotasAluno(int alunoId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/aluno/notas/$alunoId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((e) => NotaAlunoDetalheDTO.fromJson(e)).toList();
    } else {
      throw Exception('Falha ao buscar notas do aluno: ${response.statusCode}');
    }
  }

  Future<List<FeedbackDTO>> fetchFeedbacksAluno(int alunoId) async {
    final url = Uri.parse('$baseUrl/api/aluno/$alunoId/feedbacks');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => FeedbackDTO.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar feedbacks: ${response.statusCode}');
    }
  }

  Future<List<UsuarioDTO>> fetchUsuarios() async {
    final url = Uri.parse('$baseUrl/api/usuarios');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => UsuarioDTO.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar usuários: ${response.statusCode}');
    }
  }

  Future<UsuarioDTO> addUsuario(UsuarioDTO usuario) async {
    final url = Uri.parse('$baseUrl/api/usuarios');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuario.toJson()),
    );

    if (response.statusCode == 201) {
      return UsuarioDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao adicionar usuário: ${response.statusCode} - ${response.body}');
    }
  }

  Future<UsuarioDTO> updateUsuario(UsuarioDTO usuario) async {
    final url = Uri.parse('$baseUrl/api/usuarios/${usuario.id}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuario.toJson()),
    );

    if (response.statusCode == 200) {
      return UsuarioDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao atualizar usuário: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> deleteUsuario(int id) async {
    final url = Uri.parse('$baseUrl/api/usuarios/$id');
    final response = await http.delete(url);

    if (response.statusCode != 204) {
      throw Exception('Falha ao excluir usuário: ${response.statusCode}');
    }
  }

  Future<List<TurmaDTO>> fetchTurmas() async {
    final url = Uri.parse('$baseUrl/api/turmas');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => TurmaDTO.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar turmas: ${response.statusCode}');
    }
  }

  Future<List<DisciplinaDTO>> fetchDisciplinas({String? nome, String? professorNome, int? professorId}) async {
    final Map<String, String> queryParams = {};
    if (nome != null && nome.isNotEmpty) {
      queryParams['nome'] = nome;
    }
    if (professorNome != null && professorNome.isNotEmpty) {
      queryParams['professor'] = professorNome;
    }
    if (professorId != null) {
      queryParams['professorId'] = professorId.toString();
    }

    final uri = Uri.parse('$baseUrl/api/disciplinas').replace(queryParameters: queryParams);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => DisciplinaDTO.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar disciplinas: ${response.statusCode}');
    }
  }

  Future<DisciplinaDTO> addDisciplina(DisciplinaDTO disciplina) async {
    final url = Uri.parse('$baseUrl/api/disciplinas');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(disciplina.toJson()),
    );

    if (response.statusCode == 201) {
      return DisciplinaDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao adicionar disciplina: ${response.statusCode} - ${response.body}');
    }
  }

  Future<DisciplinaDTO> updateDisciplina(DisciplinaDTO disciplina) async {
    final url = Uri.parse('$baseUrl/api/disciplinas/${disciplina.id}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(disciplina.toJson()),
    );

    if (response.statusCode == 200) {
      return DisciplinaDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao atualizar disciplina: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> deleteDisciplina(int id) async {
    final url = Uri.parse('$baseUrl/api/disciplinas/$id');
    final response = await http.delete(url);

    if (response.statusCode != 204) {
      throw Exception('Falha ao excluir disciplina: ${response.statusCode}');
    }
  }

  Future<List<TurmaDTO>> fetchTurmasAdmin({String? nome, String? periodo, String? curso}) async {
    final Map<String, String> queryParams = {};
    if (nome != null && nome.isNotEmpty) {
      queryParams['nome'] = nome;
    }
    if (periodo != null && periodo.isNotEmpty) {
      queryParams['periodo'] = periodo;
    }
    if (curso != null && curso.isNotEmpty) {
      queryParams['curso'] = curso;
    }

    final uri = Uri.parse('$baseUrl/api/turmas').replace(queryParameters: queryParams);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => TurmaDTO.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar turmas: ${response.statusCode}');
    }
  }

  Future<TurmaDTO> addTurma(TurmaDTO turma) async {
    final url = Uri.parse('$baseUrl/api/turmas');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(turma.toJson()),
    );

    if (response.statusCode == 201) {
      return TurmaDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao adicionar turma: ${response.statusCode} - ${response.body}');
    }
  }

  Future<TurmaDTO> updateTurma(TurmaDTO turma) async {
    final url = Uri.parse('$baseUrl/api/turmas/${turma.id}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(turma.toJson()),
    );

    if (response.statusCode == 200) {
      return TurmaDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao atualizar turma: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> deleteTurma(int id) async {
    final url = Uri.parse('$baseUrl/api/turmas/$id');
    final response = await http.delete(url);

    if (response.statusCode != 204) {
      throw Exception('Falha ao excluir turma: ${response.statusCode}');
    }
  }

  Future<List<String>> fetchPeriodosUnicos() async {
    final url = Uri.parse('$baseUrl/api/turmas/periodos');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((e) => e.toString()).toList();
    } else {
      throw Exception('Falha ao carregar períodos: ${response.statusCode}');
    }
  }

  Future<List<String>> fetchCursosUnicos() async {
    final url = Uri.parse('$baseUrl/api/turmas/cursos');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((e) => e.toString()).toList();
    } else {
      throw Exception('Falha ao carregar cursos: ${response.statusCode}');
    }
  }

  Future<List<ProvaDTO>> fetchProvas({
    int? turmaId,
    int? disciplinaId,
    Bimestre? bimestre,
    DateTime? data,
    int? professorId,
  }) async {
    final Map<String, String> queryParams = {};
    if (turmaId != null) queryParams['turmaId'] = turmaId.toString();
    if (disciplinaId != null) queryParams['disciplinaId'] = disciplinaId.toString();
    if (bimestre != null) queryParams['bimestre'] = bimestre.toString().split('.').last;
    if (data != null) queryParams['data'] = data.toIso8601String().split('T').first;
    if (professorId != null) queryParams['professorId'] = professorId.toString();

    final uri = Uri.parse('$baseUrl/api/provas').replace(queryParameters: queryParams);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => ProvaDTO.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar provas: ${response.statusCode} - ${response.body}');
    }
  }

  Future<ProvaDTO> addProva(ProvaDTO prova) async {
    final url = Uri.parse('$baseUrl/api/provas');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(prova.toJson()),
    );

    if (response.statusCode == 201) {
      return ProvaDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao adicionar prova: ${response.statusCode} - ${response.body}');
    }
  }

  Future<ProvaDTO> updateProva(ProvaDTO prova) async {
    final url = Uri.parse('$baseUrl/api/provas/${prova.id}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(prova.toJson()),
    );

    if (response.statusCode == 200) {
      return ProvaDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao atualizar prova: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> deleteProva(int id) async {
    final url = Uri.parse('$baseUrl/api/provas/$id');
    final response = await http.delete(url);

    if (response.statusCode != 204) {
      throw Exception('Falha ao excluir prova: ${response.statusCode}');
    }
  }
}
