import 'package:flutter/material.dart';
import 'package:frontend_lp/pages/PantallaEstadistica.dart';
import 'package:frontend_lp/MenuInicial.dart';
import 'package:frontend_lp/pages/PantallaInicial.dart';

class MenuInicial extends StatefulWidget {
  const MenuInicial({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<MenuInicial> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    PantallaInicial(),
    PantallaEstadistica(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pantalla Inicial')),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _navigateBottomBar,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Estadistica',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Objetivos'),
        ],
        // Función al tocar
      ),
    );
  }
}
