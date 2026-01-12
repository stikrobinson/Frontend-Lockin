import 'package:flutter/material.dart';

class PantallaEstadistica extends StatelessWidget {
  const PantallaEstadistica({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0F4FF), // Color de fondo base
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección: Encabezado
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

            // Sección: Tarjeta de Perfil
            _buildProfileCard(),

            const SizedBox(height: 16),

            // Sección: Impacto Comunitario
            _buildImpactCard(),

            const SizedBox(height: 16),

            // Sección: Grilla de métricas (KPIs)
            // Fila 1 de tarjetas
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
            // Fila 2 de tarjetas
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
                    icon: Icons.flash_on,
                    color: Colors.purple,
                    value: "47",
                    label: "Bloqueadas",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Sección: Progreso Detallado (Bottom Card)
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
                trailing: const Text(
                  "78%",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),

            // Espaciado inferior para evitar solapamiento con el BottomNavigationBar
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget constructor para la tarjeta de perfil
  Widget _buildProfileCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Avatar y Badge
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
                    // TODO: Reemplazar con imagen dinámica o de red
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

            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Acción para compartir en comunidad
                    },
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

  // Widget constructor para la tarjeta de impacto
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
                Container(height: 30, width: 1, color: Colors.grey.shade300),
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

  // Widget reutilizable para métricas individuales
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
