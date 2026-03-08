import 'package:http/http.dart' as http;
import 'package:recycler_monitor/src/submodules/thermals/infra/datasources/thermals_datasource.dart';

class ThermalsDatasource implements IThermalsDatasource {
  final http.Client client;
  final String _ipPlaca = '192.168.4.1'; 

  ThermalsDatasource(this.client); 

  @override
  Future<Map<String, double>> getThermalsData() async {
    // Retorno estático para permitir a inicialização sem hardware
    return {
      't1': 0.0,
      't2': 0.0,
      't3': 0.0,
    };
  }
}