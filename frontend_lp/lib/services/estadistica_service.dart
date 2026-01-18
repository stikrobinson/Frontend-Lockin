import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EstadisticaService {
  // Instancia para leer el token guardado
  final _storage = const FlutterSecureStorage();
  
  // URL Base (Asegúrate que sea la misma que en AuthService)
  final String baseUrl = 'http://127.0.0.1:8000'; 

  // Función para obtener las estadísticas
  // Recibe el userId como String porque así lo guardamos en el storage
  Future<Map<String, dynamic>?> getEstadisticasPorUsuario(String userId) async {
    
    final url = Uri.parse('$baseUrl/api/estadistica/$userId'); 

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
}