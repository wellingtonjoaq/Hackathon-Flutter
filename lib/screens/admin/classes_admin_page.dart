// lib/screens/admin/classes_admin_page.dart

import 'package:flutter/material.dart';
import 'package:hackathon_flutter/models/turma_dto.dart'; 
import 'package:hackathon_flutter/services/turma_service.dart'; 

class ClassesAdminPage extends StatefulWidget {
  const ClassesAdminPage({super.key});

  @override
  State<ClassesAdminPage> createState() => _ClassesAdminPageState();
}

class _ClassesAdminPageState extends State<ClassesAdminPage> {
  late Future<List<TurmaDTO>> _classesFuture;
  final TurmaService _classService = TurmaService();

  @override
  void initState() {
    super.initState();
    _classesFuture = _classService.getTurmas();
  }



  void _addTurma() async {
    // Navegar para a tela de adicionar turma
    print('Adicionar nova turma');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funcionalidade de adicionar turma em desenvolvimento!')),
    );
  }

  void _editTurma(TurmaDTO turma) async {
    // Navegar para a tela de editar turma, passando a turma
    print('Editar turma: ${turma.nome}'); // Assumindo que TurmaDto tem 'nome'
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Funcionalidade de editar turma ${turma.nome} em desenvolvimento!')),
    );
  }

  void _deleteTurma(TurmaDTO turma) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text('Tem certeza que deseja excluir a turma ${turma.nome}?'),
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
        await _classService.deleteTurma(turma.id!); // Assumindo que TurmaDto tem 'id'
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Turma excluída com sucesso!')),
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
      body: FutureBuilder<List<TurmaDTO>>(
        future: _classesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar turmas: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma turma encontrada.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final turma = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.class_),
                    title: Text(turma.nome ?? 'Turma sem nome'),
                    subtitle: Text('Ano: ${turma ?? "N/A"}'), // Ou outro campo relevante
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editTurma(turma),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteTurma(turma),
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
        onPressed: _addTurma,
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
