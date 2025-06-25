// lib/screens/admin/users_admin_page.dart

import 'package:flutter/material.dart';
import 'package:hackathon_flutter/models/usuario_dto.dart';

import 'package:hackathon_flutter/widgets/adicionar_usuario_page.dart';
import 'package:hackathon_flutter/widgets/editar_usuario_page.dart';

import '../../services/user.dart';

class UsersAdminPage extends StatefulWidget {
  const UsersAdminPage({super.key});

  @override
  State<UsersAdminPage> createState() => _UsersAdminPageState();
}

class _UsersAdminPageState extends State<UsersAdminPage> {
  late Future<List<UsuarioDTO>> _usersFuture = Future.value([]); // Usar Future para buscar dados assincronamente
  final UsuarioService _userService = UsuarioService(); // Instância do seu serviço

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() {
     _usersFuture = _userService.getUsuarios(); // Chama o método do seu serviço
    });
  }

  // Função para adicionar um novo usuário
  void _addUsuario() async {
    // Navigator.push para a tela de adicionar usuário (que você já deve ter)
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdicionarUsuarioPage()), // Ou o nome correto da sua tela
    );
    if (result == true) { // Se o usuário foi adicionado com sucesso e a tela retornou true
      _fetchUsers(); // Recarrega a lista de usuários
    }
  }

  // Função para editar um usuário
 // void _editUsuario(UsuarioDTO user) async {
   // final result = await Navigator.push(
    //  context,
     // MaterialPageRoute(
      //  builder: (context) => EditarUsuarioPage(usuario: {user },),
     // ),
  //  );

   // if (result == true) {
   //   _fetchUsers();
   // }
 // }


  // Função para remover um usuário
  void _deleteUsuario(UsuarioDTO user) async {
    // Exibir um diálogo de confirmação antes de deletar
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text('Tem certeza que deseja excluir o usuário ${user.nome}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await _userService.deleteUsuario(user.id!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário excluído com sucesso!')),
        );
        _fetchUsers(); // Recarrega a lista
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
      body: FutureBuilder<List<UsuarioDTO>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar usuários: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum usuário encontrado.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(user.nome ?? 'Usuário sem nome'),
                    subtitle: Text(user.email ?? 'Email não informado'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                       // IconButton(
                        //  icon: const Icon(Icons.edit, color: Colors.blue),
                         // onPressed: () => _editUsuario(user),
                      //  ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteUsuario(user),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Opcional: Navegar para uma tela de detalhes do usuário, se necessário
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => VisualizarUsuarioPage(usuario: user)));
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUsuario,
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
