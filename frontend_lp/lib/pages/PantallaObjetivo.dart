import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend_lp/services/objetivos_service.dart';

var servicio = ObjetivosService();
var _storage = FlutterSecureStorage();

class DatosTablero {
  final int objetivosActivos;
  final int objetivosCompletados;
  final List<ModeloObjetivo> listaObjetivos;

  DatosTablero({
    required this.objetivosActivos,
    required this.objetivosCompletados,
    required this.listaObjetivos,
  });
}

class ModeloObjetivo {
  final String id;
  final String categoria;
  final String titulo;
  final String descripcion;
  final DateTime fechaFinalizacion;

  ModeloObjetivo({
    required this.id,
    required this.categoria,
    required this.titulo,
    required this.descripcion,
    required this.fechaFinalizacion,
  });
}

class Pantallaobjetivo extends StatefulWidget {
  const Pantallaobjetivo({super.key});

  @override
  State<Pantallaobjetivo> createState() => _PantallaobjetivoState();
}

class _PantallaobjetivoState extends State<Pantallaobjetivo> {
  List<ModeloObjetivo> _listaObjetivos = [];
  int _contadorActivos = 0;
  int _contadorCompletados = 0;
  bool _cargando = true;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _cargarDatosDeApi();
  }

  void _cargarDatosDeApi() async {
    try {
      final datos = await servicio.obtenerDatosTablero();
      if (mounted) {
        setState(() {
          _listaObjetivos = datos.listaObjetivos;
          _contadorActivos = datos.objetivosActivos;
          _contadorCompletados = datos.objetivosCompletados;
          _cargando = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _cargando = false);
    }
  }

  void _marcarProgreso(int indice) async {
    final objetivo = _listaObjetivos[indice];
    bool exito = await servicio.marcarCompletado(objetivo);

    if (exito) {
      if (mounted) {
        setState(() {
          _listaObjetivos.removeAt(indice);
          _contadorActivos--;
          _contadorCompletados++;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("¡Objetivo completado y sincronizado!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error al guardar cambios"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatearFecha(DateTime fecha) {
    return "${fecha.day}/${fecha.month}/${fecha.year}";
  }

  void _mostrarDialogoCrear() {
    final _tituloController = TextEditingController();
    final _descController = TextEditingController();
    final _catController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    DateTime? _fechaSeleccionada;

    showDialog(
      context: context,
      barrierDismissible: !_guardando,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Nuevo Objetivo'),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _tituloController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre del Objetivo',
                        ),
                        validator: (v) => v!.isEmpty ? 'Requerido' : null,
                      ),
                      TextFormField(
                        controller: _descController,
                        decoration: const InputDecoration(
                          labelText: 'Descripción',
                        ),
                        validator: (v) => v!.isEmpty ? 'Requerido' : null,
                      ),
                      TextFormField(
                        controller: _catController,
                        decoration: const InputDecoration(
                          labelText: 'Categoría',
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setStateDialog(() => _fechaSeleccionada = picked);
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Fecha de Finalización',
                            border: const OutlineInputBorder(),
                            errorText: _fechaSeleccionada == null
                                ? 'Seleccione fecha'
                                : null,
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            _fechaSeleccionada == null
                                ? 'Toque para seleccionar'
                                : _formatearFecha(_fechaSeleccionada!),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: _guardando ? null : () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: _guardando
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate() &&
                              _fechaSeleccionada != null) {
                            setStateDialog(() => _guardando = true);

                            Map<String, dynamic> datosParaApi = {
                              "nombre": _tituloController.text,
                              "descripcion": _descController.text,
                              "categoria": _catController.text.isEmpty
                                  ? "General"
                                  : _catController.text,
                              "caducidad": _fechaSeleccionada!
                                  .toIso8601String()
                                  .split('T')[0],
                              "id_autor": await _storage.read(key: 'user_id'),
                            };

                            bool exito = await servicio.enviarObjetivo(
                              datosParaApi,
                            );

                            setStateDialog(() => _guardando = false);

                            if (exito) {
                              if (mounted) {
                                Navigator.pop(context);
                                setState(() => _cargando = true);
                                _cargarDatosDeApi();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Objetivo creado exitosamente",
                                    ),
                                  ),
                                );
                              }
                            } else {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Error al crear. Verifica tu conexión.",
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          }
                        },
                  child: _guardando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorPrimario = const Color(0xFF0D47A1);
    final colorFondo = const Color(0xFFF0F4F8);

    if (_cargando) {
      return Scaffold(
        backgroundColor: colorFondo,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: colorFondo,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Objetivos',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: colorPrimario,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Rastrea tu progreso diario',
                style: TextStyle(
                  fontSize: 16,
                  color: colorPrimario.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  _construirTarjetaEstadistica(
                    _contadorActivos.toString(),
                    'Activos',
                    esPrimario: false,
                  ),
                  const SizedBox(width: 16),
                  _construirTarjetaEstadistica(
                    _contadorCompletados.toString(),
                    'Completados',
                    esPrimario: false,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (_listaObjetivos.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          size: 60,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 10),
                        const Text("No hay objetivos pendientes"),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                )
              else
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _listaObjetivos.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, indice) {
                    return _construirTarjetaObjetivo(
                      _listaObjetivos[indice],
                      indice,
                    );
                  },
                ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _mostrarDialogoCrear,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorPrimario,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Crear Objetivo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirTarjetaEstadistica(
    String numero,
    String etiqueta, {
    bool esPrimario = false,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              numero,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: esPrimario ? Colors.blue : const Color(0xFF1E88E5),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              etiqueta,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirTarjetaObjetivo(ModeloObjetivo objetivo, int indice) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    objetivo.categoria,
                    style: const TextStyle(
                      color: Color(0xFF1565C0),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      size: 14,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatearFecha(objetivo.fechaFinalizacion),
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              objetivo.titulo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              objetivo.descripcion,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue[700],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _marcarProgreso(indice),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Marcar Progreso',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
