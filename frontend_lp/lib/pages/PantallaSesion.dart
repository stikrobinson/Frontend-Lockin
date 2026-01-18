import 'dart:async';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter/material.dart';

final ValueNotifier<bool> activarBoton = ValueNotifier<bool>(false);

class ContadorSesion extends StatefulWidget {
  const ContadorSesion({super.key});

  @override
  State<ContadorSesion> createState() => _ContadorSesionState();
}

class _ContadorSesionState extends State<ContadorSesion> {
  int _tiempoSegundoPlano = 0;
  late StreamSubscription _subscription;
  var _tiempo = 1500.0;
  var _porcentaje = 0.0;
  late Timer _temporizador;
  late Timer _contadorSegundoPlano;
  var _tiempoString = "25:00";
  var _estado = "Pausado";

  String _convertirTiempo() {
    var minutos = _tiempo ~/ 60;
    var segundos = _tiempo % 60;
    return "${minutos < 10 ? "0$minutos" : "$minutos"}:${segundos < 10 ? "0$segundos" : "$segundos"}";
  }

  void _activarContador() {
    _subscription = FGBGEvents.instance.stream.listen((event) {
      if (event == FGBGType.background) {
        _contadorSegundoPlano = Timer.periodic(const Duration(seconds: 1), (
          Timer t,
        ) {
          setState(() {
            _tiempoSegundoPlano++;
          });
        });
      } else {
        _contadorSegundoPlano.cancel();
      }
    });
    setState(() {
      _estado = "Enfocado";
    });
    _temporizador = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      _tiempo--;
      setState(() {
        _tiempoString = _convertirTiempo();
        _porcentaje += 1 / 1500;
      });
      if (_tiempo <= 0) {
        _reiniciarContador();
      }
    });
  }

  void _desactivarContador() {
    setState(() {
      _tiempoString = _convertirTiempo();
      _estado = "Pausado";
    });
    _temporizador.cancel();
    _subscription.cancel();
  }

  void _reiniciarContador() {
    _tiempo = 1500.0;
    _tiempoSegundoPlano = 0;
    setState(() {
      _tiempoString = "25:00";
      _estado = "Pausado";
      _porcentaje = 0.0;
    });
    _temporizador.cancel();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 100.0,
              width: 100.0,
              child: CircularProgressIndicator(
                value: _porcentaje,
                color: Colors.blue,
                backgroundColor: Colors.grey,
                strokeWidth: 8.0,
              ),
            ),
            Column(
              children: [
                Text(
                  _tiempoString,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 3, 61, 109),
                    fontWeight: FontWeight.w900,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  _estado,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 3, 61, 109),
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ],
        ),
        Column(
          spacing: 5,
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: activarBoton,
              builder: (context, value, child) {
                String texto = _estado == "Pausado" ? "Empezar" : "Terminar";
                return ElevatedButton(
                  onPressed: value
                      ? () {
                          if (_estado == "Pausado") {
                            _activarContador();
                          } else {
                            _desactivarContador();
                          }
                        }
                      : null,
                  child: Text(texto),
                );
              },
            ),
            ValueListenableBuilder<bool>(
              valueListenable: activarBoton,
              builder: (context, value, child) {
                return ElevatedButton(
                  onPressed: value ? _reiniciarContador : null,
                  child: Text("Reiniciar"),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class Pantallasesion extends StatelessWidget {
  var contador = ContadorSesion();

  @override
  Widget build(BuildContext context) {
    activarBoton.value = false;
    return Center(
      child: Column(
        spacing: 10,
        children: [
          Column(
            children: [
              Column(
                children: [
                  Text(
                    "Sesión de Enfoque",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 3, 61, 109),
                      fontWeight: FontWeight.w900,
                      fontSize: 24.0,
                    ),
                  ),
                  Text(
                    "Mantén la concentración",
                    style: TextStyle(color: Color.fromARGB(255, 5, 80, 141)),
                  ),
                ],
              ),
            ],
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 30,
                horizontal: 100,
              ),
              child: Column(
                spacing: 5,
                children: [
                  Text(
                    "Selecciona tu objetivo",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 3, 61, 109),
                      fontWeight: FontWeight.w900,
                      fontSize: 16.0,
                    ),
                  ),
                  DropdownMenu(
                    hintText: "Objetivo",
                    width: 175,
                    enableSearch: false,
                    enableFilter: false,
                    requestFocusOnTap: false,
                    dropdownMenuEntries: [
                      DropdownMenuEntry(value: "hola", label: "hola"),
                      DropdownMenuEntry(value: "chao", label: "chao"),
                      DropdownMenuEntry(value: "talvez", label: "talvez"),
                    ],
                    onSelected: (value) {
                      activarBoton.value = true;
                    },
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(
                vertical: 30,
                horizontal: 135,
              ),
              child: contador,
            ),
          ),
        ],
      ),
    );
  }
}
