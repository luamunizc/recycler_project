import 'dart:async';
import 'dart:convert';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

const String _deviceName      = 'Reciclador';
const String _serviceUuid     = '12345678-1234-1234-1234-123456789abc';
const String _characteristicUuid = 'abcd1234-ab12-ab12-ab12-abcdef123456';

class BleService {
  BluetoothDevice? _device;
  BluetoothCharacteristic? _characteristic;
  StreamSubscription? _notifySubscription;

  final _dataController = StreamController<Map<String, double>>.broadcast();
  Stream<Map<String, double>> get dataStream => _dataController.stream;

  bool get isConnected => _device != null && (_device?.isConnected ?? false);

  Stream<List<ScanResult>> scanForDevice() {
    FlutterBluePlus.startScan(
      withNames: [_deviceName],
      timeout: const Duration(seconds: 10),
    );
    return FlutterBluePlus.scanResults;
  }

  void stopScan() {
    FlutterBluePlus.stopScan();
  }

  Future<void> connect(BluetoothDevice device) async {
    _device = device;
    await device.connect(autoConnect: false);

    final services = await device.discoverServices();
    for (final service in services) {
      if (service.uuid.toString().toLowerCase() == _serviceUuid) {
        for (final c in service.characteristics) {
          if (c.uuid.toString().toLowerCase() == _characteristicUuid) {
            _characteristic = c;
            await c.setNotifyValue(true);
            _notifySubscription = c.onValueReceived.listen(_onData);
            return;
          }
        }
      }
    }
    throw Exception('Característica BLE não encontrada na ESP32.');
  }

  void _onData(List<int> value) {
    try {
      final json = jsonDecode(utf8.decode(value)) as Map<String, dynamic>;
      _dataController.add({
        't1': (json['t1'] as num).toDouble(),
        't2': (json['t2'] as num).toDouble(),
        't3': (json['t3'] as num).toDouble(),
      });
    } catch (e) {
      // ignora pacotes mal formados
    }
  }

  Future<void> disconnect() async {
    await _notifySubscription?.cancel();
    await _device?.disconnect();
    _device = null;
    _characteristic = null;
  }

  void dispose() {
    _notifySubscription?.cancel();
    _dataController.close();
  }
}
