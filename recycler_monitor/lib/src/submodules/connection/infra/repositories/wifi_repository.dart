import 'package:recycler_monitor/src/submodules/connection/infra/adapters/wifi_network_adapter.dart';
import 'package:recycler_monitor/src/submodules/connection/domain/entities/wifi_network_entity.dart';
import 'package:recycler_monitor/src/submodules/connection/domain/repositories/wifi_repository.dart';
import 'package:recycler_monitor/src/submodules/connection/infra/datasources/wifi_datasource.dart';

class WifiRepository implements IWifiRepository {
  final IWifiDatasource datasource;

  WifiRepository(this.datasource);

  @override
  Future<List<WifiNetworkEntity>> getAvailableNetworks() async {
    final jsonRaw = await datasource.scan();
    return WifiNetworkAdapter.fromJsonList(jsonRaw);
  }

  @override
  Future<bool> sendCredentials(String ssid, String password) async {
    return await datasource.save(ssid, password);
  }
}