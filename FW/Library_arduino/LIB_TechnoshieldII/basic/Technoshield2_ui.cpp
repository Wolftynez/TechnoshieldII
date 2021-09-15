#include "Technoshield2_ui.h"
#include "utility/customWire.h"

// '____'


Technoshield2_ui::Technoshield2_ui(uint8_t width, uint8_t height) :
  Adafruit_SSD1306(width, height, &Wire, -1), customTWI() {
}

Technoshield2_ui::Technoshield2_ui() :
  Adafruit_SSD1306(128, 32, &Wire, -1), customTWI() {
}


void Technoshield2_ui::begin(uint8_t adr) {
  Adafruit_SSD1306::begin(SSD1306_SWITCHCAPVCC, adr);
  customTWI::begin(I2Caddr);
  for(int i = 0; i <= 7; i++) {
    Technoshield2_ui::setLedState(i, false);
  }
}



uint8_t Technoshield2_ui::isButtonPressed(uint8_t button_digital) {
  uint8_t temp;
  temp = Technoshield2_ui::beginComRead(regButton + button_digital<<2);
   if((1<<(button_digital) & temp) != (1<<(button_digital))) {
    return true;
   } else {
    return false;
   }
}

uint8_t Technoshield2_ui::isButtonPressed() {
  return ((Technoshield2_ui::beginComRead(regButton + (1<<2))) >> 1) & 0x0F;           
}



void Technoshield2_ui::blinkLed(bool blinkLed) {
  customTWI::beginCom(regButton + (7 << 2) + 2 + blinkLed);
}

void Technoshield2_ui::setLedState(uint8_t led, bool state) {
  if (led > 7) led = 7;
  customTWI::beginCom(regLed + (led << 2) + 2 + state);
}
