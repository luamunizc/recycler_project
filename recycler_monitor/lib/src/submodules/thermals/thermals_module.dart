import 'package:flutter_modular/flutter_modular.dart';
import 'package:recycler_monitor/src/submodules/connection/ble_module.dart';
import 'package:recycler_monitor/src/submodules/thermals/presenter/pages/thermals.dart';
import 'package:recycler_monitor/src/submodules/thermals/presenter/stores/thermals_store.dart';

class ThermalsModule extends Module {
  
  @override
  List<Module> get imports => [BleModule()];

  @override
  void binds(i) {
    i.addSingleton(ThermalStore.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => const ThermalsPage());
  }
}
