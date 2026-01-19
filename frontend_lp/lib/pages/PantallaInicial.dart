import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; 

class PantallaInicial extends StatefulWidget {
  const PantallaInicial({Key? key}) : super(key: key);

  @override
  State<PantallaInicial> createState() => _PantallaInicialState();
}

class _PantallaInicialState extends State<PantallaInicial> {
  
  final _storage = const FlutterSecureStorage();
  String _nombreUsuario = "Usuario"; 
  @override
  void initState() {
    super.initState();
    _cargarNombre(); 
  }

  
  Future<void> _cargarNombre() async {
    
    String? nombreGuardado = await _storage.read(key: 'username');
    
    if (nombreGuardado != null && mounted) {
      setState(() {
        _nombreUsuario = nombreGuardado;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20), 
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20.0), 
              child: Text(
                "Hola $_nombreUsuario! 😁", 
                style: const TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 25.0, 
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20), 

          Center(
            child: Column(
              spacing: 12,
              children: [
                const FlutterLogo(size: 60), 
                
                ElevatedButton(
                  onPressed: () {
                    
                    print("Boton Compartir Progeso");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: const Text("Compartir tu Progreso"),
                ),
                
                const SizedBox(height: 20),

                // Fila de Indicadores
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                  children: [
                    // Indicador 1
                    Column(
                      children: [
                        CircularPercentIndicator(
                          radius: 40.0, 
                          lineWidth: 5.0,
                          percent: 0.7, // Ejemplo visual
                          center: const Text("70%"),
                          progressColor: Colors.green,
                        ),
                        const SizedBox(height: 5),
                        const Text("Productividad", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    
                    // Indicador 2
                    Column(
                      children: [
                        CircularPercentIndicator(
                          radius: 40.0,
                          lineWidth: 5.0,
                          percent: 0.5,
                          center: const Text("50%"),
                          progressColor: Colors.orange,
                        ),
                        const SizedBox(height: 5),
                        const Text("Objetivos", style: TextStyle(fontSize: 12)),
                      ],
                    ),

                    // Indicador 3
                    Column(
                      children: [
                        CircularPercentIndicator(
                          radius: 40.0,
                          lineWidth: 5.0,
                          percent: 0.9,
                          center: const Text("90%"),
                          progressColor: Colors.purple,
                        ),
                        const SizedBox(height: 5),
                        const Text("Enfoque", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}