import 'package:flutter/material.dart';

class ConnectScreen extends StatefulWidget {
  final void Function(int) onChangeTab;

  const ConnectScreen({Key? key, required this.onChangeTab}) : super(key: key);

  @override
  _ConnectScreenState createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  bool _isConnected = false;
  String _deviceName = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // AppBar alternative
            Text(
              'Conectar Dispositivo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),

            // Estado de conexión
            Text(
              _isConnected
                  ? 'Conectado a: $_deviceName'
                  : 'Dispositivo no conectado',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 32),

            // Botón para buscar y conectar
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isConnected = true;
                  _deviceName = 'Glove_01';
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Buscar Dispositivos',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Botón para continuar a traducción
            ElevatedButton(
              onPressed: _isConnected ? () => widget.onChangeTab(1) : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Comenzar Traducción',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
