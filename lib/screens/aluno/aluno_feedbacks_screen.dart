import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/feedback_dto.dart';
import '../../models/usuario_dto.dart';
import '../../services/api_service.dart';
import '../../services/local_storage_service.dart';
import 'aluno_screen.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://localhost:8080';

class AlunoFeedbacksScreen extends StatefulWidget {
  final UsuarioDTO usuario;

  const AlunoFeedbacksScreen({super.key, required this.usuario});

  @override
  State<AlunoFeedbacksScreen> createState() => _AlunoFeedbacksScreenState();
}

class _AlunoFeedbacksScreenState extends State<AlunoFeedbacksScreen> {
  late Future<List<FeedbackDTO>> _feedbacksFuture;

  @override
  void initState() {
    super.initState();
    _feedbacksFuture = _fetchFeedbacksAluno(widget.usuario.id!);
  }

  Future<List<FeedbackDTO>> _fetchFeedbacksAluno(int alunoId) async {
    final url = Uri.parse('$baseUrl/api/aluno/$alunoId/feedbacks');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((json) => FeedbackDTO.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar feedbacks: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar feedbacks: $e');
      throw Exception('Não foi possível conectar ao servidor ou buscar feedbacks.');
    }
  }

  void _navegarParaNotas() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => AlunoScreen(usuario: widget.usuario),
      ),
    );
  }

  void _navegarParaFeedbacks() {
    Navigator.pop(context);
  }

  void _logout() async {
    await LocalStorageService().limparUsuario();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meus Feedbacks',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.indigo,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                widget.usuario.nome,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              accountEmail: Text(widget.usuario.email),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.indigo, size: 40),
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart, color: Colors.grey),
              title: const Text('Notas', style: TextStyle(fontSize: 16)),
              onTap: _navegarParaNotas,
            ),
            ListTile(
              leading: const Icon(Icons.feedback, color: Colors.indigo),
              title: const Text('Feedbacks', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              selected: true,
              selectedTileColor: Colors.indigo.shade50,
              onTap: _navegarParaFeedbacks,
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.grey[100],
        child: FutureBuilder<List<FeedbackDTO>>(
          future: _feedbacksFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.indigo));
            } else if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Erro ao carregar feedbacks: ${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                  ),
                ),
              );
            }

            final feedbacks = snapshot.data ?? [];

            if (feedbacks.isEmpty) {
              return const Center(
                child: Text(
                  'Nenhum feedback disponível no momento.',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: feedbacks.length,
              itemBuilder: (context, index) {
                final feedback = feedbacks[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 18),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    collapsedBackgroundColor: Colors.white,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    childrenPadding: const EdgeInsets.all(16),
                    title: Text(
                      '${feedback.tituloProva} - ${feedback.nomeDisciplina}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.indigo,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        '${feedback.nomeTurma} | ${feedback.dataProva}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ),
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            'Nota Final: ${feedback.notaFinal != null ? NumberFormat('0.00').format(feedback.notaFinal) : '-'}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const Divider(height: 25, thickness: 1.5, color: Colors.blueGrey),
                          const Text(
                            'Detalhes das Questões:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.indigo,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: feedback.questoes.length,
                            itemBuilder: (context, qIndex) {
                              final questao = feedback.questoes[qIndex];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: questao.correta ? Colors.green.shade50 : Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: questao.correta ? Colors.green.shade200 : Colors.red.shade200,
                                      width: 1,
                                    ),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    leading: CircleAvatar(
                                      backgroundColor: questao.correta ? Colors.green : Colors.red,
                                      child: Text(
                                        questao.numeroQuestao.toString(),
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    title: Text(
                                      'Sua Resposta: ${questao.respostaDadaAluno}',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w500
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Resposta Correta: ${questao.respostaCorreta}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    trailing: questao.correta
                                        ? const Icon(Icons.check_circle, color: Colors.green, size: 28)
                                        : const Icon(Icons.cancel, color: Colors.red, size: 28),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
