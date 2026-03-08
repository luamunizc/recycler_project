// recycler_monitor\lib\src\presenter\splash_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    print('[Splash] initState chamado');
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    print('[Splash] iniciando checagem');
    final urls = [
      'http://192.168.1.18/api/status',
      'http://reciclador.local/api/status',
    ];

    for (final url in urls) {
      final client = http.Client();
      try {
        print('[Splash] Tentando: $url');
        final response = await client
            .get(Uri.parse(url))
            .timeout(const Duration(seconds: 3));
        print('[Splash] Status: ${response.statusCode}');
        if (response.statusCode == 200) {
          Modular.to.pushReplacementNamed('/thermals/');
          return;
        }
      } catch (e) {
        print('[Splash] Erro em $url: $e');
      } finally {
        client.close();
      }
    }

    print('[Splash] nenhuma URL respondeu, indo para /wifi/');
    Modular.to.pushReplacementNamed('/wifi/');
  }

  @override
  Widget build(BuildContext context) {
    print('[Splash] build chamado');
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}