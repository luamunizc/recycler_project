// lib\src\presenter\splash_page.dart
// Splash simples — vai direto para a tela de conexão BLE

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Vai direto para a tela de conexão BLE
    Future.delayed(const Duration(milliseconds: 300), () {
      Modular.to.pushReplacementNamed('/connection/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
