import 'package:flutter/material.dart';
import 'screens/login_screen.dart';  // <-- aqui, 'telas' ao invés de 'screens'

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Corretor de Provas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
