import 'package:flutter/material.dart';
import '../models/aluno_dto.dart';
import '../services/aluno_service.dart';

class SelecionarAlunoScreen extends StatefulWidget {
  const SelecionarAlunoScreen({super.key});

  @override
  State<SelecionarAlunoScreen> createState() => _SelecionarAlunoScreenState();
}

class _SelecionarAlunoScreenState extends State<SelecionarAlunoScreen> {
  late Future<List<AlunoDTO>> _alunosFuture;

  @override
  void initState() {
    super.initState();
    _alunosFuture = AlunoService().listarAlunos(); // Busca alunos da API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Aluno'),
      ),
      body: FutureBuilder<List<AlunoDTO>>(
        future: _alunosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar alunos: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum aluno encontrado.'));
          } else {
            final alunos = snapshot.data!;
            return ListView.builder(
              itemCount: alunos.length,
              itemBuilder: (context, index) {
                final aluno = alunos[index];
                return ListTile(
                  title: Text(aluno.nome),
                  subtitle: Text('Matrícula: ${aluno.matricula}'),
                  onTap: () {
                    // Navega para a tela de responder avaliação passando o aluno selecionado
                    Navigator.pushNamed(context, '/responderAvaliacao', arguments: aluno);
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final codigoEscaneado = await Navigator.pushNamed(context, '/scannerAluno');
          if (codigoEscaneado != null && codigoEscaneado is String) {
            // Aqui você pode buscar o aluno pelo código (matrícula ou ID) retornado do scanner
            // Por enquanto, vamos só exibir um Snackbar como exemplo
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Código escaneado: $codigoEscaneado')),
            );
          }
        },
        child: const Icon(Icons.camera_alt),
        tooltip: 'Ler aluno pela câmera',
      ),
    );
  }
}
