import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../providers/bluetooth_provider.dart'; // Importa el provider

class ConnectScreen extends StatefulWidget {
  final void Function(int) onChangeTab;

  const ConnectScreen({Key? key, required this.onChangeTab}) : super(key: key);

  @override
  _ConnectScreenState createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  List<BluetoothDiscoveryResult> _devices = [];
  bool _isDiscovering = false;

  @override
  void initState() {
    super.initState();
    _startDiscovery();
  }

  void _startDiscovery() {
    setState(() {
      _devices.clear();
      _isDiscovering = true;
    });

    FlutterBluetoothSerial.instance
        .startDiscovery()
        .listen((result) {
          setState(() {
            if (!_devices.any(
              (r) => r.device.address == result.device.address,
            )) {
              _devices.add(result);
            }
          });
        })
        .onDone(() => setState(() => _isDiscovering = false));
  }

  Future<void> _connect(
    BluetoothDevice device,
    BluetoothProvider provider,
  ) async {
    try {
      await provider.connect(
        device,
      ); // <-- Envía el dispositivo, no solo la dirección
      print('✔️ Conectado a ${device.name ?? device.address}');
    } catch (e) {
      print('❌ Error conectando a ${device.address}: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BluetoothProvider>(context);
    final isConnected =
        provider.connection != null && provider.connection!.isConnected;
    final deviceName = isConnected
        ? (provider.connectedDevice?.name?.isNotEmpty == true
              ? provider.connectedDevice!.name!
              : provider.connectedDevice!.address)
        : '';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'Bluetooth Clásico',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              isConnected
                  ? 'Conectado a: $deviceName'
                  : (_isDiscovering
                        ? 'Buscando dispositivos...'
                        : 'No conectado'),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(_isDiscovering ? Icons.stop : Icons.search),
              label: Text(
                _isDiscovering ? 'Detener búsqueda' : 'Buscar dispositivos',
              ),
              onPressed: _isDiscovering
                  ? () => FlutterBluetoothSerial.instance.cancelDiscovery()
                  : _startDiscovery,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _devices.isEmpty
                  ? Center(
                      child: Text(
                        _isDiscovering
                            ? 'Escaneando...'
                            : 'No se han encontrado dispositivos.',
                      ),
                    )
                  : ListView.builder(
                      itemCount: _devices.length,
                      itemBuilder: (ctx, i) {
                        final r = _devices[i];
                        final bd = r.device;
                        final name = bd.name?.isNotEmpty == true
                            ? bd.name!
                            : bd.address;
                        final alreadyConnected =
                            isConnected &&
                            bd.address == provider.connectedDevice?.address;
                        return ListTile(
                          leading: Icon(Icons.bluetooth),
                          title: Text(name),
                          subtitle: Text(bd.address),
                          trailing: alreadyConnected
                              ? Icon(Icons.check, color: Colors.green)
                              : null,
                          onTap: () => _connect(bd, provider),
                        );
                      },
                    ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: isConnected ? () => widget.onChangeTab(1) : null,
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
