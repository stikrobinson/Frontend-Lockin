import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // Instancia para guardar datos seguros
  final _storage = const FlutterSecureStorage();
  
 
  final String baseUrl = 'http://127.0.0.1:8000'; 

  // 1. LOGIN (Modificado para guardar ID y Username)
  Future<bool> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/api/autenticacion/login/'); 
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        
      
  
        await _storage.write(key: 'auth_token', value: data['token']);
        
        await _storage.write(
          key: 'user_id', 
          value: data['user']['id'].toString()
        );

        // 3. Guardamos el Username 
        await _storage.write(
          key: 'username', 
          value: data['user']['username']
        );
        
        await _storage.write(
          key : 'nombre',
          value: data['user']['first_name']
        );
        return true;
      } else {
        print("Error Login: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error conexión Login: $e");
      return false;
    }
  }

  // 2. REGISTER (Modificado para guardar ID y Username al crear cuenta)
  Future<bool> register(String username, String email, String password, String nombre) async {
    final url = Uri.parse('$baseUrl/api/autenticacion/register/');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'first_name': nombre, 
        }),
      );

      if (response.statusCode == 201) {
        var data = jsonDecode(response.body);
        
        
        // Guardamos todo igual que en el login para entrar directo
        await _storage.write(key: 'auth_token', value: data['token']);
        
        await _storage.write(
          key: 'user_id', 
          value: data['user']['id'].toString()
        );

        await _storage.write(
          key: 'username', 
          value: data['user']['username']
        );
        await _storage.write(
          key : 'nombre',
          value: data['user']['first_name']
        );


        return true;
      } else {
        print("Error Registro: ${response.body}");
        return false;
      }
    } catch (e) {
       print("Error conexión Registro: $e");
       return false;
    }
  }


  Future<void> logout() async {
    
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'user_id');
    await _storage.delete(key: 'username');
  }

  // 4. PETICIÓN AUTENTICADA (Sin cambios, solo para testear)
  Future<String> testToken() async {
    final url = Uri.parse('$baseUrl/api/autenticacion/test_token/');
    String? token = await _storage.read(key: 'auth_token');

    if (token == null) return "No hay token guardado";

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token', 
        },
      );

      if (response.statusCode == 200) {
        return response.body; 
      } else {
        return "Error: ${response.statusCode}";
      }
    } catch (e) {
      return "Error de conexión: $e";
    }
  }
}