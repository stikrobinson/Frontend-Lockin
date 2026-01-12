import 'package:flutter/material.dart';
import 'package:frontend_lp/MenuInicial.dart';
import 'package:frontend_lp/main.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => Pantallaregistro();
}

class Pantallaregistro extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text(
              'Lock-In',
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 28.0,
                fontWeight: FontWeight.w900, // Letra muy gruesa
              ),
            ),
            const Text(
              'Registrate para continuar',
              style: TextStyle(color: Colors.blueGrey, fontSize: 20.0),
            ),

            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 160.0,
                  vertical: 20,
                ),
                child: Column(
                  spacing: 18,
                  mainAxisAlignment: .center,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Nombre",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Correo electronico",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Contraseña',
                      ),
                      obscureText: true,
                    ),

                    ElevatedButton(
                      onPressed: () {
                        print("Boton Iniciar");
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MenuInicial(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Registrarte"),
                    ),
                  ],
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                print("Boton Inicio Sesión");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MyHomePage(title: 'Flutter Demo Home Page'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(foregroundColor: Colors.indigo),
              child: const Text("¿Tienes cuenta? Inicia sesión"),
            ),
          ],
        ),
      ),
    );
  }
}
