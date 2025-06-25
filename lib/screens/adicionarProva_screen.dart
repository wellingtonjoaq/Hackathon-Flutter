import 'package:flutter/material.dart';
import '../models/turma_dto.dart';
import '../models/disciplina_dto.dart';
import '../models/prova_dto.dart';
import '../models/gabarito_dto.dart';
import '../services/turma_service.dart';
import '../services/disciplina_service.dart';
import '../services/prova_service.dart';

class AdicionarProvaScreen extends StatefulWidget {
  const AdicionarProvaScreen({super.key});

  @override
  State<AdicionarProvaScreen> createState() => _AdicionarProvaScreenState();
}

class _AdicionarProvaScreenState extends State<AdicionarProvaScreen> {
  final _formKey = GlobalKey<FormState>();

  String? tituloProva;
  TurmaDTO? turmaSelecionada;
  DisciplinaDTO? disciplinaSelecionada;
  DateTime? dataProva;
  int? bimestreSelecionado; // <-- novo campo

  List<TurmaDTO> turmas = [];
  List<DisciplinaDTO> disciplinas = [];

  bool carregando = true;
  bool salvando = false;

  int? numeroQuestao;
  String? respostaCorreta;
  List<Map<String, dynamic>> gabarito = [];

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    try {
      final turmasData = await TurmaService().listarTurmas();
      final disciplinasData = await DisciplinaService().listarDisciplinas();

      setState(() {
        turmas = turmasData;
        disciplinas = disciplinasData;
        carregando = false;
      });
    } catch (e) {
      setState(() => carregando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados: $e')),
      );
    }
  }

  Future<void> salvarProva() async {
    if (!_formKey.currentState!.validate() || dataProva == null || bimestreSelecionado == null) {
      if (dataProva == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecione a data da prova')),
        );
      }
      if (bimestreSelecionado == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecione o bimestre')),
        );
      }
      return;
    }

    _formKey.currentState!.save();

    final novaProva = ProvaDTO(
      titulo: tituloProva!,
      turmaId: turmaSelecionada!.id,
      disciplinaId: disciplinaSelecionada!.id,
      data: dataProva!.toIso8601String().split('T')[0],
      bimestre: bimestreSelecionado!, // <-- novo campo
      gabarito: gabarito.map((q) => GabaritoDTO(
        numeroQuestao: q['numero'],
        respostaCorreta: q['resposta'],
      )).toList(),
    );

    setState(() => salvando = true);

    try {
      await ProvaService().criarProva(novaProva);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Prova criada com sucesso!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => salvando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao criar prova: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Prova')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome da Prova'),
                validator: (value) =>
                (value == null || value.isEmpty) ? 'Informe o título' : null,
                onSaved: (value) => tituloProva = value,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TurmaDTO>(
                decoration: const InputDecoration(labelText: 'Turma'),
                items: turmas.map((turma) {
                  return DropdownMenuItem(
                    value: turma,
                    child: Text(turma.nome),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    turmaSelecionada = value;
                  });
                },
                validator: (value) => value == null ? 'Selecione uma turma' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<DisciplinaDTO>(
                decoration: const InputDecoration(labelText: 'Disciplina'),
                items: disciplinas.map((disciplina) {
                  return DropdownMenuItem(
                    value: disciplina,
                    child: Text(disciplina.nome),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    disciplinaSelecionada = value;
                  });
                },
                validator: (value) => value == null ? 'Selecione uma disciplina' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Bimestre'),
                value: bimestreSelecionado,
                items: const [
                  DropdownMenuItem(value: 1, child: Text('1º Bimestre')),
                  DropdownMenuItem(value: 2, child: Text('2º Bimestre')),
                ],
                onChanged: (value) {
                  setState(() {
                    bimestreSelecionado = value;
                  });
                },
                validator: (value) =>
                value == null ? 'Selecione o bimestre' : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(dataProva == null
                    ? 'Selecione a data da prova'
                    : 'Data: ${dataProva!.toLocal().toString().split(' ')[0]}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: dataProva ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      dataProva = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              const Text("Adicionar Questão", style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Nº da Questão'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => numeroQuestao = int.tryParse(value),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Resposta Correta'),
                      onChanged: (value) => respostaCorreta = value.toUpperCase().trim(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    tooltip: 'Adicionar Questão',
                    onPressed: () {
                      if (numeroQuestao != null && respostaCorreta != null && respostaCorreta!.isNotEmpty) {
                        final existe = gabarito.any((g) => g['numero'] == numeroQuestao);
                        if (!existe) {
                          setState(() {
                            gabarito.add({'numero': numeroQuestao, 'resposta': respostaCorreta});
                            numeroQuestao = null;
                            respostaCorreta = null;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Questão já adicionada.')),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text("Gabarito", style: TextStyle(fontWeight: FontWeight.bold)),
              Column(
                children: gabarito.map((questao) {
                  return ListTile(
                    title: Text("Questão ${questao['numero']} - Resposta: ${questao['resposta']}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          gabarito.remove(questao);
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: salvando ? null : salvarProva,
                  child: salvando
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text('Salvar Prova'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
