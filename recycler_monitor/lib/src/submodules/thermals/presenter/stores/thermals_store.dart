// lib\src\submodules\thermals\presenter\stores\thermals_store.dart

import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:recycler_monitor/src/submodules/connection/services/ble_service.dart';

part 'thermals_store.g.dart';

enum ThermalStatus { connecting, ok, error }

class ThermalStore = _ThermalStoreBase with _$ThermalStore;

abstract class _ThermalStoreBase with Store {
  final BleService service;
  StreamSubscription? _subscription;

  _ThermalStoreBase(this.service);

  @observable double tNozzle = 0;
  @observable double tTube   = 0;
  @observable double tSilo   = 0;
  @observable ThermalStatus status = ThermalStatus.connecting;
  @observable String errorMessage  = '';

  @action
  void startMonitoring() {
    _subscription = service.dataStream.listen(
      (data) {
        tNozzle = data['t1'] ?? 0;
        tTube   = data['t2'] ?? 0;
        tSilo   = data['t3'] ?? 0;
        status  = ThermalStatus.ok;
      },
      onError: (_) {
        status = ThermalStatus.error;
        errorMessage = 'Conexão BLE perdida.';
      },
    );
  }

  void stopMonitoring() {
    _subscription?.cancel();
  }
}
