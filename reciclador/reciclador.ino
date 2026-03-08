#include "Sensores.h"
#include "Display.h"
#include "Rede.h"

// Variáveis globais que todos os módulos podem enxergar
double t1 = 0, t2 = 0, t3 = 0;

void setup() {
  Serial.begin(115200);
  delay(1000);

  setupSensores();
  setupDisplay();
  setupRede(); // Conecta ao Wi-Fi e sobe o servidor
  
  Serial.println("--- Sistema Modular Iniciado ---");
}

void loop() {
  // 1. Atualiza as leituras
  t1 = lerTemperatura(pinT1);
  t2 = lerTemperatura(pinT2);
  t3 = lerTemperatura(pinT3);

  // 2. Atualiza a interface física
  atualizarDisplay(t1, t2, t3);

  // 3. Mantém o servidor web escutando o celular
  manterRede();

  // 4. Log para o Serial
  Serial.print("T1:"); Serial.print(t1, 1);
  Serial.print(" T2:"); Serial.print(t2, 1);
  Serial.print(" T3:"); Serial.println(t3, 1);

  delay(500);
}