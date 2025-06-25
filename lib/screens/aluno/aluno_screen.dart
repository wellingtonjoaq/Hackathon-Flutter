import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/nota_aluno_dto.dart';
import '../../models/usuario_dto.dart';
import '../../services/api_service.dart';
import '../../services/local_storage_service.dart';

class AlunoScreen extends StatefulWidget {
  final UsuarioDTO usuario;

  const AlunoScreen({super.key, required this.usuario});

  @override
  State<AlunoScreen> createState() => _AlunoScreenState();
}

class _AlunoScreenState extends State<AlunoScreen> {
  late Future<List<NotaAlunoDetalheDTO>> _notasFuture;

  @override
  void initState() {
    super.initState();
    _notasFuture = ApiService().fetchNotasAluno(widget.usuario.id);
  }

  double calcularMediaPorBimestre(List<NotaAlunoDetalheDTO> notas, String bimestre) {
    final notasBimestre = notas.where((n) => n.bimestre.toUpperCase() == bimestre.toUpperCase()).toList();
    if (notasBimestre.isEmpty) return 0.0;
    final total = notasBimestre.map((n) => n.notaObtida).reduce((a, b) => a + b);
    return total / notasBimestre.length;
  }

  double calcularMediaGeral(List<NotaAlunoDetalheDTO> notas) {
    if (notas.isEmpty) return 0.0;
    final soma = notas.map((n) => n.notaObtida).reduce((a, b) => a + b);
    return soma / notas.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Área do Aluno'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await LocalStorageService().limparUsuario();
              Navigator.pushReplacementNamed(context, '/login');
            },
            tooltip: 'Logout',
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text(
                'Painel do Aluno',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Notas'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.feedback),
              title: Text('Feedbacks'),
              onTap: () {
                Navigator.pushNamed(context, '/aluno/feedbacks', arguments: widget.usuario);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<NotaAlunoDetalheDTO>>(
          future: _notasFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            }

            final notas = snapshot.data ?? [];

            if (notas.isEmpty) {
              return const Center(child: Text('Nenhuma nota encontrada.'));
            }

            final mediaPrimeiro = calcularMediaPorBimestre(notas, 'PRIMEIRO');
            final mediaSegundo = calcularMediaPorBimestre(notas, 'SEGUNDO');
            final mediaGeral = calcularMediaGeral(notas);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bem-vindo, ${widget.usuario.nome} (Aluno)',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Minhas Notas:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.separated(
                    itemCount: notas.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final nota = notas[index];
                      return ListTile(
                        title: Text('${nota.tituloProva} (${nota.nomeDisciplina})'),
                        subtitle: Text(
                          'Turma: ${nota.nomeTurma} | ${nota.bimestre} | ${nota.dataProva}',
                        ),
                        trailing: Text(
                          NumberFormat('0.00').format(nota.notaObtida),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nota do 1º Bimestre: ${NumberFormat('0.00').format(mediaPrimeiro)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Nota do 2º Bimestre: ${NumberFormat('0.00').format(mediaSegundo)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Divider(),
                      Text(
                        'Média Geral: ${NumberFormat('0.00').format(mediaGeral)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
