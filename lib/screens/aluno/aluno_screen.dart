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
    _notasFuture = ApiService().fetchNotasAluno(widget.usuario.id!);
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
        title: const Text(
          'Minhas Notas',
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
            onPressed: () async {
              await LocalStorageService().limparUsuario();
              Navigator.pushReplacementNamed(context, '/login');
            },
            tooltip: 'Sair da conta',
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
              leading: const Icon(Icons.bar_chart, color: Colors.indigo),
              title: const Text('Notas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              selected: true, // Indica que este item está selecionado
              selectedTileColor: Colors.indigo.shade50,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback, color: Colors.grey),
              title: const Text('Feedbacks', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/aluno/feedbacks', arguments: widget.usuario);
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<NotaAlunoDetalheDTO>>(
            future: _notasFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.indigo));
              } else if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Erro ao carregar notas: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                    ),
                  ),
                );
              }

              final notas = snapshot.data ?? [];

              if (notas.isEmpty) {
                return const Center(
                  child: Text(
                    'Nenhuma nota encontrada no momento.',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                );
              }

              final mediaPrimeiro = calcularMediaPorBimestre(notas, 'PRIMEIRO');
              final mediaSegundo = calcularMediaPorBimestre(notas, 'SEGUNDO');
              final mediaGeral = calcularMediaGeral(notas);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bem-vindo(a), ${widget.usuario.nome}!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade800,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Visão Geral das Notas:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Card(
                    margin: const EdgeInsets.only(bottom: 20),
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildAverageRow('1º Bimestre:', mediaPrimeiro, Colors.orange),
                          const Divider(height: 20, thickness: 1, color: Colors.grey),
                          _buildAverageRow('2º Bimestre:', mediaSegundo, Colors.blue),
                          const Divider(height: 20, thickness: 1, color: Colors.grey),
                          _buildAverageRow('Média Geral:', mediaGeral, Colors.deepPurple, isBold: true),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Detalhes das Provas:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: ListView.separated(
                      itemCount: notas.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final nota = notas[index];
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            title: Text(
                              '${nota.tituloProva} - ${nota.nomeDisciplina}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.indigo,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                'Turma: ${nota.nomeTurma} | Bimestre: ${nota.bimestre} | Data: ${nota.dataProva}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: nota.notaObtida >= 7.0 ? Colors.green.shade100 : Colors.red.shade100,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: nota.notaObtida >= 7.0 ? Colors.green.shade200 : Colors.red.shade200,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                NumberFormat('0.00').format(nota.notaObtida),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: nota.notaObtida >= 7.0 ? Colors.green.shade800 : Colors.red.shade800,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Helper para construir as linhas de média no resumo (reutilizado e aprimorado)
  Widget _buildAverageRow(String label, double value, Color color, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 18 : 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? Colors.deepPurple.shade700 : Colors.grey[800],
          ),
        ),
        Text(
          NumberFormat('0.00').format(value),
          style: TextStyle(
            fontSize: isBold ? 18 : 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}