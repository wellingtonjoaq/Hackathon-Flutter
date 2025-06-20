import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: UsuariosPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class UsuariosPage extends StatelessWidget {
  final List<Map<String, String>> usuarios = [
    {"id": "01", "nome": "Administrador", "email": "exemplo@gmail.com"},
    {"id": "02", "nome": "Professor", "email": "exemplo@gmail.com"},
    {"id": "03", "nome": "Aluno", "email": "exemplo@gmail.com"},
    {"id": "04", "nome": "Professor", "email": "exemplo@gmail.com"},
    {"id": "05", "nome": "Aluno", "email": "exemplo@gmail.com"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuários'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
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
              DataCell(Text('********')),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_red_eye, color: Colors.blue),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.orange),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {},
                  ),
                ],
              )),
            ]);
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.grey[300],
        child: Icon(Icons.add, color: Colors.black),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.people), label: 'Usuários'),
          BottomNavigationBarItem(
              icon: Icon(Icons.school), label: 'Turmas'),
          BottomNavigationBarItem(
              icon: Icon(Icons.book), label: 'Disciplinas'),
          BottomNavigationBarItem(
              icon: Icon(Icons.admin_panel_settings), label: 'Administrador'),
        ],
        onTap: (index) {
          // Navegação entre páginas
        },
      ),
    );
  }
}
