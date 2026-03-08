#include "Sensores.h"
#include "Display.h"
#include "Rede.h"

double t1 = 0, t2 = 0, t3 = 0;

void setup() {
  Serial.begin(115200);
  delay(1000);

  setupSensores();
  setupDisplay();
  setupRede();
  
  Serial.println("--- Sistema Modular Iniciado ---");
}

void loop() {
  t1 = lerTemperatura(pinT1);
  t2 = lerTemperatura(pinT2);
  t3 = lerTemperatura(pinT3);

  atualizarDisplay(t1, t2, t3);
  manterRede();

  delay(500);
}