#include "Technoshield2_ui.h"

Technoshield2_ui ui;


void setup() {
  Serial.begin(9600);
  ui.begin(0x3C);
  ui.display();
  ui.clearDisplay();
  ui.setTextSize(2);
  ui.setTextColor(SSD1306_WHITE);
  ui.setCursor(0, 0);
  ui.write("AlloAlloAllo");
  ui.display();
}

void loop() {
  
  for (int i = 0; i < 8; i++) {
    unsigned long temps = millis();
    ui.setLedState(i, true);
    delay(100);
    ui.setLedState(i, false);
    delay(100);
  }
  

  ui.clearDisplay();
   ui.setCursor(0, 0);
  ui.print(ui.isButtonPressed());
  ui.display();
}
