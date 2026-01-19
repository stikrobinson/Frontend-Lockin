import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/estadistica_service.dart'; // <--- Import actualizado

class PantallaEstadistica extends StatefulWidget {
  const PantallaEstadistica({Key? key}) : super(key: key);

  @override
  State<PantallaEstadistica> createState() => _PantallaEstadisticaState();
}

class _PantallaEstadisticaState extends State<PantallaEstadistica> {
  
  final EstadisticaService _estadisticaService = EstadisticaService();
  final _storage = const FlutterSecureStorage();
  
  bool _cargando = true;
  String _nombreUsuario = "Usuario";
  String _nombre="Nombre";
  Map<String, dynamic> _datos = {};

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    String? idStr = await _storage.read(key: 'user_id');
    String? userStr = await _storage.read(key: 'username');
    String? nomStr = await _storage.read (key: 'nombre');
    print(nomStr);
    if (userStr != null) _nombreUsuario = userStr;
    if (nomStr != null) _nombre = nomStr;
    print(_nombre);

    if (idStr != null) {
      // Llamada al servicio con el nombre correcto
      final datosTraidos = await _estadisticaService.getEstadisticasPorUsuario(idStr);
      if (datosTraidos != null) {
        _datos = datosTraidos;
      }
    }

    if (mounted) {
      setState(() {
        _cargando = false;
      });
    }
  }

  // --- Lógica de Porcentaje ---
  String _obtenerPorcentaje() {
    int total = _datos['Total de Objetivos'] ?? 1;
    int completados = _datos['Total de Completados'] ?? 0;
    if (total == 0) return "0%";
    return "${((completados / total) * 100).toStringAsFixed(0)}%";
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return Container(
        color: const Color(0xFFF0F4FF),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      color: const Color(0xFFF0F4FF),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Mi Progreso",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Resumen completo de tu enfoque",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            _buildProfileCard(),

            const SizedBox(height: 16),

            _buildImpactCard(),

            const SizedBox(height: 16),

            // Fila 1
            Row(
              children: [
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSmallStatCard(
                    icon: Icons.access_time,
                    color: Colors.green,
                    value: "${(_datos['Horas Totales'] ?? 0).toStringAsFixed(1)}h",
                    label: "Tiempo total",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Fila 2
            Row(
              children: [
                Expanded(
                  child: _buildSmallStatCard(
                    icon: Icons.emoji_events_outlined,
                    color: Colors.orange,
                    value: "${_datos['Total de Completados'] ?? 0}/${_datos['Total de Objetivos'] ?? 0}",
                    label: "Objetivos",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSmallStatCard(
                    icon: Icons.flash_on,
                    color: Colors.purple,
                    value: "${(_datos['Horas Logeado Totales'] ?? 0).toStringAsFixed(1)}h",
                    label: "Tiempo Focus",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.trending_up,
                  color: Colors.blueAccent,
                ),
                title: const Text(
                  "Progreso Detallado",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("Productividad General"),
                trailing: Text(
                  _obtenerPorcentaje(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue.shade100,
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "¡Hola, $_nombre!",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "Nivel de Progreso: ${_obtenerPorcentaje()}",
              style: const TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      "Compartir en Comunidad",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImpactCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: const [
                Icon(Icons.people_outline, color: Colors.grey, size: 20),
                SizedBox(width: 8),
                Text(
                  "Impacto en la Comunidad",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      (_datos['Personas que has inspirado'] ?? 0).toString(),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    const Text(
                      "Personas inspiradas",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                Container(height: 30, width: 1, color: Colors.grey.shade300),
                Column(
                  children: [
                    Text(
                      (_datos['Apoyo recibido'] ?? 0).toString(),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const Text(
                      "Apoyo recibido",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              "Tu progreso ha motivado a otros miembros de la comunidad",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.blueGrey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallStatCard({
    required IconData icon,
    required Color color,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}