import 'package:flutter/material.dart';
import '../models/usuario_dto.dart';
import '../models/prova_dto.dart';
import '../models/turma_dto.dart';
import '../models/aluno_dto.dart';
import '../services/prova_service.dart';
import '../services/turma_service.dart';
import '../services/aluno_service.dart';

class CorrigirProvaScreen extends StatefulWidget {
  final UsuarioDTO usuario;

  const CorrigirProvaScreen({super.key, required this.usuario});

  @override
  State<CorrigirProvaScreen> createState() => _CorrigirProvaScreenState();
}

class _CorrigirProvaScreenState extends State<CorrigirProvaScreen> {
  List<TurmaDTO> turmas = [];
  List<AlunoDTO> alunos = [];
  List<ProvaDTO> provas = [];

  TurmaDTO? turmaSelecionada;
  AlunoDTO? alunoSelecionado;

  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    try {
      final turmasData = await TurmaService().listarTurmas();
      final alunosData = await AlunoService().listarAlunos();
      final provasData = await ProvaService().listarProvas();

      setState(() {
        turmas = turmasData;
        alunos = alunosData;
        provas = provasData;
        carregando = false;
      });
    } catch (e) {
      setState(() => carregando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados: $e')),
      );
    }
  }

  List<ProvaDTO> filtrarProvas() {
    var lista = provas;
    if (turmaSelecionada != null) {
      lista = lista.where((p) => p.turmaId == turmaSelecionada!.id).toList();
    }
    if (alunoSelecionado != null) {
      // Aqui você pode filtrar por aluno, se necessário (depende da sua modelagem)
    }
    return lista;
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final provasFiltradas = filtrarProvas();

    return Scaffold(
      appBar: AppBar(title: const Text('Corrigir Prova')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<TurmaDTO>(
              hint: const Text('Selecione a turma'),
              value: turmaSelecionada,
              isExpanded: true,
              items: turmas
                  .map((t) => DropdownMenuItem(
                value: t,
                child: Text(t.nome),
              ))
                  .toList(),
              onChanged: (v) => setState(() => turmaSelecionada = v),
            ),
            const SizedBox(height: 8),
            DropdownButton<AlunoDTO>(
              hint: const Text('Selecione o aluno'),
              value: alunoSelecionado,
              isExpanded: true,
              items: alunos
                  .map((a) => DropdownMenuItem(
                value: a,
                child: Text(a.nome),
              ))
                  .toList(),
              onChanged: (v) => setState(() => alunoSelecionado = v),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: provasFiltradas.isEmpty
                  ? const Center(child: Text('Nenhuma prova encontrada.'))
                  : ListView.builder(
                itemCount: provasFiltradas.length,
                itemBuilder: (context, index) {
                  final prova = provasFiltradas[index];
                  return ListTile(
                    title: Text(prova.titulo),
                    subtitle: Text(
                        'Turma ID: ${prova.turmaId}, Data: ${prova.data}'),
                    onTap: () {
                      // Navegar para tela de correção de prova, passando prova, aluno selecionado e etc
                      // Exemplo:
                      // Navigator.pushNamed(context, '/corrigirProvaDetalhes', arguments: {'prova': prova, 'aluno': alunoSelecionado});
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
