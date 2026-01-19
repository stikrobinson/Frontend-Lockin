import 'dart:convert';
import "package:frontend_lp/pages/PantallaObjetivo.dart";
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ObjetivosService {
  // Instancia para leer el token guardado
  final _storage = const FlutterSecureStorage();

  // URL Base (Asegúrate que sea la misma que en AuthService)
  final String baseUrl = 'http://127.0.0.1:8000';

  Future<bool> marcarCompletado(ModeloObjetivo objetivo) async {
    final url = Uri.parse('$baseUrl/api/objetivo/put/${objetivo.id}/');
    String? token = await _storage.read(key: 'auth_token');

    if (token == null) return false;

    final Map<String, dynamic> datosActualizados = {
      "nombre": objetivo.titulo,
      "descripcion": objetivo.descripcion,
      "categoria": objetivo.categoria,
      "caducidad": objetivo.fechaFinalizacion.toIso8601String().split('T')[0],
      "id_autor": await _storage.read(key: 'user_id'),
      "completado": true,
    };

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: jsonEncode(datosActualizados),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> enviarObjetivo(Map<String, dynamic> datos) async {
    final url = Uri.parse('$baseUrl/api/objetivo/create');

    // Recuperamos el token para tener permiso
    String? token = await _storage.read(key: 'auth_token');

    if (token == null) {
      print("Error: No hay token guardado.");
      return false;
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: jsonEncode(datos),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print("Error del Servidor (${response.statusCode}): ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error de conexión al enviar objetivo: $e");
      return false;
    }
  }

  Future<DatosTablero> obtenerDatosTablero() async {
    final url = Uri.parse('$baseUrl/api/objetivo/data');
    List<ModeloObjetivo> listaObjetivos = [];

    String? token = await _storage.read(key: 'auth_token');
    String? idStr = await _storage.read(key: 'user_id');
    int? idUsuario = int.tryParse(idStr ?? "");

    if (token == null || idUsuario == null) {
      print("Error: Credenciales no encontradas.");
      return DatosTablero(
        objetivosActivos: 0,
        objetivosCompletados: 0,
        listaObjetivos: [],
      );
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        for (var item in jsonResponse) {
          if (item["id_autor"] == idUsuario && item["completado"] == false) {
            listaObjetivos.add(
              ModeloObjetivo(
                id: item["id"].toString(),
                categoria: item["categoria"] ?? "General",
                titulo: item["nombre"] ?? "Sin título",
                descripcion: item["descripcion"] ?? "Sin descripción detallada",
                fechaFinalizacion: item["fecha_finalizacion"] != null
                    ? DateTime.parse(item["fecha_finalizacion"])
                    : DateTime.now().add(const Duration(days: 1)),
              ),
            );
          }
        }

        // Retornamos los datos reales
        return DatosTablero(
          objetivosActivos: listaObjetivos.length,
          objetivosCompletados: 0,
          listaObjetivos: listaObjetivos,
        );
      } else {
        print("Error del Servidor (${response.statusCode}): ${response.body}");
        throw Exception('Error en el servidor');
      }
    } catch (e) {
      print("Error de conexión: $e");
      return DatosTablero(
        objetivosActivos: 0,
        objetivosCompletados: 0,
        listaObjetivos: [],
      );
    }
  }
}
