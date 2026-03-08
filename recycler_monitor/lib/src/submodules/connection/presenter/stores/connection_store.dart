import 'package:mobx/mobx.dart';
import 'package:recycler_monitor/src/submodules/connection/domain/entities/wifi_network_entity.dart';
import 'package:recycler_monitor/src/submodules/connection/domain/repositories/wifi_repository.dart';

// Necessário gerar o código: flutter pub run build_runner build
part 'connection_store.g.dart';

enum ConnectionStatus { idle, loading, provisioning, connected, error }

class ConnectionStore = _ConnectionStoreBase with _$ConnectionStore;

abstract class _ConnectionStoreBase with Store {
  final IWifiRepository repository;

  _ConnectionStoreBase(this.repository);

  // --- Observables ---

  @observable
  ObservableList<WifiNetworkEntity> networks = ObservableList<WifiNetworkEntity>();

  @observable
  ConnectionStatus status = ConnectionStatus.idle;

  @observable
  String errorMessage = "";

  // --- Actions ---

  @action
  Future<void> scanForNetworks() async {
    status = ConnectionStatus.loading;
    errorMessage = "";
    
    try {
      final availableNetworks = await repository.getAvailableNetworks();
      
      networks.clear();
      networks.addAll(availableNetworks);
      
      status = ConnectionStatus.provisioning;
    } catch (e) {
      status = ConnectionStatus.error;
      errorMessage = "Falha ao comunicar com a ESP32. Verifique se está na rede 'Reciclador_Config'.";
    }
  }

  @action
  Future<void> sendConfig(String ssid, String password) async {
    status = ConnectionStatus.loading;
    errorMessage = "";

    try {
      final success = await repository.sendCredentials(ssid, password);
      
      if (success) {
        status = ConnectionStatus.connected;
      } else {
        status = ConnectionStatus.error;
        errorMessage = "A placa rejeitou as credenciais enviadas.";
      }
    } catch (e) {
      // No caso da ESP32, muitas vezes ela reinicia antes de dar o OK 200, 
      // por isso tratamos o erro de timeout como possível sucesso ou erro específico.
      status = ConnectionStatus.error;
      errorMessage = "Erro de rede: a placa pode ter reiniciado. Verifique o LED da S3.";
    }
  }

  @action
  void resetStatus() {
    status = ConnectionStatus.idle;
    errorMessage = "";
    networks.clear();
  }
}