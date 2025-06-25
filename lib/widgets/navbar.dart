import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: UsuariosPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class UsuariosPage extends StatelessWidget {
  final List<Map<String, String>> usuarios = const [
    {"id": "01", "nome": "Administrador", "email": "admin@gmail.com"},
    {"id": "02", "nome": "Professor", "email": "professor@gmail.com"},
    {"id": "03", "nome": "Aluno", "email": "aluno@gmail.com"},
  ];

  const UsuariosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hackathon'),
        backgroundColor: Colors.black,
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.logout, color: Colors.white, size: 20),
            label: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.black87),
              child: Text(
                'Painel Administrativo',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: Icon(Icons.people, color: Colors.white),
              title: Text('Usuários', style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              leading: Icon(Icons.school, color: Colors.white),
              title: Text('Turmas', style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              leading: Icon(Icons.book, color: Colors.white),
              title: Text('Disciplinas', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.resolveWith(
                    (states) => Colors.grey[300],
              ),
              columns: const [
                DataColumn(label: Text('# Id')),
                DataColumn(label: Text('Usuário')),
                DataColumn(label: Text('E-mail')),
                DataColumn(label: Text('Senha')),
                DataColumn(label: Text('Ações')),
              ],
              rows: usuarios.map((usuario) {
                return DataRow(cells: [
                  DataCell(Text('# ${usuario["id"]}')),
                  DataCell(Text(usuario["nome"]!)),
                  DataCell(Text(usuario["email"]!)),
                  const DataCell(Text('********')),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {},
                      ),
                    ],
                  )),
                ]);
              }).toList(),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
