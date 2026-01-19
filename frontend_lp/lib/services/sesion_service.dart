import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SesionService {
  // Instancia para leer el token guardado
  final _storage = const FlutterSecureStorage();

  // URL Base (Asegúrate que sea la misma que en AuthService)
  final String baseUrl = 'http://127.0.0.1:8000';

  void enviarSesion(Map<String, String> datos) async {
    final url = Uri.parse('$baseUrl/api/sesion_enfoque/create');

    // Recuperamos el token para tener permiso
    String? token = await _storage.read(key: 'auth_token');

    if (token == null) {
      print("Error: No hay token guardado.");
      return;
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token', // Cabecera obligatoria
        },
        body: jsonEncode(datos),
      );

      if (response.statusCode != 201) {
        print("Error del Servidor (${response.statusCode}): ${response.body}");
        return;
      }
    } catch (e) {
      print("Error de conexión al enviar sesión: $e");
      return;
    }
  }

  Future<List<DropdownMenuEntry<int>>> getObjetivos() async {
    final url = Uri.parse('$baseUrl/api/objetivo/data');
    List<DropdownMenuEntry<int>> lista = [];

    // Recuperamos el token para tener permiso
    String? token = await _storage.read(key: 'auth_token');
    String? id_Str = await _storage.read(key: 'user_id');
    int? id = int.tryParse(id_Str ?? "");

    if (token == null) {
      print("Error: No hay token guardado.");
      return lista;
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
        print(id);
        print(json);
        for (var objetivo in json) {
          print(objetivo);
          if (objetivo["id_autor"] == id) {
            lista.add(
              DropdownMenuEntry(
                value: objetivo["id"],
                label: objetivo["nombre"],
              ),
            );
          }
        }
      } else {
        print("Error del Servidor (${response.statusCode}): ${response.body}");
        return lista;
      }
    } catch (e) {
      print("Error de conexión al traer estadísticas: $e");
      return lista;
    }

    return lista;
  }
}
