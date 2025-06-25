import 'package:flutter/material.dart';
import 'package:hackathon_flutter/models/usuario_dto.dart';
import 'package:hackathon_flutter/services/local_storage_service.dart';
import 'package:hackathon_flutter/screens/professor/provas_professor_page.dart';

class ProfessorMainScreen extends StatefulWidget {
  final UsuarioDTO usuario;

  const ProfessorMainScreen({super.key, required this.usuario});

  @override
  State<ProfessorMainScreen> createState() => _ProfessorMainScreenState();
}

class _ProfessorMainScreenState extends State<ProfessorMainScreen> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      ProvasProfessorPage(usuario: widget.usuario),
      ProfessorMainScreen(usuario: widget.usuario),
    ];
  }

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
          'Painel do Professor',
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
              leading: Icon(Icons.assignment, color: _selectedIndex == 0 ? Colors.indigo : Colors.grey),
              title: Text(
                'Minhas Provas',
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
              leading: Icon(Icons.book_online, color: _selectedIndex == 1 ? Colors.indigo : Colors.grey),
              title: Text(
                'Minhas Disciplinas',
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
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                'Sair',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.redAccent),
              ),
              onTap: _logout,
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Provas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Disciplinas',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey[600],
        backgroundColor: Colors.white,
        elevation: 8,
        onTap: _onItemTapped,
      ),
    );
  }
}