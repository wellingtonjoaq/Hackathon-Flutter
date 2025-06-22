import 'package:flutter/material.dart';
import '../models/usuario_dto.dart';
import '../services/local_storage_service.dart';

class AlunoScreen extends StatelessWidget {
  final UsuarioDTO usuario; // campo para armazenar o usuário

  const AlunoScreen({super.key, required this.usuario}); // recebe no construtor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Área do Aluno'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await LocalStorageService().limparUsuario();
              Navigator.pushReplacementNamed(context, '/login');// direciona para login
            },
            tooltip: 'Logout',
          )
        ],
      ),
      body: Center(
        child: Text(
          'Bem-vindo, ${usuario.nome} (Aluno)',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
