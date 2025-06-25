// lib/screens/admin/disciplines_admin_page.dart

import 'package:flutter/material.dart';
import 'package:hackathon_flutter/models/disciplina_dto.dart';
import 'package:hackathon_flutter/services/disciplina_service.dart'; // Importe seu serviço de disciplina

class DisciplinesAdminPage extends StatefulWidget {
  const DisciplinesAdminPage({super.key});

  @override
  State<DisciplinesAdminPage> createState() => _DisciplinesAdminPageState();
}

class _DisciplinesAdminPageState extends State<DisciplinesAdminPage> {
  late Future<List<DisciplinaDTO>> _disciplinesFuture;
  final dynamic _disciplineService = DisciplinaService();

  @override
  void initState() {
    super.initState();
    _disciplinesFuture = _disciplineService.getDisciplinas();
  }



  void _addDisciplina() async {
    // Navegar para a tela de adicionar disciplina
    // Exemplo: final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AdicionarDisciplinaScreen()));
    // if (result == true) _fetchDisciplines();
    print('Adicionar nova disciplina');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funcionalidade de adicionar disciplina em desenvolvimento!')),
    );
  }

  void _editDisciplina(DisciplinaDTO discipline) async {
    // Navegar para a tela de editar disciplina, passando a disciplina
    // Exemplo: final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditarDisciplinaScreen(disciplina: discipline)));
    // if (result == true) _fetchDisciplines();
    print('Editar disciplina: ${discipline.nome}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Funcionalidade de editar disciplina ${discipline.nome} em desenvolvimento!')),
    );
  }

  void _deleteDisciplina(DisciplinaDTO discipline) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text('Tem certeza que deseja excluir a disciplina ${discipline.nome}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await _disciplineService.deleteDisciplina(discipline.id!); // Assumindo que DisciplinaDto tem 'id'
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Disciplina excluída com sucesso!')),
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
      body: FutureBuilder<List<DisciplinaDTO>>(
        future: _disciplinesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar disciplinas: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma disciplina encontrada.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final discipline = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.book),
                    title: Text(discipline.nome ?? 'Disciplina sem nome'),
                    subtitle: Text('ID: ${discipline.id ?? "N/A"}'), // Ou outro campo relevante
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editDisciplina(discipline),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteDisciplina(discipline),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDisciplina,
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
