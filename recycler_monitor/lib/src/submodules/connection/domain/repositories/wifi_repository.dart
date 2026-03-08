import 'package:recycler_monitor/src/submodules/connection/domain/entities/wifi_network_entity.dart';

abstract class IWifiRepository {
  Future<List<WifiNetworkEntity>> getAvailableNetworks();
  Future<bool> sendCredentials(String ssid, String password);
}