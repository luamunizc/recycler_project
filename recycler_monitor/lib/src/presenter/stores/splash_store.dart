// recycler_monitor\lib\src\presenter\stores\splash_store.dart

import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;
import 'package:mobx/mobx.dart';

part 'splash_store.g.dart';

class SplashStore = _SplashStoreBase with _$SplashStore;

abstract class _SplashStoreBase with Store {
  _SplashStoreBase();

  Future<void> checkConnection() async {
    final urls = [
      'http://192.168.1.18/api/status',
      'http://reciclador.local/api/status',
    ];

    for (final url in urls) {
      // Cria um client novo a cada tentativa para evitar reuso de socket fechado
      final client = http.Client();
      try {
        final response = await client
            .get(Uri.parse(url))
            .timeout(const Duration(seconds: 3));
        if (response.statusCode == 200) {
          Modular.to.pushReplacementNamed('/thermals/');
          return;
        }
      } catch (_) {
        continue;
      } finally {
        client.close();
      }
    }

    Modular.to.pushReplacementNamed('/wifi/');
  }
}