// import 'package:flutter/material.dart';
// import '../models/usuario_dto.dart';
// import '../services/local_storage_service.dart';
//
// class AdminScreen extends StatelessWidget {
//   final UsuarioDTO usuario; // campo final para guardar o usuário
//
//   const AdminScreen({super.key, required this.usuario}); // atribuir no construtor
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Área do Administrador'),
//         backgroundColor: Colors.deepPurple,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () async {
//               await LocalStorageService().limparUsuario();
//               Navigator.pushReplacementNamed(context, '/login'); // melhor usar /login
//             },
//             tooltip: 'Logout',
//           )
//         ],
//       ),
//       body: Center(
//         child: Text(
//           'Bem-vindo, ${usuario.nome} (Administrador)',
//           style: const TextStyle(fontSize: 18),
//         ),
//       ),
//     );
//   }
// }
