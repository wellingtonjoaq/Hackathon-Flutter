import 'package:flutter/material.dart';
import 'package:hackathon_flutter/screens/admin/admin_screen.dart';
import 'services/local_storage_service.dart';
import 'models/usuario_dto.dart';
import 'screens/login_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/professor_screen.dart';
import 'screens/aluno_screen.dart';
import 'screens/adicionarProva_screen.dart';
import 'screens/corrigirProva_screen.dart';
import 'screens/resultados_screen.dart';

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
          homeWidget = const LoginScreen();
        } else {
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
          }
        }

        return MaterialApp(
          title: 'Hackathon Corretor',
          theme: ThemeData(primarySwatch: Colors.blue),
          debugShowCheckedModeBanner: false,
          home: homeWidget,

          // ✅ Apenas rotas simples aqui
          routes: {
            '/login': (_) => const LoginScreen(),
            '/adicionarProva': (_) => const AdicionarProvaScreen(),
          },

          // ✅ Rotas com argumentos aqui
          onGenerateRoute: (settings) {
            final args = settings.arguments;
            switch (settings.name) {
              case '/admin':
                if (args is UsuarioDTO) {
                  return MaterialPageRoute(
                      builder: (_) => AdminScreen(usuario: args));
                }
                break;
              case '/professor':
                if (args is UsuarioDTO) {
                  return MaterialPageRoute(
                      builder: (_) => ProfessorScreen(usuario: args));
                }
                break;
              case '/aluno':
                if (args is UsuarioDTO) {
                  return MaterialPageRoute(
                      builder: (_) => AlunoScreen(usuario: args));
                }
                break;
              case '/corrigirProva':
                if (args is UsuarioDTO) {
                  return MaterialPageRoute(
                      builder: (_) => CorrigirProvaScreen(usuario: args));
                }
                break;
              case '/resultados':
                if (args is UsuarioDTO) {
                  return MaterialPageRoute(
                      builder: (_) => ResultadosScreen(usuario: args));
                }
                break;
            }
            // Rota padrão
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          },
        );
      },
    );
  }
}
