// reciclador\Rede.h
// Comunicação via BLE — substitui o Wi-Fi completamente

#ifndef REDE_H
#define REDE_H

#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

// UUIDs do serviço e característica de temperatura
// Gerados aleatoriamente — não altere, pois o app Flutter usa os mesmos
#define SERVICE_UUID        "12345678-1234-1234-1234-123456789abc"
#define CHARACTERISTIC_UUID "abcd1234-ab12-ab12-ab12-abcdef123456"

BLEServer*         pServer         = nullptr;
BLECharacteristic* pCharacteristic = nullptr;
bool               deviceConnected = false;

extern double t1;
extern double t2;
extern double t3;

// Callbacks de conexão/desconexão
class ServerCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer* pServer) override {
    deviceConnected = true;
    Serial.println("[BLE] Cliente conectado");
  }

  void onDisconnect(BLEServer* pServer) override {
    deviceConnected = false;
    Serial.println("[BLE] Cliente desconectado — reiniciando advertising");
    pServer->startAdvertising();
  }
};

void setupRede() {
  BLEDevice::init("Reciclador"); // Nome visível no scan do celular

  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new ServerCallbacks());

  BLEService* pService = pServer->createService(SERVICE_UUID);

  pCharacteristic = pService->createCharacteristic(
    CHARACTERISTIC_UUID,
    BLECharacteristic::PROPERTY_READ |
    BLECharacteristic::PROPERTY_NOTIFY
  );

  // Permite que o cliente se inscreva para receber notificações automáticas
  pCharacteristic->addDescriptor(new BLE2902());

  pService->start();

  BLEAdvertising* pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  BLEDevice::startAdvertising();

  Serial.println("[BLE] Advertising iniciado como 'Reciclador'");
}

void manterRede() {
  if (!deviceConnected) return;

  // Monta JSON com as temperaturas e notifica o cliente
  String json = "{\"t1\":" + String(t1, 1) +
                ",\"t2\":" + String(t2, 1) +
                ",\"t3\":" + String(t3, 1) + "}";

  pCharacteristic->setValue(json.c_str());
  pCharacteristic->notify();
}

#endif
