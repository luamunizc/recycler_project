import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:recycler_monitor/src/submodules/thermals/presenter/pages/components/thermal_cards.dart';
import 'package:recycler_monitor/src/submodules/connection/services/ble_service.dart';
import 'package:recycler_monitor/src/submodules/thermals/presenter/stores/thermals_store.dart';
import 'package:recycler_monitor/src/styles/styles.dart';

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
      //backgroundColor: appBackground,
      appBar: AppBar(
        //backgroundColor: appBarBackground,
        title: Text(appTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.bluetooth_disabled_outlined),
            tooltip: 'Desconectar',
            onPressed: () async {
              store.stopMonitoring();
              await Modular.get<BleService>().disconnect();
              Modular.to.pushReplacementNamed('/connection/');
            },
          ),
        ],
      ),
      body: Observer(builder: (_) {
        if (store.status == ThermalStatus.connecting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (store.status == ThermalStatus.error) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bluetooth_disabled, size: 72,), //color: Colors.redAccent),
                  const SizedBox(height: 16),
                  Text(store.errorMessage, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.bluetooth_searching),
                    label: const Text('Reconectar'),
                    onPressed: () => Modular.to.pushReplacementNamed('/connection/'),
                  ),
                ],
              ),
            ),
          );
        }

        return SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  ThermalCards('Bico', store.tNozzle),
                  ThermalCards('Cano', store.tTube),
                  ThermalCards('Silo', store.tSilo),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}