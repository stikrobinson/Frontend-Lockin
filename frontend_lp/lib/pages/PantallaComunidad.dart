import 'package:flutter/material.dart';
import '../services/comunidad_service.dart';

class Pantallacomunidad extends StatefulWidget {
  const Pantallacomunidad({Key? key}) : super(key: key);

  @override
  State<Pantallacomunidad> createState() => _PantallacomunidadState();
}

class _PantallacomunidadState extends State<Pantallacomunidad> {
  final ComunidadService _comunidadService = ComunidadService();

  // Lista para almacenar los posts
  List<Map<String, dynamic>> _publicacionesEnriquecidas = [];
  bool _cargando = true;

  // Controladores: SOLO MENSAJE (El título fue eliminado)
  final TextEditingController _mensajeController = TextEditingController();
  String _categoriaSeleccionada = "Logro"; 

  @override
  void initState() {
    super.initState();
    _cargarPublicaciones();
  }

  @override
  void dispose() {
    // Solo limpiamos el mensaje, el título ya no existe
    _mensajeController.dispose();
    super.dispose();
  }

  // --- 1. LÓGICA PARA LEER POSTS ---
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

        String? nombrePosible = await _comunidadService.getNombre(idAutor);
        String nombreReal = nombrePosible ?? "Usuario $idAutor";

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

  // --- 2. LÓGICA PARA CREAR POST (POP-UP) ---
  void _mostrarDialogoPublicar() {
    // Limpiamos el campo antes de abrir
    _mensajeController.clear(); 
    
    showDialog(
      context: context,
      barrierDismissible: false, // Evita cerrar dando clic afuera por error
      builder: (BuildContext context) {
        String categoriaLocal = _categoriaSeleccionada;

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text("Compartir Progreso", style: TextStyle(color: Colors.purple)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // --- YA NO HAY TÍTULO ---
                    
                    // Campo Mensaje
                    TextField(
                      controller: _mensajeController,
                      maxLines: 4, // Un poco más alto para escribir mejor
                      decoration: const InputDecoration(
                        labelText: "Mensaje",
                        hintText: "¿Qué lograste hoy?",
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // Dropdown Categoría
                    Row(
                      children: [
                        const Text("Categoría: "),
                        const SizedBox(width: 10),
                        DropdownButton<String>(
                          value: categoriaLocal,
                          items: <String>['Logro', 'Ayuda', 'Motivación', 'General']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setStateDialog(() {
                              categoriaLocal = newValue!;
                              _categoriaSeleccionada = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // 1. Validar campo
                    if (_mensajeController.text.isEmpty) {
                       ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Escribe un mensaje para publicar")),
                        );
                        return;
                    }

                    // Cerrar diálogo y mostrar carga
                    Navigator.of(context).pop();
                    setState(() => _cargando = true);

                    // 2. LLAMADA AL SERVICIO (SOLO 2 ARGUMENTOS AHORA)
                    bool exito = await _comunidadService.enviarPost(
                      _mensajeController.text, // Solo mensaje
                      _categoriaSeleccionada,  // Categoría
                    );

                    // Limpiar controlador
                    _mensajeController.clear();

                    // 3. Manejar resultado
                    if (exito) {
                      await _cargarPublicaciones(); // Recargar lista
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("¡Publicado con éxito!")),
                        );
                      }
                    } else {
                       if (mounted) {
                         setState(() => _cargando = false);
                         ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Error al publicar"), backgroundColor: Colors.red),
                        );
                       }
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
                  child: const Text("Publicar", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // --- 3. UI PRINCIPAL ---
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text(
            "Comunidad",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple),
          ),
          const Text("Apoyo mutuo sin toxicidad"),
          const SizedBox(height: 10),

          // Filtros (Visuales)
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
                ElevatedButton(onPressed: () {}, child: const Text("Motivación")),
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
              
              // Lógica de contenido:
              // Si el backend envía "mensaje", usamos eso.
              // Si envía "nombre" y "descripcion" (antiguo), los unimos.
              String contenido = "";
              if (post['mensaje'] != null) {
                contenido = post['mensaje'];
              } else {
                contenido = "${post['nombre'] ?? ''}\n\n${post['descripcion'] ?? ''}";
              }

              String fechaStr = post['fecha_publicacion'] ?? post['caducidad'] ?? "";

              return CardPublicaciones(
                post['nombre_autor_real'] ?? "Desconocido",
                contenido.trim(), 
                post['categoria'] ?? post['etiqueta'] ?? "General",
                0, 
                DateTime.tryParse(fechaStr) ?? DateTime.now(),
              );
            }).toList(),

          const SizedBox(height: 20),

          // Botón compartir
          Row(
            children: [
              const SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  onPressed: _mostrarDialogoPublicar, // Abre el Pop-up corregido
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("Compartir mi Progreso", style: TextStyle(fontSize: 12, color: Colors.white)),
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

  // --- 4. WIDGET DE TARJETA INDIVIDUAL ---
  Widget CardPublicaciones(String usuario, String mensaje, String categoria, int corazones, DateTime fecha) {
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
                    Text(usuario, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(tiempoTexto, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 131, 205, 240),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(categoria, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
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