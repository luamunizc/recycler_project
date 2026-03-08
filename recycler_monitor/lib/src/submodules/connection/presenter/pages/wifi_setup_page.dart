import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:recycler_monitor/src/submodules/connection/presenter/stores/connection_store.dart';

class WifiSetupPage extends StatefulWidget {
  final ConnectionStore store;

  const WifiSetupPage({super.key, required this.store});

  @override
  State<WifiSetupPage> createState() => _WifiSetupPageState();
}

class _WifiSetupPageState extends State<WifiSetupPage> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configurar Reciclador")),
      body: Observer(
        builder: (_) {
          // 1. Estado de Erro
          if (widget.store.status == ConnectionStatus.error) {
            return _buildErrorState();
          }

          // 2. Estado de Carregamento
          if (widget.store.status == ConnectionStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 3. Estado de Sucesso (Conectado)
          if (widget.store.status == ConnectionStatus.connected) {
            return _buildSuccessState();
          }

          // 4. Estado de Listagem (Provisioning) ou Inicial (Idle)
          return _buildNetworkList();
        },
      ),
    );
  }

  Widget _buildNetworkList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: widget.store.scanForNetworks,
            icon: const Icon(Icons.search),
            label: const Text("Buscar Redes da Placa"),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.store.networks.length,
            itemBuilder: (context, index) {
              final network = widget.store.networks[index];
              return ListTile(
                leading: const Icon(Icons.wifi),
                title: Text(network.ssid),
                onTap: () => _showPasswordDialog(network.ssid),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showPasswordDialog(String ssid) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Conectar a $ssid"),
        content: TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(labelText: "Senha do Wi-Fi"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              widget.store.sendConfig(ssid, _passwordController.text);
              Navigator.pop(context);
            },
            child: const Text("Enviar"),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 60),
          Text(widget.store.errorMessage, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: widget.store.resetStatus, child: const Text("Tentar Novamente")),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.green, size: 60),
          const Text("Configuração enviada com sucesso!", style: TextStyle(fontSize: 18)),
          const Text("A ESP32-S3 está reiniciando para conectar."),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("Ir para o Monitoramento"),
          ),
        ],
      ),
    );
  }
}