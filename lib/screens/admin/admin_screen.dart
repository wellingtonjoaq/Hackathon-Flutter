import 'package:flutter/material.dart';
import 'package:hackathon_flutter/models/usuario_dto.dart';
import 'package:hackathon_flutter/widgets/classes_admin_page.dart';
import 'package:hackathon_flutter/services/local_storage_service.dart';

import '../../widgets/disciplines_admin_page.dart';
import '../../widgets/users_admin_page.dart';

class AdminScreen extends StatefulWidget {
  final UsuarioDTO usuario;

  const AdminScreen({super.key, required this.usuario});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const UsersAdminPage(),
    const DisciplinesAdminPage(),
    const ClassesAdminPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  void _logout() async {
    await LocalStorageService().limparUsuario();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Painel do Administrador',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.indigo,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
            tooltip: 'Sair da conta',
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                widget.usuario.nome,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
              ),
              accountEmail: Text(
                widget.usuario.email,
                style: const TextStyle(color: Colors.white70),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.indigo, size: 40),
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.people, color: _selectedIndex == 0 ? Colors.indigo : Colors.grey),
              title: Text(
                'Usuários',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: _selectedIndex == 0 ? FontWeight.bold : FontWeight.normal,
                  color: _selectedIndex == 0 ? Colors.indigo : Colors.black87,
                ),
              ),
              selected: _selectedIndex == 0,
              selectedTileColor: Colors.indigo.shade50,
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: Icon(Icons.book, color: _selectedIndex == 1 ? Colors.indigo : Colors.grey),
              title: Text(
                'Disciplinas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: _selectedIndex == 1 ? FontWeight.bold : FontWeight.normal,
                  color: _selectedIndex == 1 ? Colors.indigo : Colors.black87,
                ),
              ),
              selected: _selectedIndex == 1,
              selectedTileColor: Colors.indigo.shade50,
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: Icon(Icons.class_, color: _selectedIndex == 2 ? Colors.indigo : Colors.grey),
              title: Text(
                'Turmas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: _selectedIndex == 2 ? FontWeight.bold : FontWeight.normal,
                  color: _selectedIndex == 2 ? Colors.indigo : Colors.black87,
                ),
              ),
              selected: _selectedIndex == 2,
              selectedTileColor: Colors.indigo.shade50,
              onTap: () => _onItemTapped(2),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.grey[100],
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
    );
  }
}