import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;
import 'package:recycler_monitor/src/submodules/connection/wifi_module.dart';
import 'src/submodules/thermals/thermals_module.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    i.addInstance<http.Client>(http.Client());
  }

  @override
  void routes(r) {
    r.module('/', module: ThermalsModule());
    r.module('/wifi', module: WifiModule());
  }
}