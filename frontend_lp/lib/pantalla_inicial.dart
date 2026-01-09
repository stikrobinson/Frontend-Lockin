import 'package:flutter/material.dart';

class PantallaInicial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pantalla Inicial')),
      body: Column(
        children: [
          Align(alignment: Alignment.topLeft, child: Text("Hola Pablo ")),

          Center(
            child: Column(children: [FlutterLogo(size: 30), Text("HOla")]),
          ),
        ],
      ),
    );
  }
}
