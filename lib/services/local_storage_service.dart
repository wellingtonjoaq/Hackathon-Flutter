import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario_dto.dart';

class LocalStorageService {
  static const _usuarioKey = 'usuario_logado';

  Future<void> salvarUsuario(UsuarioDTO usuario) async {
    final prefs = await SharedPreferences.getInstance();
    final usuarioJson = jsonEncode(usuario.toJson());
    await prefs.setString(_usuarioKey, usuarioJson);
  }

  Future<UsuarioDTO?> getUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final usuarioJson = prefs.getString(_usuarioKey);
    if (usuarioJson == null) return null;
    final data = jsonDecode(usuarioJson);
    return UsuarioDTO.fromJson(data);
  }

  Future<void> limparUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usuarioKey);
  }
}
