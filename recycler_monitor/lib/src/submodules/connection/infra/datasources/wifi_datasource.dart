abstract class IWifiDatasource {
  Future<String> scan();
  Future<bool> save(String ssid, String password);
}