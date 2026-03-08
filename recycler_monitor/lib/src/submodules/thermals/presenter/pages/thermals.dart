// recycler_monitor\lib\src\submodules\thermals\presenter\pages\thermals.dart

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:recycler_monitor/src/submodules/thermals/presenter/pages/components/thermal_cards.dart';
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
      backgroundColor: appBackground,
      appBar: AppBar(
        backgroundColor: appBarBackground,
        title: Text(
          appTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Botão para reconfigurar Wi-Fi (apaga credenciais e reinicia o fluxo)
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Reconfigurar Wi-Fi',
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Reconfigurar Wi-Fi'),
                  content: const Text(
                    'Para reconectar o reciclador a outra rede, '
                    'você precisa acessar a página de configuração.\n\n'
                    'Conecte-se à rede "Reciclador_Config" e tente novamente.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Fechar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Modular.to.pushReplacementNamed('/wifi/');
                      },
                      child: const Text('Ir para Configuração'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          // Estado de erro de conexão
          if (store.status == ThermalStatus.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off_rounded,
                        size: 72, color: Colors.redAccent),
                    const SizedBox(height: 16),
                    Text(
                      store.errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tentar novamente'),
                      onPressed: store.updateTemperatures,
                    ),
                  ],
                ),
              ),
            );
          }

          // Estado conectando (primeira carga)
          if (store.status == ThermalStatus.connecting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Estado OK — mostra os cards de temperatura
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
        },
      ),
    );
  }
}