import 'package:flutter_modular/flutter_modular.dart';
import 'package:recycler_monitor/src/submodules/connection/presenter/pages/ble_scan_page.dart';
import 'package:recycler_monitor/src/submodules/connection/presenter/stores/ble_store.dart';
import 'package:recycler_monitor/src/submodules/connection/services/ble_service.dart';

class BleModule extends Module {
  @override
  void binds(i) {
    i.addSingleton(BleService.new);
    i.addSingleton(BleStore.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => const BleScanPage());
  }
}