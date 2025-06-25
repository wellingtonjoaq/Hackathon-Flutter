// lib/screens/admin/classes_admin_page.dart
import 'package:flutter/material.dart';
import 'package:hackathon_flutter/screens/admin/admin_object_form_screen.dart';
import '../../models/turma_dto.dart';
import '../../services/api_service.dart';

class ClassesAdminPage extends StatefulWidget {
  const ClassesAdminPage({super.key});

  @override
  State<ClassesAdminPage> createState() => _ClassesAdminPageState();
}

class _ClassesAdminPageState extends State<ClassesAdminPage> {
  late Future<List<TurmaDTO>> _classesFuture;
  final ApiService _apiService = ApiService();

  final TextEditingController _nameFilterController = TextEditingController();
  String? _selectedPeriodoFilter;
  String? _selectedCursoFilter;
  List<String> _periodos = [];
  List<String> _cursos = [];
  bool _isLoadingFilters = true;

  @override
  void initState() {
    super.initState();
    _fetchFilterOptions();
    _fetchClasses();
  }

  void _fetchFilterOptions() async {
    try {
      final fetchedPeriodos = await _apiService.fetchPeriodosUnicos();
      final fetchedCursos = await _apiService.fetchCursosUnicos();
      setState(() {
        _periodos = fetchedPeriodos;
        _cursos = fetchedCursos;
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

  void _fetchClasses() {
    setState(() {
      _classesFuture = _apiService.fetchTurmasAdmin(
        nome: _nameFilterController.text.isNotEmpty ? _nameFilterController.text : null,
        periodo: _selectedPeriodoFilter,
        curso: _selectedCursoFilter,
      );
    });
  }

  void _showAddEditClassScreen({TurmaDTO? classObject}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminObjectFormScreen(
          objectType: AdminFormObjectType.class_,
          initialObject: classObject,
        ),
      ),
    );

    if (result == true) {
      _fetchFilterOptions();
      _fetchClasses();
    }
  }

  Future<void> _confirmDelete(TurmaDTO classObject) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text('Tem certeza que deseja excluir a turma "${classObject.nome}"?'),
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
        await _apiService.deleteTurma(classObject.id!);
        _fetchFilterOptions();
        _fetchClasses();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Turma "${classObject.nome}" excluída com sucesso!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir turma: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditClassScreen(),
        label: const Text('Adicionar Turma'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Formulário de filtro
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameFilterController,
                      decoration: InputDecoration(
                        labelText: 'Nome da Turma',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      onFieldSubmitted: (_) => _fetchClasses(),
                    ),
                    const SizedBox(height: 15),
                    _isLoadingFilters
                        ? const Center(child: CircularProgressIndicator())
                        : DropdownButtonFormField<String>(
                      value: _selectedPeriodoFilter,
                      decoration: InputDecoration(
                        labelText: 'Período',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('Todos os Períodos'),
                        ),
                        ..._periodos.map((p) => DropdownMenuItem<String>(
                          value: p,
                          child: Text(p),
                        ))
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedPeriodoFilter = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    _isLoadingFilters
                        ? const Center(child: CircularProgressIndicator())
                        : DropdownButtonFormField<String>(
                      value: _selectedCursoFilter,
                      decoration: InputDecoration(
                        labelText: 'Curso',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('Todos os Cursos'),
                        ),
                        ..._cursos.map((c) => DropdownMenuItem<String>(
                          value: c,
                          child: Text(c),
                        ))
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCursoFilter = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton.icon(
                      onPressed: _fetchClasses,
                      icon: const Icon(Icons.filter_list),
                      label: const Text('Filtrar'),
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
              child: FutureBuilder<List<TurmaDTO>>(
                future: _classesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Colors.indigo));
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'Erro ao carregar turmas: ${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                        ),
                      ),
                    );
                  }

                  final classes = snapshot.data ?? [];

                  if (classes.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhuma turma encontrada.',
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
                            DataColumn(label: Text('Nome', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo))),
                            DataColumn(label: Text('Período', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo))),
                            DataColumn(label: Text('Curso', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo))),
                            DataColumn(label: Text('Ações', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo))),
                          ],
                          rows: classes.map((classObject) {
                            return DataRow(cells: [
                              DataCell(Text(classObject.id?.toString() ?? '-')),
                              DataCell(Text(classObject.nome)),
                              DataCell(Text(classObject.periodo)),
                              DataCell(Text(classObject.curso)),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                                    onPressed: () => _showAddEditClassScreen(classObject: classObject),
                                    tooltip: 'Editar Turma',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                                    onPressed: () => _confirmDelete(classObject),
                                    tooltip: 'Excluir Turma',
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
        ),
      ),
    );
  }
}