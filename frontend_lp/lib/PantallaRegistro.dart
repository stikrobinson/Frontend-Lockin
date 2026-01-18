import 'package:flutter/material.dart';
import 'package:frontend_lp/MenuInicial.dart';
import 'package:frontend_lp/main.dart';
import 'services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => Pantallaregistro();
}

class Pantallaregistro extends State<RegisterPage> {
  final TextEditingController _userController =
      TextEditingController(); // Para el usuario
  final AuthService _authService = AuthService();
  final TextEditingController _emailController =
      TextEditingController(); // Para el email
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
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
                  horizontal: 30.0,
                  vertical: 20,
                ),
                child: Column(
                  spacing: 18,
                  mainAxisAlignment: .center,
                  children: [
                    TextFormField(
                      controller: _userController,
                      decoration: InputDecoration(
                        labelText: "Usuario",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      controller: _nombreController,
                      decoration: InputDecoration(
                        labelText: "Nombre",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Correo electronico",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      controller: _passController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Contraseña',
                      ),
                      obscureText: true,
                    ),

                    ElevatedButton(
                      onPressed: () async {
                        print("Boton Iniciar");
                        bool RegistroCorrecto = await _authService.register(
                          _userController.text,
                          _emailController.text,
                          _passController.text,
                          _nombreController.text,
                        );
                        if (RegistroCorrecto) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MenuInicial(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Error de Resgistro"),
                                content: const Text(
                                  "El usuario o la contraseña son invalidos o existe un error en el sistema.",
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text("Aceptar"),
                                    onPressed: () {
                                      // Cerrar la alerta
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
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
