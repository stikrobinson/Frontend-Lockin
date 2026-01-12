import 'package:flutter/material.dart';

class Pantallacomunidad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Comunidad"),
          Text("Apoyo mutuo sin toxicidad"),
          Row(
            spacing: 6,
            children: [
              ElevatedButton(onPressed: () => {}, child: Text("Todos")),
              ElevatedButton(onPressed: () => {}, child: Text("Logros")),
              ElevatedButton(onPressed: () => {}, child: Text("Ayuda")),
              ElevatedButton(onPressed: () => {}, child: Text("Motivación")),
            ],
          ),
          Text("6 publicaciones"),
          CardPublicaciones(
            "Pablo",
            "Me gusta esta app",
            "Logro",
            2,
            DateTime.now(),
          ),
          CardPublicaciones(
            "Pablo",
            "Me gusta esta app",
            "Motivación",
            2,
            DateTime.now(),
          ),
          CardPublicaciones(
            "Pepe",
            "Me gusta esta app",
            "Ayuda",
            2000,
            DateTime.now(),
          ),

          Row(
            children: [
              const SizedBox(width: 100, height: 60),
              Expanded(
                child: IntrinsicWidth(
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
                      "Compartir mi Progreso",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 100, height: 60),
            ],
          ),
        ],
      ),
    );
  }

  Widget CardPublicaciones(
    String usuario,
    String mensaje,
    String categoria,
    int corazones,
    DateTime fecha,
  ) {
    return Card(
      margin: const EdgeInsets.all(20.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          spacing: 10,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(usuario),
                    Text(
                      "${DateTime.now().hour - fecha.hour} h",
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 131, 205, 240),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text("  $categoria  "),
                ),
              ],
            ),
            Text(mensaje),
            IntrinsicWidth(
              child: ElevatedButton(
                onPressed: () {},
                child: Row(
                  children: [Icon(Icons.favorite_border), Text("$corazones")],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
