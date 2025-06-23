import 'package:flutter/material.dart';
import '../models/usuario_dto.dart';

class ResultadosScreen extends StatelessWidget {
  final UsuarioDTO usuario;

  const ResultadosScreen({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    // Você pode implementar filtros e listagem aqui similar à CorrigirProvaScreen,
    // ou até reutilizar código.
    return Scaffold(
      appBar: AppBar(title: const Text('Resultados')),
      body: Center(
        child: Text(
          'Aqui será mostrado os resultados das provas para ${usuario.nome}.',
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
