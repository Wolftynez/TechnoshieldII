#include <SPI.h>

#define RESET_PIN 7

#define ACK 6
#define NAK 21

const int BUF_SIZE = 64;

uint8_t buffer[BUF_SIZE];

void setup() {
  pinMode(RESET_PIN, OUTPUT);

  Serial.begin(115200);

  SPI.begin();
  SPI.beginTransaction(SPISettings(1000000, MSBFIRST, SPI_MODE0));
}

void readBlock() {
  // wait for block start
  unsigned long t0 = millis();
  while (true) {
    if (Serial.available()) {
      break;
    }
    unsigned long t1 = millis();
    if (t1 - t0 > 1000) {
      // timeout
      Serial.write(NAK);
      return;
    }
  }

  // read data
  int received = Serial.readBytes((char*) buffer, BUF_SIZE);
  if (received != BUF_SIZE) {
    // timeout
    Serial.print(NAK);
    return;
  }

  // send with SPI
  SPI.transfer(buffer, BUF_SIZE);

  // acknowledge
  Serial.write(ACK);
}

void loop() {
  // read command
  char cmd;
  while (true) {
    if (Serial.available() > 0) {
      cmd = Serial.read();
      break;
    }
  }

  // execute command
  switch (cmd) {
    case 'r':
      // reset
      digitalWrite(RESET_PIN, LOW);
      delay(10);
      digitalWrite(RESET_PIN, HIGH);
      delay(10);
      Serial.write(ACK);
      break;
    case 'b':
      readBlock();
      break;
    default:
      Serial.write(NAK);
  }
}
