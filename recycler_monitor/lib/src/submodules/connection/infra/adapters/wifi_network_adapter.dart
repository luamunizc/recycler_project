import 'dart:convert';

import 'package:recycler_monitor/src/submodules/connection/domain/entities/wifi_network_entity.dart';

class WifiNetworkAdapter {
  static List<WifiNetworkEntity> fromJsonList(String source) {
    final List<dynamic> decoded = jsonDecode(source);
    return decoded.map((name) => WifiNetworkEntity(ssid: name)).toList();
  }
}