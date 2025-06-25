import 'package:flutter/material.dart';
import '../models/usuario_dto.dart';
import '../services/local_storage_service.dart';

class ProfessorScreen extends StatelessWidget {
  final UsuarioDTO usuario;

  const ProfessorScreen({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Área do Professor'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await LocalStorageService().limparUsuario();
              Navigator.pushReplacementNamed(context, '/login');
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Bem-vindo, ${usuario.nome} (Professor)',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Botão para Adicionar Prova
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Prova'),
              onPressed: () {
                Navigator.pushNamed(context, '/adicionarProva');
              },
            ),

            const SizedBox(height: 16),

            // Botão para Corrigir Provas
            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text('Corrigir Prova'),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/corrigirProva',
                  arguments: usuario,
                );
              },

            ),

            const SizedBox(height: 16),

          ],
        ),
      ),
    );
  }
}
