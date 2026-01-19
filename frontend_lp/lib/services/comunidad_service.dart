import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ComunidadService {
  
  final _storage = const FlutterSecureStorage();
  
  // URL Base (Asegúrate que sea la misma que en AuthService)
  final String baseUrl = 'http://127.0.0.1:8000'; 


  // Recibe el userId como String porque así lo guardamos en el storage
  Future<List<dynamic>?> getAllPost() async {
    
    final url = Uri.parse('$baseUrl/api/objetivo/data'); 

    // Recuperamos el token para tener permiso
    String? token = await _storage.read(key: 'auth_token');

    if (token == null) {
      print("Error: No hay token guardado.");
      return null;
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token', // Cabecera obligatoria
        },
      );

      if (response.statusCode == 200) {
        
        return jsonDecode(response.body);
      } else {
        print("Error del Servidor (${response.statusCode}): ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error de conexión al traer estadísticas: $e");
      return null;
    }
  }

  Future<String?> getNombre(int userId) async {
    
    final url = Uri.parse('$baseUrl/api/autenticacion/usuario/$userId'); 

    // Recuperamos el token para tener permiso
    String? token = await _storage.read(key: 'auth_token');

    if (token == null) {
      print("Error: No hay token guardado.");
      return null;
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token', // Cabecera obligatoria
        },
      );

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var nombre = json['username'];

        return nombre;
      } else {
        print("Error del Servidor (${response.statusCode}): ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error de conexión al traer nombre: $e");
      return null;
    }
  }

}