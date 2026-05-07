#ifndef SENSORES_H
#define SENSORES_H

#include <Arduino.h>

const int pinT1 = 4; 
const int pinT2 = 5;
const int pinT3 = 6; 

const double R = 50000.0;
const double beta = 3950.0;
const double r0 = 100000.0;
const double t0 = 298.15;
const double rx = r0 * exp(-beta / t0);

void setupSensores() {
  analogReadResolution(12);
}

double lerTemperatura(int pino) {
  long soma = 0;
  for (int i = 0; i < 20; i++) {
    soma += analogRead(pino);
    delay(5);
  }
  double media = (double)soma / 20.0;
  
  if (media <= 0 || media >= 4095) return -273.15;

  double rt = R * ((3600.0 / media) - 1.0); 
  double tK = beta / log(rt / rx);
  return tK - 273.15;
}

#endif