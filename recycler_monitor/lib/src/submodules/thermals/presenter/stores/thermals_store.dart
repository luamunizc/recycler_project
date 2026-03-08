// recycler_monitor\lib\src\submodules\thermals\presenter\stores\thermals_store.dart

import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:recycler_monitor/src/submodules/thermals/domain/repositories/thermals_repository.dart';

part 'thermals_store.g.dart';

enum ThermalStatus { ok, error, connecting }

class ThermalStore = _ThermalStoreBase with _$ThermalStore;

abstract class _ThermalStoreBase with Store {
  final IThermalsRepository repository;
  Timer? _timer;

  _ThermalStoreBase(this.repository);

  @observable
  double tNozzle = 0;

  @observable
  double tTube = 0;

  @observable
  double tSilo = 0;

  @observable
  ThermalStatus status = ThermalStatus.connecting;

  @observable
  String errorMessage = '';

  @action
  Future<void> updateTemperatures() async {
    try {
      tNozzle = await repository.getNozzleTemp();
      tTube = await repository.getTubeTemp();
      tSilo = await repository.getSiloTemp();
      status = ThermalStatus.ok;
      errorMessage = '';
    } catch (e) {
      status = ThermalStatus.error;
      errorMessage = 'Sem conexão com o reciclador.\nVerifique a rede Wi-Fi.';
    }
  }

  void startMonitoring() {
    updateTemperatures(); // busca imediata ao entrar na tela
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      updateTemperatures();
    });
  }

  void stopMonitoring() {
    _timer?.cancel();
  }
}