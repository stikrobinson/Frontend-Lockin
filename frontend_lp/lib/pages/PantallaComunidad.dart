import 'package:flutter/material.dart';
import '../services/comunidad_service.dart';

class Pantallacomunidad extends StatefulWidget {
  const Pantallacomunidad({Key? key}) : super(key: key);

  @override
  State<Pantallacomunidad> createState() => _PantallacomunidadState();
}

class _PantallacomunidadState extends State<Pantallacomunidad> {
  final ComunidadService _comunidadService = ComunidadService();

  // IMPORTANTE: Inicializar con [] para evitar errores de "length called on null"
  List<Map<String, dynamic>> _publicacionesEnriquecidas = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarPublicaciones();
  }

  /// Carga los posts y busca el nombre del autor para cada uno
  Future<void> _cargarPublicaciones() async {
    try {
      final listaCruda = await _comunidadService.getAllPost();

      if (listaCruda == null || listaCruda.isEmpty) {
        if (mounted) {
          setState(() {
            _cargando = false;
            _publicacionesEnriquecidas = [];
          });
        }
        return;
      }

      List<Map<String, dynamic>> listaFinal = [];

      for (var post in listaCruda) {
        if (post['id_autor'] == null) continue;

        int idAutor = post['id_autor'];

        // Intentamos obtener el nombre, si falla usamos "Usuario ID"
        String? nombrePosible = await _comunidadService.getNombre(idAutor);
        String nombreReal = nombrePosible ?? "Usuario $idAutor";

        // Creamos una copia del post con el nombre real inyectado
        Map<String, dynamic> postConNombre = Map.from(post);
        postConNombre['nombre_autor_real'] = nombreReal;

        listaFinal.add(postConNombre);
      }

      if (mounted) {
        setState(() {
          _publicacionesEnriquecidas = listaFinal;
          _cargando = false;
        });
      }
    } catch (e) {
      print("Error cargando posts: $e");
      if (mounted) {
        setState(() {
          _cargando = false;
          _publicacionesEnriquecidas = [];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text(
            "Comunidad",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
          const Text("Apoyo mutuo sin toxicidad"),
          const SizedBox(height: 10),

          // Filtros
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 10),
                ElevatedButton(onPressed: () {}, child: const Text("Todos")),
                const SizedBox(width: 6),
                ElevatedButton(onPressed: () {}, child: const Text("Logros")),
                const SizedBox(width: 6),
                ElevatedButton(onPressed: () {}, child: const Text("Ayuda")),
                const SizedBox(width: 6),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Motivación"),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),

          const SizedBox(height: 10),
          Text("${_publicacionesEnriquecidas.length} publicaciones"),

          // Lista de Publicaciones
          if (_cargando)
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            )
          else if (_publicacionesEnriquecidas.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("No hay publicaciones aún."),
            )
          else
            ..._publicacionesEnriquecidas.map((post) {
              return CardPublicaciones(
                post['nombre_autor_real'] ?? "Desconocido",
                "${post['nombre']}\n\n${post['descripcion']}",
                post['categoria'] ?? "General",
                0,
                DateTime.tryParse(post['caducidad']) ?? DateTime.now(),
              );
            }).toList(),

          const SizedBox(height: 20),

          // Botón compartir
          Row(
            children: [
              const SizedBox(width: 20),
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
                    "Compartir mi Progreso",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
          const SizedBox(height: 40),
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
    // Lógica visual de tiempo
    final horasPasadas = DateTime.now().difference(fecha).inHours;
    final tiempoTexto = horasPasadas > 24
        ? "${(horasPasadas / 24).round()} d"
        : "$horasPasadas h";

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      usuario,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      tiempoTexto,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 131, 205, 240),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    categoria,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(mensaje),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: IntrinsicWidth(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.pink,
                    elevation: 0,
                    side: BorderSide(color: Colors.pink.shade100),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.favorite_border, size: 18),
                      const SizedBox(width: 5),
                      Text("$corazones"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
