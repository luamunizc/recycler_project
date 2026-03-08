// recycler_monitor\lib\app_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:recycler_monitor/src/styles/styles.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: appTitle,
      theme: ThemeData(useMaterial3: true),
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
    );
  }
}