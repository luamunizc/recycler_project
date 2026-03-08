#ifndef DISPLAY_H
#define DISPLAY_H

#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64
#define OLED_RESET    -1

Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

const int pinSDA = 8; 
const int pinSCL = 9;

void setupDisplay() {
  Wire.begin(pinSDA, pinSCL);
  if(!display.begin(SSD1306_SWITCHCAPVCC, 0x3C)) {
    Serial.println(F("Erro: OLED nao encontrado"));
    for(;;);
  }
  display.clearDisplay();
  display.setTextColor(SSD1306_WHITE);
  display.setTextSize(1);
  display.setCursor(0, 20);
  display.print("Iniciando...");
  display.display();
}

void atualizarDisplay(double t1, double t2, double t3) {
  display.clearDisplay();
  display.setTextSize(1);
  
  display.setCursor(0,0);
  display.print("BICO (T1): "); display.print(t1, 1); display.print(" C");
  
  display.setCursor(0,22);
  display.print("ZONA (T2): "); display.print(t2, 1); display.print(" C");
  
  display.setCursor(0,44);
  display.print("SILO (T3): "); display.print(t3, 1); display.print(" C");

  display.display();
}

#endif