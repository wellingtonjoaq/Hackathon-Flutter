import 'package:flutter/material.dart';
import '../../../models/disciplina_dto.dart';
import '../../../models/usuario_dto.dart';
import '../../../services/api_service.dart';
import 'admin_object_form_screen.dart';

class DisciplinesAdminPage extends StatefulWidget {
  const DisciplinesAdminPage({super.key});

  @override
  State<DisciplinesAdminPage> createState() => _DisciplinesAdminPageState();
}

class _DisciplinesAdminPageState extends State<DisciplinesAdminPage> {
  late Future<List<DisciplinaDTO>> _disciplinesFuture;
  final ApiService _apiService = ApiService();

  final TextEditingController _nameFilterController = TextEditingController();
  String? _selectedProfessorFilter;
  List<UsuarioDTO> _professors = [];
  bool _isLoadingProfessors = true;

  @override
  void initState() {
    super.initState();
    _fetchProfessors();
    _fetchDisciplines();
  }

  void _fetchProfessors() async {
    try {
      final allUsers = await _apiService.fetchUsuarios();
      setState(() {
        _professors = allUsers.where((u) => u.perfil == 'PROFESSOR').toList();
        _isLoadingProfessors = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingProfessors = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar professores para filtro: $e')),
      );
    }
  }

  void _fetchDisciplines() {
    setState(() {
      _disciplinesFuture = _apiService.fetchDisciplinas(
        nome: _nameFilterController.text.isNotEmpty ? _nameFilterController.text : null,
        professorNome: _selectedProfessorFilter,
      );
    });
  }

  void _showAddEditDisciplineScreen({DisciplinaDTO? discipline}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminObjectFormScreen(
          objectType: AdminFormObjectType.discipline,
          initialObject: discipline,
        ),
      ),
    );

    if (result == true) {
      _fetchDisciplines();
    }
  }

  Future<void> _confirmDelete(DisciplinaDTO discipline) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text('Tem certeza que deseja excluir a disciplina "${discipline.nome}"?'),
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
        await _apiService.deleteDisciplina(discipline.id!);
        _fetchDisciplines();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Disciplina "${discipline.nome}" excluída com sucesso!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir disciplina: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDisciplineScreen(),
        label: const Text('Adicionar Disciplina'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
                        labelText: 'Nome da Disciplina',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      onFieldSubmitted: (_) => _fetchDisciplines(),
                    ),
                    const SizedBox(height: 15),
                    _isLoadingProfessors
                        ? const Center(child: CircularProgressIndicator())
                        : DropdownButtonFormField<String>(
                      value: _selectedProfessorFilter,
                      decoration: InputDecoration(
                        labelText: 'Professor',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('Todos os Professores'),
                        ),
                        ..._professors.map((prof) => DropdownMenuItem<String>(
                          value: prof.nome,
                          child: Text(prof.nome),
                        ))
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedProfessorFilter = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton.icon(
                      onPressed: _fetchDisciplines,
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
              child: FutureBuilder<List<DisciplinaDTO>>(
                future: _disciplinesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Colors.indigo));
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'Erro ao carregar disciplinas: ${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                        ),
                      ),
                    );
                  }

                  final disciplines = snapshot.data ?? [];

                  if (disciplines.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhuma disciplina encontrada.',
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
                            DataColumn(label: Text('Professor', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo))),
                            DataColumn(label: Text('Ações', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo))),
                          ],
                          rows: disciplines.map((discipline) {
                            return DataRow(cells: [
                              DataCell(Text(discipline.id?.toString() ?? '-')),
                              DataCell(Text(discipline.nome)),
                              DataCell(Text(discipline.nomeProfessor ?? 'N/A')),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                                    onPressed: () => _showAddEditDisciplineScreen(discipline: discipline),
                                    tooltip: 'Editar Disciplina',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                                    onPressed: () => _confirmDelete(discipline),
                                    tooltip: 'Excluir Disciplina',
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