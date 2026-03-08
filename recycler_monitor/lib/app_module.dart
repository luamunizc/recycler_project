// recycler_monitor\lib\app_module.dart

import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;
import 'package:recycler_monitor/src/presenter/splash_page.dart';
import 'package:recycler_monitor/src/submodules/connection/wifi_module.dart';
import 'package:recycler_monitor/src/submodules/thermals/thermals_module.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    // SplashStore removido — lógica movida direto para SplashPage
    i.addInstance<http.Client>(http.Client());
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => const SplashPage());
    r.module('/thermals', module: ThermalsModule());
    r.module('/wifi', module: WifiModule());
  }
}