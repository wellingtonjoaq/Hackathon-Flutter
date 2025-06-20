import 'package:flutter/material.dart';

class AdicionarUsuarioPage extends StatefulWidget {
  const AdicionarUsuarioPage({super.key});

  @override
  State<AdicionarUsuarioPage> createState() => _AdicionarUsuarioPageState();
}

class _AdicionarUsuarioPageState extends State<AdicionarUsuarioPage> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();

  void adicionar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuário adicionado (simulado).')),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Usuário'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: adicionar,
              child: const Text('Adicionar'),
            )
          ],
        ),
      ),
    );
  }
}
