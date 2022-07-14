#ifndef CUSTOMWIRE
#define CUSTOMWIRE

//this was a mistake
//I did it so 7-bit addresing with Write/read as the 8 bit is supported
//because Wire is a bitch
//If you don't understand what this library does differently from Wire you better use the Wire library for I2C comms
//note: Wire is actually a great library, its just that the chip that I am using doesnt support normal 7-bit addressing

#include <Adafruit_SSD1306.h>
#include <arduino.h>

class customTWI {

  public:

    customTWI();
    void begin(uint8_t adr);
    uint8_t beginCom(uint8_t regAddr);                         //0 => all good, 1 => start condition failed, 2 => Slave addressing NACK, 3 => Read request failed, 4 => Slave Data NACK
    uint8_t beginCom(uint8_t regAddr, uint8_t data);
    uint8_t beginComRead(uint8_t regAddr);

  private:

    uint8_t AddrI2C;
    const uint8_t START = 0x08;
    const uint8_t RESTART = 0x10;
    const uint8_t MT_SLA_ACK = 0x18;
    const uint8_t MT_READ_SLA_ACK = 0x40;
    const uint8_t MT_DATA_ACK = 0x28;

};


#endif
