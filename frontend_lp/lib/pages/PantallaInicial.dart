import 'package:flutter/material.dart';

class PantallaInicial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // body : _pages[_selectedIndex]
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Hola Pablo! 😁",
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          Center(
            child: Column(
              spacing: 12,
              children: [
                FlutterLogo(size: 30),
                Text("a"),
                ElevatedButton(
                  onPressed: () {
                    print("Boton Compartir Progeso");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Compartir tu Progreso"),
                ),
                Placeholder(
                  fallbackWidth: 40.0,
                  fallbackHeight: 40.0,
                ), //PlaceHolder para los datos estadisticos
              ],
            ),
          ),
        ],
      ),
    );
  }
}
