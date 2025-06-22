import 'package:flutter/material.dart';
import 'services/local_storage_service.dart';
import 'models/usuario_dto.dart';
import 'screens/login_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/professor_screen.dart';
import 'screens/aluno_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<UsuarioDTO?> _getUsuario() async {
    final storage = LocalStorageService();
    return await storage.getUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UsuarioDTO?>(
      future: _getUsuario(),
      builder: (context, snapshot) {
        // Mostrar loading apenas enquanto estiver carregando
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final usuario = snapshot.data;

        Widget homeWidget;

        if (usuario == null) {
          // Usuário não está logado, mostrar tela de login
          homeWidget = const LoginScreen();
        } else {
          // Redirecionar conforme perfil
          switch (usuario.perfil.toUpperCase()) {
            case 'ADMINISTRADOR':
              homeWidget = AdminScreen(usuario: usuario);
              break;
            case 'PROFESSOR':
              homeWidget = ProfessorScreen(usuario: usuario);
              break;
            case 'ALUNO':
              homeWidget = AlunoScreen(usuario: usuario);
              break;
            default:
              homeWidget = const LoginScreen();
              break;
          }
        }

        return MaterialApp(
          title: 'Hackathon Corretor',
          theme: ThemeData(primarySwatch: Colors.blue),
          debugShowCheckedModeBanner: false,
          home: homeWidget,
          routes: {
            '/login': (_) => const LoginScreen(),
          },
          onGenerateRoute: (settings) {
            final args = settings.arguments;
            switch (settings.name) {
              case '/admin':
                if (args is UsuarioDTO) {
                  return MaterialPageRoute(builder: (_) => AdminScreen(usuario: args));
                }
                break;
              case '/professor':
                if (args is UsuarioDTO) {
                  return MaterialPageRoute(builder: (_) => ProfessorScreen(usuario: args));
                }
                break;
              case '/aluno':
                if (args is UsuarioDTO) {
                  return MaterialPageRoute(builder: (_) => AlunoScreen(usuario: args));
                }
                break;
            }
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          },
        );
      },
    );
  }
}
