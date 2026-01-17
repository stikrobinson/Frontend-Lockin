import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class AuthService {
  // Instancia para guardar datos seguros
  final _storage = const FlutterSecureStorage();
  final String baseUrl = 'http://127.0.0.1:8000';

  // 1. LOGIN (Para obtener el token)
  Future<bool> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/api/autenticacion/login/'); // Ajusta tu ruta de login
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Suponiendo que tu backend devuelve: {"token": "f9403fc...", "user": ...}
      var data = jsonDecode(response.body);
      
      // GUARDAR EL TOKEN EN EL CELULAR
      await _storage.write(key: 'auth_token', value: data['token']);
      return true;
    } else {
      return false;
    }
  }

  // 2. PETICIÓN AUTENTICADA (Ejemplo con tu view test_token)
  Future<String> testToken() async {
    final url = Uri.parse('$baseUrl/api/autenticacion/test_token/');
    
    // Recuperamos el token guardado
    String? token = await _storage.read(key: 'auth_token');

    if (token == null) return "No hay token guardado";

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        // IMPORTANTE: Django Token Auth espera "Token <clave>"
        'Authorization': 'Token $token', 
      },
    );

    if (response.statusCode == 200) {
      return response.body; // Debería devolver "Pasado con tu@email.com"
    } else {
      return "Error: ${response.statusCode}";
    }
  }


  Future<bool> register(String username, String email, String password, String nombre) async {
    final url = Uri.parse('$baseUrl/api/autenticacion/register/'); // Ajusta tu ruta de login    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username':username,
        'email': email,
        'password': password,
        'first_name': nombre,
      }),
    );

    if (response.statusCode == 201) {
      // Suponiendo que tu backend devuelve: {"token": "f9403fc...", "user": ...}
      var data = jsonDecode(response.body);
      
      // GUARDAR EL TOKEN EN EL CELULAR
      await _storage.write(key: 'auth_token', value: data['token']);
      return true;
    } else {
      return false;
    }
  }
  // 3. LOGOUT
  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
  }
}