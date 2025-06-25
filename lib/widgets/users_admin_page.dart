import 'package:flutter/material.dart';
import '../../models/usuario_dto.dart';
import '../../services/api_service.dart';
import 'admin_object_form_screen.dart';

class UsersAdminPage extends StatefulWidget {
  const UsersAdminPage({super.key});

  @override
  State<UsersAdminPage> createState() => _UsersAdminPageState();
}

class _UsersAdminPageState extends State<UsersAdminPage> {
  late Future<List<UsuarioDTO>> _usersFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() {
    setState(() {
      _usersFuture = _apiService.fetchUsuarios();
    });
  }

  void _showAddEditUserScreen({UsuarioDTO? user}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminObjectFormScreen(
          objectType: AdminFormObjectType.user,
          initialObject: user,
        ),
      ),
    );

    if (result == true) {
      _fetchUsers();
    }
  }

  Future<void> _confirmDelete(UsuarioDTO user) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text('Tem certeza que deseja excluir o usuário "${user.nome}"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await _apiService.deleteUsuario(user.id!);
        _fetchUsers();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuário "${user.nome}" excluído com sucesso!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir usuário: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditUserScreen(),
        label: const Text('Adicionar Usuário'),
        icon: const Icon(Icons.person_add),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: FutureBuilder<List<UsuarioDTO>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.indigo));
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Erro ao carregar usuários: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                ),
              ),
            );
          }

          final users = snapshot.data ?? [];

          if (users.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum usuário encontrado.',
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            scrollDirection: Axis.vertical,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.resolveWith(
                        (states) => Colors.indigo.shade50,
                  ),
                  dataRowColor: MaterialStateProperty.resolveWith((states) => Colors.white),
                  border: TableBorder.symmetric(
                    inside: BorderSide(width: 0.5, color: Colors.grey.shade300),
                    outside: BorderSide.none,
                  ),
                  columns: const [
                    DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo))),
                    DataColumn(label: Text('Nome', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo))),
                    DataColumn(label: Text('E-mail', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo))),
                    DataColumn(label: Text('Perfil', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo))),
                    DataColumn(label: Text('Ações', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo))),
                  ],
                  rows: users.map((user) {
                    return DataRow(cells: [
                      DataCell(Text(user.id?.toString() ?? '-')),
                      DataCell(Text(user.nome)),
                      DataCell(Text(user.email)),
                      DataCell(Text(user.perfil)),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blueAccent),
                            onPressed: () => _showAddEditUserScreen(user: user),
                            tooltip: 'Editar Usuário',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => _confirmDelete(user),
                            tooltip: 'Excluir Usuário',
                          ),
                        ],
                      )),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}