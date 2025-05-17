import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter/foundation.dart';

class BluetoothProvider with ChangeNotifier {
  BluetoothConnection? _connection;
  BluetoothDevice? _connectedDevice;

  BluetoothConnection? get connection => _connection;
  BluetoothDevice? get connectedDevice => _connectedDevice;

  Future<void> connect(BluetoothDevice device) async {
    // <-- Recibe el dispositivo completo
    _connection = await BluetoothConnection.toAddress(device.address);
    _connectedDevice = device; // <-- Usa el dispositivo real
    _setupConnectionListener();
    notifyListeners();
  }

  Future<void> disconnect() async {
    await _connection?.close();
    _connection = null;
    _connectedDevice = null;
    notifyListeners();
  }

  void _setupConnectionListener() {
    _connection?.input?.listen(null).onDone(() {
      disconnect();
    });
  }
}
