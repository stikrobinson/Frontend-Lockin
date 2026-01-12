import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

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
                Row(
                  children: [
                    Expanded(flex: 2, child: Container(color: Colors.white)),
                    Column(
                      spacing: 10,
                      children: [
                        CircularPercentIndicator(
                          radius: 60.0,
                          lineWidth: 5.0,
                          percent: 1.0,
                          center: Text("100%"),
                          progressColor: Colors.green,
                        ),
                        Text("Productividad"),
                      ],
                    ),
                    Expanded(flex: 2, child: Container(color: Colors.white)),
                    Column(
                      spacing: 10,
                      children: [
                        CircularPercentIndicator(
                          radius: 60.0,
                          lineWidth: 5.0,
                          percent: 1.0,
                          center: Text("100%"),
                          progressColor: Colors.green,
                        ),
                        Text("Productividad"),
                      ],
                    ),
                    Expanded(flex: 2, child: Container(color: Colors.white)),
                    Column(
                      spacing: 10,
                      children: [
                        CircularPercentIndicator(
                          radius: 60.0,
                          lineWidth: 5.0,
                          percent: 1.0,
                          center: Text("100%"),
                          progressColor: Colors.green,
                        ),
                        Text("Productividad"),
                      ],
                    ),
                    Expanded(flex: 2, child: Container(color: Colors.white)),
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
