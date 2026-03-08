import 'package:flutter_modular/flutter_modular.dart';
import 'package:recycler_monitor/src/submodules/thermals/external/datasources/thermals_datasource.dart';
import 'package:recycler_monitor/src/submodules/thermals/infra/datasources/thermals_datasource.dart';
import 'package:recycler_monitor/src/submodules/thermals/infra/repositories/thermal_repository.dart';
import 'package:recycler_monitor/src/submodules/thermals/presenter/pages/thermals.dart';
import 'package:recycler_monitor/src/submodules/thermals/presenter/stores/thermals_store.dart';
import 'domain/repositories/thermals_repository.dart';

class ThermalsModule extends Module {
  @override
  void binds(i) {
    // Injeção automática baseada no tipo http.Client
    i.add<IThermalsDatasource>(ThermalsDatasource.new);
    i.add<IThermalsRepository>(ThermalsRepository.new);
    i.addSingleton(ThermalStore.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => const ThermalsPage());
  }
}