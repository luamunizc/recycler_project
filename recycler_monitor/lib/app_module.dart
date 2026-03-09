import 'package:flutter_modular/flutter_modular.dart';
import 'package:recycler_monitor/src/submodules/connection/ble_module.dart';
import 'package:recycler_monitor/src/submodules/thermals/thermals_module.dart';
import 'package:recycler_monitor/src/presenter/splash_page.dart';

class AppModule extends Module {
  @override
  void routes(r) {
    r.child('/', child: (_) => const SplashPage());
    r.module('/connection', module: BleModule());
    r.module('/thermals', module: ThermalsModule());
  }
}
