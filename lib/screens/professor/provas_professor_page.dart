import 'package:flutter/material.dart';
import '../../models/prova_dto.dart';
import '../../models/turma_dto.dart';
import '../../models/disciplina_dto.dart';
import '../../models/bimestre.dart';
import '../../models/usuario_dto.dart';
import '../../services/api_service.dart';
import 'prova_form_screen.dart';

class ProvasProfessorPage extends StatefulWidget {
  final UsuarioDTO usuario;

  const ProvasProfessorPage({super.key, required this.usuario});

  @override
  State<ProvasProfessorPage> createState() => _ProvasProfessorPageState();
}

class _ProvasProfessorPageState extends State<ProvasProfessorPage> {
  late Future<List<ProvaDTO>> _provasFuture;
  final ApiService _apiService = ApiService();

  TurmaDTO? _selectedTurmaFilter;
  DisciplinaDTO? _selectedDisciplinaFilter;
  Bimestre? _selectedBimestreFilter;
  DateTime? _selectedDateFilter;

  List<TurmaDTO> _turmas = [];
  List<DisciplinaDTO> _disciplinas = [];
  bool _isLoadingFilters = true;

  @override
  void initState() {
    super.initState();
    _fetchFilterOptions();
    _fetchProvas();
  }

  void _fetchFilterOptions() async {
    try {
      final fetchedTurmas = await _apiService.fetchTurmasAdmin();
      final fetchedDisciplinas = await _apiService.fetchDisciplinas();

      setState(() {
        _turmas = fetchedTurmas;
        _disciplinas = fetchedDisciplinas;
        _isLoadingFilters = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingFilters = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar opções de filtro: $e')),
      );
    }
  }

  void _fetchProvas() {
    setState(() {
      _provasFuture = _apiService.fetchProvas(
        professorId: widget.usuario.id,
        turmaId: _selectedTurmaFilter?.id,
        disciplinaId: _selectedDisciplinaFilter?.id,
        bimestre: _selectedBimestreFilter,
        data: _selectedDateFilter,
      );
    });
  }

  void _showAddEditProvaScreen({ProvaDTO? prova}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProvaFormScreen(
          professorId: widget.usuario.id!,
          prova: prova,
        ),
      ),
    );

    if (result == true) {
      _fetchProvas();
    }
  }

  Future<void> _confirmDelete(ProvaDTO prova) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text('Tem certeza que deseja excluir a prova "${prova.titulo}"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await _apiService.deleteProva(prova.id!);
        _fetchProvas();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Prova "${prova.titulo}" excluída com sucesso!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir prova: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _isLoadingFilters
                    ? const Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<TurmaDTO>(
                  value: _selectedTurmaFilter,
                  decoration: InputDecoration(
                    labelText: 'Turma',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  items: [
                    const DropdownMenuItem<TurmaDTO>(
                      value: null,
                      child: Text('Todas as Turmas'),
                    ),
                    ..._turmas.map((turma) => DropdownMenuItem<TurmaDTO>(
                      value: turma,
                      child: Text(turma.nome),
                    ))
                  ],
                  onChanged: (TurmaDTO? newValue) {
                    setState(() {
                      _selectedTurmaFilter = newValue;
                    });
                  },
                ),
                const SizedBox(height: 15),
                _isLoadingFilters
                    ? const Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<DisciplinaDTO>(
                  value: _selectedDisciplinaFilter,
                  decoration: InputDecoration(
                    labelText: 'Disciplina',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  items: [
                    const DropdownMenuItem<DisciplinaDTO>(
                      value: null,
                      child: Text('Todas as Disciplinas'),
                    ),
                    ..._disciplinas.map((disc) => DropdownMenuItem<DisciplinaDTO>(
                      value: disc,
                      child: Text(disc.nome),
                    ))
                  ],
                  onChanged: (DisciplinaDTO? newValue) {
                    setState(() {
                      _selectedDisciplinaFilter = newValue;
                    });
                  },
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<Bimestre>(
                  value: _selectedBimestreFilter,
                  decoration: InputDecoration(
                    labelText: 'Bimestre',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  items: [
                    const DropdownMenuItem<Bimestre>(
                      value: null,
                      child: Text('Todos os Bimestres'),
                    ),
                    ...Bimestre.values.map((b) => DropdownMenuItem<Bimestre>(
                      value: b,
                      child: Text(b.toDisplayString()),
                    ))
                  ],
                  onChanged: (Bimestre? newValue) {
                    setState(() {
                      _selectedBimestreFilter = newValue;
                    });
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Data da Prova',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.grey[50],
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDateFilter ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null && picked != _selectedDateFilter) {
                          setState(() {
                            _selectedDateFilter = picked;
                          });
                        }
                      },
                    ),
                  ),
                  controller: TextEditingController(
                    text: _selectedDateFilter != null
                        ? "${_selectedDateFilter!.day.toString().padLeft(2, '0')}/${_selectedDateFilter!.month.toString().padLeft(2, '0')}/${_selectedDateFilter!.year}"
                        : '',
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: _fetchProvas,
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Filtrar Provas'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    textStyle: const TextStyle(fontSize: 16),
                    minimumSize: const Size.fromHeight(45),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<ProvaDTO>>(
            future: _provasFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.indigo));
              } else if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Erro ao carregar provas: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                    ),
                  ),
                );
              }

              final provas = snapshot.data ?? [];

              if (provas.isEmpty) {
                return const Center(
                  child: Text(
                    'Nenhuma prova encontrada.',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                );
              }

              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.resolveWith(
                            (states) => Colors.indigo.shade50,
                      ),
                      dataRowColor: MaterialStateProperty.resolveWith((states) => Colors.white),
                      border: TableBorder.symmetric(
                        inside: BorderSide(width: 0.5, color: Colors.grey.shade300),
                        outside: BorderSide.none,
                      ),
                      columns: const [
                        DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo))),
                        DataColumn(label: Text('Título', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo))),
                        DataColumn(label: Text('Turma', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo))),
                        DataColumn(label: Text('Disciplina', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo))),
                        DataColumn(label: Text('Bimestre', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo))),
                        DataColumn(label: Text('Data', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo))),
                        DataColumn(label: Text('Ações', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo))),
                      ],
                      rows: provas.map((prova) {
                        return DataRow(cells: [
                          DataCell(Text(prova.id?.toString() ?? '-')),
                          DataCell(Text(prova.titulo)),
                          DataCell(Text(prova.nomeTurma ?? 'N/A')),
                          DataCell(Text(prova.nomeDisciplina ?? 'N/A')),
                          DataCell(Text(prova.bimestre.toDisplayString())),
                          DataCell(Text("${prova.data.day.toString().padLeft(2, '0')}/${prova.data.month.toString().padLeft(2, '0')}/${prova.data.year}")),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blueAccent),
                                onPressed: () => _showAddEditProvaScreen(prova: prova),
                                tooltip: 'Editar Prova',
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent),
                                onPressed: () => _confirmDelete(prova),
                                tooltip: 'Excluir Prova',
                              ),
                            ],
                          )),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}