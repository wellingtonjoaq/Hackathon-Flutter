import 'package:flutter/material.dart';
import 'aluno_lista.dart'; // Para acessar o modelo Aluno

class RespostasTela extends StatefulWidget {
  final Aluno aluno;

  const RespostasTela({super.key, required this.aluno});

  @override
  State<RespostasTela> createState() => _RespostasTelaState();
}

class _RespostasTelaState extends State<RespostasTela> {
  // Mock de perguntas e opções
  final List<Map<String, dynamic>> perguntas = [
    {
      'pergunta': 'Qual a capital do Brasil?',
      'opcoes': ['São Paulo', 'Brasília', 'Rio de Janeiro', 'Salvador'],
    },
    {
      'pergunta': 'Quanto é 2 + 2?',
      'opcoes': ['3', '4', '5', '6'],
    },
    {
      'pergunta': 'Flutter é um framework para qual linguagem?',
      'opcoes': ['Java', 'Dart', 'Python', 'C#'],
    },
  ];

  // Guarda a resposta selecionada para cada pergunta (índice da opção)
  Map<int, int> respostasSelecionadas = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Respostas de ${widget.aluno.nome}'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: perguntas.length,
        itemBuilder: (context, index) {
          final pergunta = perguntas[index];
          final opcoes = pergunta['opcoes'] as List<String>;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Q${index + 1}: ${pergunta['pergunta']}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  ...List.generate(opcoes.length, (opIndex) {
                    return RadioListTile<int>(
                      title: Text(opcoes[opIndex]),
                      value: opIndex,
                      groupValue: respostasSelecionadas[index],
                      onChanged: (value) {
                        setState(() {
                          respostasSelecionadas[index] = value!;
                        });
                      },
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            if (respostasSelecionadas.length < perguntas.length) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Por favor, responda todas as perguntas')),
              );
              return;
            }

            // Aqui você pode enviar as respostas para API futuramente

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Respostas enviadas com sucesso!')),
            );

            Navigator.pop(context); // Voltar para a lista de alunos
          },
          child: const Text('Enviar Respostas'),
        ),
      ),
    );
  }
}
