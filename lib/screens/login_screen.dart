import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/usuario_dto.dart';
import 'home_screen.dart';  // importe sua tela Home aqui

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    try {
      final UsuarioDTO? usuario = await _apiService.login(username, password);

      setState(() => _isLoading = false);

      if (usuario != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login efetuado com sucesso! Bem-vindo, ${usuario.nome}'),
            backgroundColor: Colors.green,
          ),
        );

        // Navegue para a próxima tela, exemplo:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(usuario: usuario)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Falha no login. Verifique as credenciais.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro inesperado ao tentar logar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.school, size: 80, color: Colors.blueAccent),
              const SizedBox(height: 20),
              const Text(
                'Corretor de Provas',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: _inputDecoration('Usuário', Icons.person),
                      validator: (value) =>
                      value == null || value.isEmpty ? 'Informe o usuário' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: _inputDecoration('Senha', Icons.lock),
                      obscureText: true,
                      validator: (value) =>
                      value == null || value.isEmpty ? 'Informe a senha' : null,
                    ),
                    const SizedBox(height: 30),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _submit,
                        child: const Text('Entrar', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.white,
    );
  }
}
