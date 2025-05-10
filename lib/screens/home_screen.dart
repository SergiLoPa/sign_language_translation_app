import 'package:flutter/material.dart';
import 'connect_screen.dart';
import 'translation_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Construir las páginas con el callback onChangeTab para ConnectScreen
    final List<Widget> pages = [
      ConnectScreen(onChangeTab: _onItemTapped),
      TranslationScreen(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth_searching),
            label: 'Conectar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.translate),
            label: 'Traducir',
          ),
        ],
      ),
    );
  }
}
