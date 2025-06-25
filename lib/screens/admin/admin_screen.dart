// lib/screens/admin/admin_screen.dart

import 'package:flutter/material.dart';
import 'package:hackathon_flutter/models/usuario_dto.dart';
import 'package:hackathon_flutter/screens/admin/users_admin_page.dart';
import 'package:hackathon_flutter/screens/admin/disciplines_admin_page.dart';
import 'package:hackathon_flutter/screens/admin/classes_admin_page.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key, required UsuarioDTO usuario});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0; // Índice da aba selecionada (0: Usuários, 1: Disciplinas, 2: Turmas)

  // Lista de widgets para cada aba
  // As instâncias são criadas aqui para que possam ser "cached" ou ter seu estado gerenciado pelo PageView/IndexedStack
  final List<Widget> _pages = [
    const UsersAdminPage(),      // Conteúdo da aba Usuários
    const DisciplinesAdminPage(), // Conteúdo da aba Disciplinas
    const ClassesAdminPage(),     // Conteúdo da aba Turmas
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel do Administrador'),
        // A cor já será aplicada pelo Theme.of(context).primaryColor se configurado no main.dart
        // backgroundColor: Theme.of(context).primaryColor, // Remova se já estiver no Theme
      ),
      body: IndexedStack( // Use IndexedStack para manter o estado das páginas quando você alterna entre elas
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Usuários',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Disciplinas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            label: 'Turmas',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor, // Cor do ícone/label selecionado
        unselectedItemColor: Colors.grey[600], // Cor do ícone/label não selecionado
        onTap: _onItemTapped,
      ),
    );
  }
}