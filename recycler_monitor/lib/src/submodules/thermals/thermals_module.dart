import 'package:flutter_modular/flutter_modular.dart';
import 'package:recycler_monitor/src/submodules/connection/services/ble_service.dart';
import 'package:recycler_monitor/src/submodules/thermals/presenter/pages/thermals.dart';
import 'package:recycler_monitor/src/submodules/thermals/presenter/stores/thermals_store.dart';

class ThermalsModule extends Module {
  @override
  void binds(i) {
    // Recebe o BleService conectado via argumento de rota e o registra aqui
    i.addInstance<BleService>(Modular.args.data as BleService);
    i.addSingleton(ThermalStore.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => const ThermalsPage());
  }
}