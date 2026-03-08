#ifndef REDE_H
#define REDE_H

#include <WiFi.h>
#include <WebServer.h>
#include <Preferences.h>
#include <ESPmDNS.h>

WebServer server(80);
Preferences preferences;

extern double t1;
extern double t2;
extern double t3;

String ssidSalvo = "";
String senhaSalva = "";

void setupRotaStatus() {
  server.on("/api/status", HTTP_GET, []() {
    server.sendHeader("Access-Control-Allow-Origin", "*");
    server.send(200, "application/json", "{\"status\":\"online\"}");
  });
}

void setupRotasConfiguracao() {
  setupRotaStatus();
  server.on("/scan", HTTP_GET, []() {
    int n = WiFi.scanNetworks();
    String json = "[";
    for (int i = 0; i < n; ++i) {
      if (i > 0) json += ",";
      json += "\"" + WiFi.SSID(i) + "\"";
    }
    json += "]";
    server.sendHeader("Access-Control-Allow-Origin", "*");
    server.send(200, "application/json", json);
  });

  server.on("/salvar_wifi", HTTP_POST, []() {
    if (server.hasArg("ssid") && server.hasArg("password")) {
      preferences.begin("wifi_creds", false);
      preferences.putString("ssid", server.arg("ssid"));
      preferences.putString("password", server.arg("password"));
      preferences.end();
      
      server.sendHeader("Access-Control-Allow-Origin", "*");
      server.send(200, "application/json", "{\"status\":\"sucesso\"}");
      
      delay(1000);
      ESP.restart(); 
    }
  });
}

void setupRotasSensores() {
  setupRotaStatus();
  server.on("/api/temperaturas", HTTP_GET, []() {
    String json = "{\"t1\":" + String(t1, 1) + ",\"t2\":" + String(t2, 1) + ",\"t3\":" + String(t3, 1) + "}";
    server.sendHeader("Access-Control-Allow-Origin", "*");
    server.send(200, "application/json", json);
  });
}

void setupRede() {
  preferences.begin("wifi_creds", true);
  ssidSalvo = preferences.getString("ssid", "");
  senhaSalva = preferences.getString("password", "");
  preferences.end();

  if (ssidSalvo != "") {
    WiFi.begin(ssidSalvo.c_str(), senhaSalva.c_str());
    int tentativas = 0;
    while (WiFi.status() != WL_CONNECTED && tentativas < 20) {
      delay(500);
      tentativas++;
    }
  }

  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("Conectado! IP: " + WiFi.localIP().toString());
    setupRotasSensores();
  } else {
    WiFi.mode(WIFI_AP);
    WiFi.softAP("Reciclador_Config");
    setupRotasConfiguracao();
  }

  if (MDNS.begin("reciclador")) {
    Serial.println("mDNS: http://reciclador.local");
  }

  server.begin();
}

void manterRede() {
  server.handleClient();
}

#endif