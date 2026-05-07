import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:recycler_monitor/src/submodules/connection/presenter/stores/ble_store.dart';
import 'package:recycler_monitor/src/styles/styles.dart';

class BleScanPage extends StatefulWidget {
  const BleScanPage({super.key});

  @override
  State<BleScanPage> createState() => _BleScanPageState();
}

class _BleScanPageState extends State<BleScanPage> {
  final store = Modular.get<BleStore>();

  @override
  void dispose() {
    store.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: appBackground,
      appBar: AppBar(
        //backgroundColor: appBarBackground,
        title: Text(appTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Observer(builder: (_) {

        if (store.status == BleStatus.connecting) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Conectando ao Reciclador...'),
              ],
            ),
          );
        }


        if (store.status == BleStatus.error) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bluetooth_disabled, size: 72), //color: Colors.redAccent),
                  const SizedBox(height: 16),
                  Text(store.errorMessage, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar novamente'),
                    onPressed: store.reset,
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: [
            const SizedBox(height: 24),
            const Icon(Icons.bluetooth_searching, size: 64), //color: Colors.deepPurple),
            const SizedBox(height: 12),
            const Text(
              'Procure pelo dispositivo "Reciclador"\ne toque para conectar.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            // Botão de scan
            ElevatedButton.icon(
              icon: Icon(store.status == BleStatus.scanning
                  ? Icons.stop
                  : Icons.search),
              label: Text(store.status == BleStatus.scanning
                  ? 'Parar busca'
                  : 'Buscar Reciclador'),
              onPressed: store.status == BleStatus.scanning
                  ? store.stopScan
                  : store.startScan,
            ),

            const SizedBox(height: 16),

            if (store.status == BleStatus.scanning && store.results.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16, height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 12),
                    Text('Procurando...'),
                  ],
                ),
              ),

            // Lista de dispositivos encontrados
            Expanded(
              child: ListView.builder(
                itemCount: store.results.length,
                itemBuilder: (context, i) {
                  final result = store.results[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: ListTile(
                      leading: const Icon(Icons.bluetooth), //color: Colors.deepPurple),
                      title: Text(
                        result.device.platformName.isNotEmpty
                            ? result.device.platformName
                            : 'Dispositivo desconhecido',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Sinal: ${result.rssi} dBm'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => store.connectTo(result),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
