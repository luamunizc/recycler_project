#ifndef REDE_H
#define REDE_H

#include <WiFi.h>
#include <WebServer.h>
#include <Preferences.h>

WebServer server(80);
Preferences preferences; // Para salvar SSID e Senha na memória permanente

extern double t1;
extern double t2;
extern double t3;

String ssidSalvo = "";
String senhaSalva = "";
bool modoConfiguracao = false; // Flag para saber em qual modo estamos

// ==========================================
// ROTAS DO MODO AP (CONFIGURAÇÃO PELO APP)
// ==========================================
void setupRotasConfiguracao() {
  // Rota 1: O App pede para a ESP32 escanear as redes em volta
  server.on("/scan", HTTP_GET, []() {
    int n = WiFi.scanNetworks();
    String json = "[";
    for (int i = 0; i < n; ++i) {
      if (i > 0) json += ",";
      json += "\"" + WiFi.SSID(i) + "\""; // Adiciona os nomes na lista
    }
    json += "]";
    server.sendHeader("Access-Control-Allow-Origin", "*");
    server.send(200, "application/json", json);
  });

  // Rota 2: O App envia a rede escolhida e a senha digitada
  server.on("/salvar_wifi", HTTP_POST, []() {
    if (server.hasArg("ssid") && server.hasArg("password")) {
      String novoSsid = server.arg("ssid");
      String novaSenha = server.arg("password");
      
      // Salva na memória flash
      preferences.begin("wifi_creds", false);
      preferences.putString("ssid", novoSsid);
      preferences.putString("password", novaSenha);
      preferences.end();
      
      server.sendHeader("Access-Control-Allow-Origin", "*");
      server.send(200, "application/json", "{\"status\":\"sucesso\", \"mensagem\":\"Reiniciando placa...\"}");
      
      // Dá um tempo para o celular receber a resposta e reinicia
      delay(1000);
      ESP.restart(); 
    } else {
      server.send(400, "application/json", "{\"erro\":\"Faltam parametros\"}");
    }
  });
}

// ==========================================
// ROTAS DO MODO STA (USO NORMAL DO RECICLADOR)
// ==========================================
void setupRotasSensores() {
  server.on("/api/temperaturas", HTTP_GET, []() {
    String json = "{";
    json += "\"t1\":" + String(t1, 1) + ",";
    json += "\"t2\":" + String(t2, 1) + ",";
    json += "\"t3\":" + String(t3, 1);
    json += "}";
    server.sendHeader("Access-Control-Allow-Origin", "*");
    server.send(200, "application/json", json);
  });
}

// ==========================================
// LÓGICA DE INICIALIZAÇÃO DA REDE
// ==========================================
void setupRede() {
  // 1. Lê as credenciais salvas
  preferences.begin("wifi_creds", true); // true = Somente leitura
  ssidSalvo = preferences.getString("ssid", "");
  senhaSalva = preferences.getString("password", "");
  preferences.end();

  // 2. Tenta conectar se houver algo salvo
  if (ssidSalvo != "") {
    Serial.println("Tentando conectar na rede salva: " + ssidSalvo);
    WiFi.begin(ssidSalvo.c_str(), senhaSalva.c_str());
    
    int tentativas = 0;
    while (WiFi.status() != WL_CONNECTED && tentativas < 20) {
      delay(500);
      Serial.print(".");
      tentativas++;
    }
  }

  // 3. Decide qual modo assumir
  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("\nWi-Fi Conectado! IP da ESP32: " + WiFi.localIP().toString());
    modoConfiguracao = false;
    setupRotasSensores(); // Libera a rota das temperaturas
  } else {
    Serial.println("\nFalha ao conectar ou sem rede salva. Entrando no Modo AP.");
    modoConfiguracao = true;
    
    // Cria a rede para o celular conectar
    WiFi.mode(WIFI_AP);
    WiFi.softAP("Reciclador_Config"); 
    
    Serial.println("Rede criada: Reciclador_Config");
    Serial.println("Conecte o celular nela e acesse o IP: " + WiFi.softAPIP().toString()); // Geralmente 192.168.4.1
    
    setupRotasConfiguracao(); // Libera as rotas de scan e salvar
  }

  server.begin();
}

void manterRede() {
  server.handleClient();
}

#endif