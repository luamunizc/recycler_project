// recycler_monitor\lib\src\submodules\thermals\external\datasources\thermals_datasource.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recycler_monitor/src/submodules/thermals/infra/adapters/thermal_adapter.dart';
import 'package:recycler_monitor/src/submodules/thermals/infra/datasources/thermals_datasource.dart';

class ThermalsDatasource implements IThermalsDatasource {
  final http.Client client;

  // mDNS geralmente não funciona no Android — usa IP direto como primário
  static const String _ipUrl = 'http://192.168.1.18';
  static const String _mdnsUrl = 'http://reciclador.local';

  ThermalsDatasource(this.client);

  @override
  Future<Map<String, double>> getThermalsData() async {
    // Tenta IP direto primeiro (mais confiável no Android)
    try {
      final response = await client
          .get(Uri.parse('$_ipUrl/api/temperaturas'))
          .timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        return ThermalAdapter.fromJson(response.body);
      }
    } catch (_) {
      // Segue para o fallback mDNS
    }

    // Fallback: tenta mDNS (funciona no iOS e alguns Androids)
    final response = await client
        .get(Uri.parse('$_mdnsUrl/api/temperaturas'))
        .timeout(const Duration(seconds: 4));

    if (response.statusCode == 200) {
      return ThermalAdapter.fromJson(response.body);
    }

    throw Exception('Falha ao obter temperaturas. Status: ${response.statusCode}');
  }
}