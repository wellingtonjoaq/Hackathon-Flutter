import 'package:flutter/material.dart';
import '../models/usuario_dto.dart';
import '../services/local_storage_service.dart';

class ProfessorScreen extends StatelessWidget {
  final UsuarioDTO usuario; // campo para guardar o usuário

  const ProfessorScreen({super.key, required this.usuario}); // atribuir no construtor

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
              Navigator.pushReplacementNamed(context, '/login'); // usar rota login para sair
            },
            tooltip: 'Logout',
          )
        ],
      ),
      body: Center(
        child: Text(
          'Bem-vindo, ${usuario.nome} (Professor)',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

