import 'package:flutter/material.dart';
import '../models/usuario_dto.dart';
import '../models/prova_dto.dart';
import '../models/aluno_dto.dart';
import '../models/correcao_dto.dart';
import '../services/prova_service.dart';
import '../services/aluno_service.dart';
import '../services/correcao_service.dart';

class CorrigirProvaScreen extends StatefulWidget {
  final UsuarioDTO usuario;

  const CorrigirProvaScreen({super.key, required this.usuario});

  @override
  State<CorrigirProvaScreen> createState() => _CorrigirProvaScreenState();
}

class _CorrigirProvaScreenState extends State<CorrigirProvaScreen> {
  List<AlunoDTO> alunos = [];
  List<ProvaDTO> provas = [];
  List<CorrecaoDTO> correcoes = [];

  AlunoDTO? alunoSelecionado;
  ProvaDTO? provaSelecionada;
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    try {
      final alunosData = await AlunoService().listarAlunos();
      final provasData = await ProvaService().listarProvas();

      setState(() {
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

  Future<void> filtrarCorrecoes() async {
    if (alunoSelecionado == null && provaSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione ao menos um filtro.')),
      );
      return;
    }

    setState(() => carregando = true);
    try {
      final dados = await CorrecaoService().buscarCorrecoes(
        alunoId: alunoSelecionado?.id,
        provaId: provaSelecionada?.id,
      );
      setState(() {
        correcoes = dados;
        carregando = false;
      });
    } catch (e) {
      setState(() => carregando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao filtrar correções: $e')),
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
      appBar: AppBar(
        title: const Text('Correção de Provas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Nova Correção',
            onPressed: () {
              Navigator.pushNamed(context, '/novaCorrecao');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(children: [
              Expanded(
                child: DropdownButtonFormField<AlunoDTO>(
                  value: alunoSelecionado,
                  hint: const Text('Selecione o aluno'),
                  isExpanded: true,
                  items: alunos
                      .map((a) =>
                      DropdownMenuItem(value: a, child: Text(a.nome)))
                      .toList(),
                  onChanged: (v) => setState(() => alunoSelecionado = v),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<ProvaDTO>(
                  value: provaSelecionada,
                  hint: const Text('Selecione a prova'),
                  isExpanded: true,
                  items: provas
                      .map((p) =>
                      DropdownMenuItem(value: p, child: Text(p.titulo)))
                      .toList(),
                  onChanged: (v) => setState(() => provaSelecionada = v),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: filtrarCorrecoes,
                child: const Text('Filtrar'),
              ),
            ]),
            const SizedBox(height: 16),
            Expanded(
              child: correcoes.isEmpty
                  ? const Center(child: Text('Nenhuma correção encontrada.'))
                  : ListView.separated(
                itemCount: correcoes.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final correcao = correcoes[index];
                  return ListTile(
                    title: Text(
                        '${correcao.alunoNome} - ${correcao.provaTitulo}'),
                    subtitle: Text(
                        'Nota: ${correcao.nota.toStringAsFixed(2)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/novaCorrecao',
                              arguments: correcao.id,
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Excluir correção'),
                                content: const Text(
                                    'Deseja excluir esta correção?'),
                                actions: [
                                  TextButton(
                                    child: const Text('Cancelar'),
                                    onPressed: () =>
                                        Navigator.pop(context),
                                  ),
                                  TextButton(
                                    child: const Text('Excluir'),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      try {
                                        await CorrecaoService()
                                            .excluirCorrecao(
                                            correcao.id);
                                        filtrarCorrecoes();
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                            content: Text(
                                                'Erro ao excluir: $e')));
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
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
