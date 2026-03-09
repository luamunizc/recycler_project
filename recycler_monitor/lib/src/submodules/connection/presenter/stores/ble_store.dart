import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:recycler_monitor/src/submodules/connection/services/ble_service.dart';

part 'ble_store.g.dart';

enum BleStatus { idle, scanning, connecting, connected, error }

class BleStore = _BleStoreBase with _$BleStore;

abstract class _BleStoreBase with Store {
  final BleService service;
  StreamSubscription? _scanSubscription;

  _BleStoreBase(this.service);

  @observable
  BleStatus status = BleStatus.idle;

  @observable
  ObservableList<ScanResult> results = ObservableList();

  @observable
  String errorMessage = '';

  @action
  void startScan() {
    status = BleStatus.scanning;
    results.clear();
    errorMessage = '';

    _scanSubscription = service.scanForDevice().listen((scanResults) {
      results
        ..clear()
        ..addAll(scanResults);
    }, onError: (e) {
      status = BleStatus.error;
      errorMessage = 'Erro ao escanear: $e';
    });
  }

  @action
  void stopScan() {
    service.stopScan();
    _scanSubscription?.cancel();
    if (status == BleStatus.scanning) status = BleStatus.idle;
  }

  @action
  Future<void> connectTo(ScanResult result) async {
    stopScan();
    status = BleStatus.connecting;
    errorMessage = '';

    try {
      await service.connect(result.device);
      status = BleStatus.connected;
      Modular.to.pushReplacementNamed('/thermals/');
    } catch (e) {
      status = BleStatus.error;
      errorMessage = 'Falha ao conectar: $e';
    }
  }

  @action
  void reset() {
    status = BleStatus.idle;
    errorMessage = '';
    results.clear();
  }
}
