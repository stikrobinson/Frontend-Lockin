import 'package:flutter/material.dart';

class PantallaEstadistica extends StatelessWidget {
  const PantallaEstadistica({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Usamos un Container para dar ese color de fondo azul claro suave de la imagen
    return Container(
      color: const Color(0xFFF0F4FF), // Color de fondo suave
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Títulos Superiores ---
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

            // --- TARJETA 1: Perfil Principal ---
            _buildProfileCard(),

            const SizedBox(height: 16),

            // --- TARJETA 2: Impacto en la comunidad ---
            _buildImpactCard(),

            const SizedBox(height: 16),

            // --- GRILLA DE ESTADÍSTICAS (4 tarjetas pequeñas) ---
            // Fila 1
            Row(
              children: [
                Expanded(
                  child: _buildSmallStatCard(
                    icon: Icons.check_circle_outline,
                    color: Colors.blue,
                    value: "12",
                    label: "Días consecutivos",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSmallStatCard(
                    icon: Icons.access_time,
                    color: Colors.green,
                    value: "20h",
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
                    value: "3/5",
                    label: "Objetivos",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSmallStatCard(
                    icon: Icons.flash_on, // Icono de rayo/bloqueo
                    color: Colors.purple,
                    value: "47",
                    label: "Bloqueadas",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // --- TARJETA INFERIOR: Progreso Detallado ---
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: Icon(Icons.trending_up, color: Colors.blueAccent),
                title: Text(
                  "Progreso Detallado",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Productividad General"),
                trailing: Text(
                  "78%",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),

            // Espacio extra al final para que no choque con el navigation bar
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- WIDGET AUXILIAR: Tarjeta de Perfil ---
  Widget _buildProfileCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Avatar con Badge "Elite"
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
                    // Aquí iría la imagen: backgroundImage: AssetImage('assets/avatar.png'),
                  ),
                ),
                Positioned(
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent, // Color del badge
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Elite",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              "¡Hola, Alex!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              "Nivel de Progreso: 83%",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),

            // Botones
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.purpleAccent, // Color parecido a la imagen
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
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blueAccent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      "Compartir Afuera",
                      style: TextStyle(fontSize: 12, color: Colors.blueAccent),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET AUXILIAR: Tarjeta de Impacto ---
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
                  children: const [
                    Text(
                      "8",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    Text(
                      "Personas inspiradas",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                Container(
                  height: 30,
                  width: 1,
                  color: Colors.grey.shade300,
                ), // Separador vertical
                Column(
                  children: const [
                    Text(
                      "15",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Text(
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

  // --- WIDGET AUXILIAR: Tarjeta Pequeña de Estadística ---
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
