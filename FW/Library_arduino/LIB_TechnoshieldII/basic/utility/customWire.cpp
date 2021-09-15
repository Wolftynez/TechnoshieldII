#include "customWire.h"

//This is I2C register magic. Read the docs on the TWI integrated Chip on the atmega 328p.

customTWI::customTWI() {}

void customTWI::begin(uint8_t adr) {
  AddrI2C = adr;
}

uint8_t customTWI::beginComRead(uint8_t regAddr) {                //Request to read 1 bytes to Slave, need to specify register

  uint8_t tempTransaction = 0;

  TWCR = (1 << TWINT)|(1 << TWSTA)|(1 << TWEN);                   //Send Start Condition
  while (!(TWCR & (1 << TWINT)));                                 //Wait for TWI to respond
  if ((TWSR & 0xF8) != START) return 1;                           //Check for Error

  TWDR = AddrI2C;                                                 //Load slave address + Write instruction in the register
  TWCR = (1 << TWINT) | (1 << TWEN);                              //begin transation of the byte
  while (!(TWCR & (1 << TWINT)));                                 //Wait for NACK/ACK
  if ((TWSR & 0xF8) != MT_SLA_ACK) return 2;                      //Check for NACK

  TWDR = regAddr;                                                 //Load data in the register
  TWCR = (1 << TWINT) | (1 << TWEN);                              //begin transation of the byte
  while (!(TWCR & (1 << TWINT)));                                 //Wait for NACK/ACK
  if ((TWSR & 0xF8) != MT_DATA_ACK) return 4;                     //Check for NACK

  TWCR |= (1 << TWINT) | (1 << TWSTA) | (1 << TWEN);              //Send Repeated Start Condition
  while (!(TWCR & (1 << TWINT)));                                 //Wait for TWI to respond
  if ((TWSR & 0xF8) != RESTART) return 3;                         //Check for Error

  TWDR = AddrI2C + 1;                                             //Load slave address + Read instruction in the register
  TWCR = (1 << TWINT) | (1 << TWEN);                              //begin transation of the byte
  while (!(TWCR & (1 << TWINT)));                                 //Wait for NACK/ACK
  if ((TWSR & 0xF8) != MT_READ_SLA_ACK) return 2;                 //Check for NACK

  TWCR = (1<<TWINT)|(1<<TWEN)|(0<<TWEA);                          //Wait with ack
  while (!(TWCR & (1 << TWINT)));                                 //wait for transaction
  if ((TWSR & 0xF8) != 0x58) return 3;                            //Check for DAta
  tempTransaction = TWDR;                                         //Data is stock

  TWCR = (1 << TWINT) | (1 << TWEN) | (1 << TWSTO);               //Send Stop condition
  while(TWCR & (1 << TWSTO));

  return tempTransaction;
}



uint8_t customTWI::beginCom(uint8_t regAddr) {                     //Send a 8 bits write transaction    

  
  TWCR = (1 << TWINT) | (1 << TWSTA) | (1 << TWEN);               //Send Start Condition
  while (!(TWCR & (1 << TWINT)));                                 //Wait for TWI to respond
  if ((TWSR & 0xF8) != START) return 1;                           //Check for Error

  TWDR = AddrI2C;                                                 //Load slave address + Write instruction in the register
  TWCR =  (1 << TWINT) | (1 << TWEN);                             //begin transation of the byte
  while (!(TWCR & (1 << TWINT)));                                 //Wait for NACK/ACK
  if ((TWSR & 0xF8) != MT_SLA_ACK) return 2;                      //Check for NACK
  

  TWDR = regAddr;                                                 //Load data in the register
  TWCR = (1 << TWINT) | (1 << TWEN);                              //begin transation of the byte
  while (!(TWCR & (1 << TWINT)));                                 //Wait for NACK/ACK
  if ((TWSR & 0xF8) != MT_DATA_ACK) return 4;                     //Check for NACK

  TWCR |= (1 << TWINT) | (1 << TWEN) | (1 << TWSTO);              //Send Stop condition
  while(TWCR & (1 << TWSTO));

  return 0;
}



uint8_t customTWI::beginCom(uint8_t regAddr, uint8_t data) {      //Send a 16 bits write transaction

  TWCR = (1 << TWINT) | (1 << TWSTA) | (1 << TWEN);               //Send Start Condition
  while (!(TWCR & (1 << TWINT)));                                 //Wait for TWI to respond
  if ((TWSR & 0xF8) != START) return 1;                           //Check for Error

  TWDR = AddrI2C;                                                 //Load slave address + Write instruction in the register
  TWCR = (1 << TWINT) | (1 << TWEN);                              //begin transation of the byte
  while (!(TWCR & (1 << TWINT)));                                 //Wait for NACK/ACK
  if ((TWSR & 0xF8) != MT_SLA_ACK) return 2;                      //Check for NACK

  TWDR = regAddr;                                                 //Load data in the register
  TWCR = (1 << TWINT) | (1 << TWEN);                              //begin transation of the byte
  while (!(TWCR & (1 << TWINT)));                                 //Wait for NACK/ACK
  if ((TWSR & 0xF8) != MT_DATA_ACK) return 4;                     //check for NACK

  TWDR = data;                                                    //Load data in the register
  TWCR = (1 << TWINT) | (1 << TWEN);                              //begin transation of the byte
  while (!(TWCR & (1 << TWINT)));                                 //Wait for NACK/ACK
  if ((TWSR & 0xF8) != MT_DATA_ACK) return 4;                     //Check for NACK

  TWCR |= (1 << TWINT) | (1 << TWEN) | (1 << TWSTO);              //Send Stop condition
  return 0;

}
