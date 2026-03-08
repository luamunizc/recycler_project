import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:recycler_monitor/src/submodules/thermals/domain/repositories/thermals_repository.dart';

part 'thermals_store.g.dart';

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

  @action
  Future<void> updateTemperatures() async {
    try {
      // Como o repo atualiza o cache no primeiro método, chamamos em sequência
      tNozzle = await repository.getNozzleTemp();
      tTube = await repository.getTubeTemp();
      tSilo = await repository.getSiloTemp();
    } catch (e) {
      // ignore: avoid_print
      print("Erro ao atualizar temperaturas: $e");
    }
  }

  void startMonitoring() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      updateTemperatures();
    });
  }

  void stopMonitoring() {
    _timer?.cancel();
  }
}