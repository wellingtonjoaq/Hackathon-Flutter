import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/feedback_dto.dart';
import '../../models/usuario_dto.dart';
import '../../services/api_service.dart';
import '../../services/local_storage_service.dart';
import 'aluno_screen.dart';

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
    _feedbacksFuture = ApiService().fetchFeedbacksAluno(widget.usuario.id);
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
    Navigator.pop(context); // Fecha o drawer
  }

  void _logout() async {
    await LocalStorageService().limparUsuario();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedbacks das Provas'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(widget.usuario.nome),
              accountEmail: Text(widget.usuario.email),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.blue),
              ),
              decoration: const BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Notas'),
              onTap: _navegarParaNotas,
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Feedbacks'),
              selected: true,
              selectedTileColor: Colors.blue.shade100,
              onTap: _navegarParaFeedbacks,
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<FeedbackDTO>>(
        future: _feedbacksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final feedbacks = snapshot.data ?? [];

          if (feedbacks.isEmpty) {
            return const Center(child: Text('Nenhum feedback disponível.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: feedbacks.length,
            itemBuilder: (context, index) {
              final feedback = feedbacks[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 20),
                elevation: 4,
                child: ExpansionTile(
                  title: Text('${feedback.tituloProva} - ${feedback.nomeDisciplina}'),
                  subtitle: Text('${feedback.nomeTurma} | ${feedback.dataProva}'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            'Nota Final: ${NumberFormat('0.00').format(feedback.notaFinal)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Divider(),
                          const Text('Questões:'),
                          const SizedBox(height: 8),
                          ...feedback.questoes.map((q) => ListTile(
                            leading: CircleAvatar(
                              backgroundColor: q.correta ? Colors.green : Colors.red,
                              child: Text(
                                q.numeroQuestao.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text('Sua resposta: ${q.respostaDadaAluno}'),
                            subtitle: Text('Correta: ${q.respostaCorreta}'),
                            trailing: q.correta
                                ? const Icon(Icons.check, color: Colors.green)
                                : const Icon(Icons.close, color: Colors.red),
                          )),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
