import 'package:flutter/material.dart';
import 'respostas_tela.dart'; // Importe a tela de respostas

// Modelo simples do aluno
class Aluno {
  final String id;
  final String nome;
  final String turma;

  Aluno({required this.id, required this.nome, required this.turma});
}

class AlunoListaTela extends StatelessWidget {
  AlunoListaTela({super.key});

  // Lista mockada de alunos
  final List<Aluno> alunos = [
    Aluno(id: '1', nome: 'Gabriel Henrique', turma: '3º Ano'),
    Aluno(id: '2', nome: 'Maria Silva', turma: '2º Ano'),
    Aluno(id: '3', nome: 'João Pedro', turma: '3º Ano'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecione o Aluno'),
      ),
      body: ListView.builder(
        itemCount: alunos.length,
        itemBuilder: (context, index) {
          final aluno = alunos[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(aluno.nome),
              subtitle: Text('Turma: ${aluno.turma}'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RespostasTela(aluno: aluno),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
