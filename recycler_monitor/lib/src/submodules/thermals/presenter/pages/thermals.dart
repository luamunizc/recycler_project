import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:recycler_monitor/src/submodules/thermals/presenter/pages/components/thermal_cards.dart';
import 'package:recycler_monitor/src/submodules/thermals/presenter/stores/thermals_store.dart';

class ThermalsPage extends StatefulWidget {
  const ThermalsPage({super.key});

  @override
  State<ThermalsPage> createState() => _ThermalsPageState();
}

class _ThermalsPageState extends State<ThermalsPage> {
  final store = Modular.get<ThermalStore>();

  @override
  void initState() {
    super.initState();
    store.startMonitoring();
  }

  @override
  void dispose() {
    store.stopMonitoring();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (_) => SingleChildScrollView( // Lida com rotação de tela
          child: Center(
            child: Column(
              children: [
                ThermalCards('Bico', store.tNozzle),
                ThermalCards("Cano", store.tTube),
                ThermalCards('Silo', store.tSilo),
              ],
            ),
          ),
        ),
      ),
    );
  }
}