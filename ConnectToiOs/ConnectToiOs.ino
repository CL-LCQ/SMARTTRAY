/*

Copyright (c) 2012-2014 RedBearLab

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/

/*
 *    Chat
 *
 *    Simple chat sketch, work with the Chat iOS/Android App.
 *    Type something from the Arduino serial monitor to send
 *    to the Chat App or vice verse.
 *
 */

//"services.h/spi.h/boards.h" is needed in every new project
#include <SPI.h>
#include <boards.h>
#include <RBL_nRF8001.h>

int value;
int led = 13;
int ledOffThreshold = 100;
 int currentValue;
 int offsetWeight=500;
 int pillWeight = 30;
unsigned char buf[16] = {0};
unsigned char len = 0;

void setup()
{  
  pinMode(led, OUTPUT); 
    
  value = 700;
 
  ble_set_name("Smart tray");
  
  ble_begin();
  
  Serial.begin(57600);
}



void loop()
{

  
  
  uint16_t sensorValue = analogRead(A0);
  

Serial.println("sensor:");
Serial.println(sensorValue);

  if(sensorValue >offsetWeight){
  currentValue = (sensorValue-offsetWeight)/25;
  
  }
  else {
   currentValue = 0;
  }
   Serial.println("units:");
  Serial.println(currentValue);
  
  if (currentValue <=7){
  digitalWrite(led, LOW);
   Serial.print("LED OFF");
}
else {
  digitalWrite(led, HIGH); 
  Serial.print("LED ON");
}

  if ( ble_connected () )
  {
    delay(5);
    
//convert int to byte array
//ble_send_byte()

  String myString= String(currentValue);
 // ble_write (currentValue);
  
 // ble_write(currentValue);


 if (currentValue ==0){
 ble_write('0');

 }
 else if (currentValue == 1){
 ble_write('1');
 
 }
  else if (currentValue == 2){
 ble_write('2');
 
 }
   else if (currentValue == 3){
 ble_write('3');
 
 }
    else if (currentValue == 4){
 ble_write('4');
 
 }
     else if (currentValue == 5){
 ble_write('5');
 
 }
      else if (currentValue == 6){
 ble_write('6');
 
 }
       else if (currentValue == 7){
 ble_write('7');
 
 }
        else if (currentValue == 8){
 ble_write('8');
 
 }
         else if (currentValue == 9){
 ble_write('9');
 
 }
          else if (currentValue >= 10){
 ble_write('9');
 
 }
 



       
  }
  
  ble_do_events();
   delay(2000);
}


