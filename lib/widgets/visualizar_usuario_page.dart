import 'package:flutter/material.dart';

class VisualizarUsuarioPage extends StatelessWidget {
  final Map<String, String> usuario;

  const VisualizarUsuarioPage({required this.usuario, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualizar Usuário'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${usuario["id"]}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Nome: ${usuario["nome"]}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('E-mail: ${usuario["email"]}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            const Text('Senha: ********', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
