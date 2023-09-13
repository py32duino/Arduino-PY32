/*
  Software serial multiple serial test

 Receives from the two software serial ports,
 sends to the hardware serial port.

 In order to listen on a software port, you call port.listen().
 When using two software serial ports, you have to switch ports
 by listen()ing on each one in turn. Pick a logical time to switch
 ports, like the end of an expected transmission, or when the
 buffer is empty. This example switches ports when there is nothing
 more to read from a port

 The circuit:
 Two devices which communicate serially are needed.
 * First serial device's TX attached to PA0(RX), RX to pin PA1(TX)
 * Second serial device's TX attached to PA4(RX), PA5(TX)


 created 18 Apr. 2011
 modified 19 Aug 2023
 by HalfSweet
 based on Mikal Hart's twoPortRXExample

 This example code is in the public domain.

 */

#include <SoftwareSerial.h>
// software serial #1: RX = PA0, TX = PA1
SoftwareSerial portOne(PA0, PA1);

// software serial #2: RX = PA4, TX = PA5
SoftwareSerial portTwo(PA4, PA5);

void setup() {
  // Open serial communications and wait for port to open:
  Serial.begin(115200);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }


  // Start each software serial port
  portOne.begin(9600);
  portTwo.begin(9600);
}

void loop() {
  // By default, the last initialized port is listening.
  // when you want to listen on a port, explicitly select it:
  portOne.listen();
  Serial.println("Data from port one:");
  // while there is data coming in, read it
  // and send to the hardware serial port:
  while (portOne.available() > 0) {
    char inByte = portOne.read();
    Serial.write(inByte);
  }

  // blank line to separate data from the two ports:
  Serial.println();

  // Now listen on the second port
  portTwo.listen();
  // while there is data coming in, read it
  // and send to the hardware serial port:
  Serial.println("Data from port two:");
  while (portTwo.available() > 0) {
    char inByte = portTwo.read();
    Serial.write(inByte);
  }

  // blank line to separate data from the two ports:
  Serial.println();
}
