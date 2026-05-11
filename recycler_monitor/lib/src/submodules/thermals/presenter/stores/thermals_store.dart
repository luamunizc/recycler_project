import 'dart:async';
import 'package:recycler_monitor/src/submodules/connection/services/ble_service.dart';
import 'package:signals_flutter/signals_flutter.dart'; 

enum ThermalStatus { connecting, ok, error }

class ThermalStore {
  final BleService service;
  StreamSubscription? _subscription;

  ThermalStore(this.service);

  final tNozzle = signal(0.0);
  final tTube = signal(0.0);
  final tMotor = signal(0.0);
  final status = signal<ThermalStatus>(ThermalStatus.connecting);
  final errorMessage = signal('');

 void startMonitoring() {
    _subscription = service.dataStream.listen(
      (data) {
        tNozzle.value = data['t1'] ?? 0;
        tTube.value = data['t2'] ?? 0;
        tMotor.value = data['t3'] ?? 0;
        status.value = ThermalStatus.ok;
      },
      onError: (_) {
        status.value = ThermalStatus.error;
        errorMessage.value = 'Conexão BLE perdida.';
      },
    );
  }

  void stopMonitoring() {
    _subscription?.cancel();
  }
}
