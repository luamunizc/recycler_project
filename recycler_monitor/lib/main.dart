// recycler_monitor\lib\main.dart

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'app_module.dart';
import 'app_widget.dart';

void main() {
  print('[main] app iniciando');
  Modular.setInitialRoute('/');
  runApp(
    ModularApp(
      module: AppModule(),
      child: const AppWidget(),
    ),
  );
}