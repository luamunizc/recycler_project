import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:recycler_monitor/src/submodules/connection/services/ble_service.dart';
import 'package:signals_flutter/signals_core.dart';

enum BleStatus { idle, scanning, connecting, connected, error }

 class BleStore {
  final BleService service;
  StreamSubscription? _scanSubscription;

  BleStore(this.service);

  final status = signal(BleStatus.idle);

  final results = listSignal([]);

  final errorMessage = signal('');

  void startScan() {
    status.value = BleStatus.scanning;
    results.clear();
    errorMessage.value = '';

    _scanSubscription = service.scanForDevice().listen((scanResults) {
      results
        ..clear()
        ..addAll(scanResults);
    }, onError: (e) {
      status.value = BleStatus.error;
      errorMessage.value = 'Erro ao escanear: $e';
    });
  }

  void stopScan() {
    service.stopScan();
    _scanSubscription?.cancel();
    if (status.value == BleStatus.scanning) status.value = BleStatus.idle;
  }

  Future<void> connectTo(ScanResult result) async {
    stopScan();
    status.value = BleStatus.connecting;
    errorMessage.value = '';

    try {
      await service.connect(result.device);
      status.value = BleStatus.connected;
      Modular.to.pushReplacementNamed('/thermals/', arguments: service);
    } catch (e) {
      status.value = BleStatus.error;
      errorMessage.value = 'Falha ao conectar: $e';
    }
  }

  void reset() {
    status.value = BleStatus.idle;
    errorMessage.value = '';
    results.clear();
  }
}