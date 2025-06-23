import 'package:flutter/material.dart';
import '../models/prova_dto.dart';
import '../services/prova_service.dart';

class ListarProvaScreen extends StatefulWidget {
  const ListarProvaScreen({super.key});

  @override
  State<ListarProvaScreen> createState() => _ListarProvaScreenState();
}

class _ListarProvaScreenState extends State<ListarProvaScreen> {
  late Future<List<ProvaDTO>> _provasFuture;

  @override
  void initState() {
    super.initState();
    _provasFuture = ProvaService().listarProvas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provas Cadastradas'),
      ),
      body: FutureBuilder<List<ProvaDTO>>(
        future: _provasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar provas: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Nenhuma prova cadastrada.'),
            );
          } else {
            final provas = snapshot.data!;
            return ListView.builder(
              itemCount: provas.length,
              itemBuilder: (context, index) {
                final prova = provas[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    title: Text(prova.titulo),
                    subtitle: Text(
                      'Data: ${prova.data}\nTurma ID: ${prova.turmaId} | Disciplina ID: ${prova.disciplinaId}',
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
