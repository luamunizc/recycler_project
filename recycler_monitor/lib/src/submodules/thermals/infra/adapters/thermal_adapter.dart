import 'dart:convert';

class ThermalAdapter {
  static Map<String, double> fromJson(String source) {
    final Map<String, dynamic> decoded = jsonDecode(source);
    return {
      't1': (decoded['t1'] as num).toDouble(),
      't2': (decoded['t2'] as num).toDouble(),
      't3': (decoded['t3'] as num).toDouble(),
    };
  }
}