import 'package:http/http.dart' as http;
import 'package:recycler_monitor/src/submodules/connection/infra/datasources/wifi_datasource.dart';

class WifiDatasource implements IWifiDatasource {
  final http.Client client;
  final String baseUrl = "http://192.168.4.1";

  WifiDatasource(this.client);

  @override
  Future<String> scan() async {
    final response = await client.get(Uri.parse('$baseUrl/scan'));
    if (response.statusCode == 200) return response.body;
    throw Exception("Erro ao buscar redes na ESP32.");
  }

  @override
  Future<bool> save(String ssid, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/salvar_wifi'),
      body: {'ssid': ssid, 'password': password},
    );
    return response.statusCode == 200;
  }
}