import 'package:flutter/material.dart';
import '../models/usuario_dto.dart';

class HomeScreen extends StatelessWidget {
  final UsuarioDTO usuario;

  const HomeScreen({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF42A5F5), Color(0xFF1976D2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            Text(
              'Olá, ${usuario.nome}!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Seu e-mail: ${usuario.email}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Perfil: ${usuario.perfil}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                // Voltar para tela de login (ou implementar logout real)
                Navigator.pop(context);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Sair'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
