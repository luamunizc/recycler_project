import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;
import 'package:recycler_monitor/src/submodules/connection/domain/repositories/wifi_repository.dart';
import 'package:recycler_monitor/src/submodules/connection/external/datasources/wifi_datasource.dart';
import 'package:recycler_monitor/src/submodules/connection/infra/datasources/wifi_datasource.dart';
import 'package:recycler_monitor/src/submodules/connection/infra/repositories/wifi_repository.dart';
import 'package:recycler_monitor/src/submodules/connection/presenter/pages/wifi_setup_page.dart';
import 'package:recycler_monitor/src/submodules/connection/presenter/stores/connection_store.dart';

class WifiModule extends Module {
  @override
  void binds(i) {
    // Injeção de Dependências
    i.addInstance<http.Client>(http.Client());
    i.add<IWifiDatasource>(WifiDatasource.new);
    i.add<IWifiRepository>(WifiRepository.new);
    i.addSingleton(ConnectionStore.new);
  }

  @override
  void routes(r) {
    // Definição da Rota
    r.child('/', child: (context) => WifiSetupPage(store: Modular.get<ConnectionStore>()));
  }
}