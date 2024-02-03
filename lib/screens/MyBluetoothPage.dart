import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:typed_data';

class BlueScreen extends StatefulWidget {
  const BlueScreen({Key? key}) : super(key: key);

  @override
  _BlueScreenState createState() => _BlueScreenState();
}

class _BlueScreenState extends State<BlueScreen> {
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  List<BluetoothDiscoveryResult> _devices = [];
  BluetoothDiscoveryResult? _selectedDevice;

  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }

  Future<void> _initBluetooth() async {
    await FlutterBluetoothSerial.instance.requestEnable();
  }

  Future<void> _startScan() async {
    setState(() {
      _devices.clear(); // Clear existing devices before starting a new scan
      _selectedDevice = null; // Clear selected device
    });

    _bluetooth.startDiscovery().listen((device) {
      setState(() {
        _devices.add(device);
      });
    });
  }

  Future<void> _connectToDevice() async {
    if (_selectedDevice != null) {
      try {
        BluetoothConnection connection =
        await BluetoothConnection.toAddress(_selectedDevice!.device.address);
        print('Connected to ${_selectedDevice!.device.name}');
        // Now you can send or listen for data using _sendDataFromBluetooth or _listenForData functions
      } catch (e) {
        print('Error connecting to ${_selectedDevice!.device.name}: $e');
      }
    }
  }

  void _sendDataFromBluetooth(BluetoothConnection connection, String myData) async {
    connection.output.add(Uint8List.fromList(myData.codeUnits));
    await connection.output.allSent;
  }

  void _listenForData(BluetoothConnection connection) {
    connection.input?.listen((data) {
      String text = String.fromCharCodes(data);
      print('Received data: $text');
    }).onDone(() {
      print('Connection closed');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Flutter App'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => _startScan().then((_) => _showDevicesDialog()),
            child: Text('Scan for Devices'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_devices[index].device.name ?? 'Unknown Device'),
                  onTap: () {
                    setState(() {
                      _selectedDevice = _devices[index];
                    });
                    Navigator.pop(context); // Close the dialog
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _connectToDevice,
            child: Text('Connect to Device'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDevicesDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Available Devices'),
          content: Column(
            children: _devices.map((device) {
              return ListTile(
                title: Text(device.device.name ?? 'Unknown Device'),
                onTap: () {
                  setState(() {
                    _selectedDevice = device;
                  });
                  Navigator.pop(context); // Close the dialog
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
