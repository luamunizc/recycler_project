import 'package:recycler_monitor/src/submodules/thermals/domain/repositories/thermals_repository.dart';
import 'package:recycler_monitor/src/submodules/thermals/infra/datasources/thermals_datasource.dart';

class ThermalsRepository implements IThermalsRepository {
  final IThermalsDatasource datasource;
  Map<String, double>? _cache;

  ThermalsRepository(this.datasource);

  Future<void> _updateCache() async {
    _cache = await datasource.getThermalsData();
  }

  @override
  Future<double> getNozzleTemp() async {
    await _updateCache();
    return _cache?['t1'] ?? 0.0;
  }

  @override
  Future<double> getTubeTemp() async {
    return _cache?['t2'] ?? 0.0;
  }

  @override
  Future<double> getSiloTemp() async {
    return _cache?['t3'] ?? 0.0;
  }
}