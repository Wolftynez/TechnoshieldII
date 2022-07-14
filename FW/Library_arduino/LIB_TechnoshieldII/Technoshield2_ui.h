#ifndef TECHNOSHIELD2_UI
#define TECHNOSHIELD2_UI


#include <Adafruit_SSD1306.h>
#include "utility/CustomWire.h"
#include <arduino.h>

class Technoshield2_ui : public Adafruit_SSD1306, public customTWI {

  public:
  //  Technoshield2_ui(uint8_t width, uint8_t height, uint8_t slaveAddr);
    Technoshield2_ui(uint8_t width, uint8_t height);
   // Technoshield2_ui(uint8_t slaveAddr);
    Technoshield2_ui();
    void begin(uint8_t adr);
    
    uint8_t isButtonPressed(uint8_t button_digital);
    uint8_t isButtonPressed();
    
    void setLedState(uint8_t led, bool state);
    void blinkLed(bool blinkLed);
    void setLedRGB(uint8_t red, uint8_t green, uint8_t blue);

    uint8_t pmodRead(uint8_t pmod, uint8_t pin);
    void pmodWrite(uint8_t pmod, uint8_t pin, bool state);
    void pmodSet(byte reg);
    void pmodSet(uint8_t pmod, uint8_t pin, bool mode);
    
    void setDrvMosfet(bool state);
    void setLedPWR(bool state);

  private:
    const uint8_t regLed = 0b00100000;
    const uint8_t regButton = 0b00000000;
    const uint8_t I2Caddr = 0b01111100;

};


#endif
