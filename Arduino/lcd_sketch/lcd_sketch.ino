#include <LiquidCrystal.h>
#include <avr/pgmspace.h>
#include <SoftwareSerial.h>
#include "bbmobile_arduino_01.h"

const int rs = 12, en = 11, d4 = 10, d5 = 9, d6 = 8, d7 = 7;
LiquidCrystal lcd(rs, en, d4, d5, d6, d7);

// software serial port for communication with BBMobile module
SoftwareSerial bbmSerial(2, 3); // RX, TX

//PINS for BBMobile powering
#define BBMOBILE_GND_PIN       4
#define BBMOBILE_POWER_PIN     5

void setup() {
  lcd.begin(16, 2);
  lcd.print("Test");

  setupBB();
}

void setupBB() {
// initialize digital pin LED_BUILTIN as an output
  pinMode(LED_BUILTIN, OUTPUT);
  
  // for powering BBMobile from defined pins
  pinMode(BBMOBILE_GND_PIN, OUTPUT) ;
  digitalWrite(BBMOBILE_GND_PIN, LOW);    //-GND for BBMobile module
  pinMode(BBMOBILE_POWER_PIN, OUTPUT) ;
  digitalWrite(BBMOBILE_POWER_PIN, HIGH); //-VCC for BBMobile module
  
  // set the data rate for the Hardware Serial port
  Serial.begin(9600) ;
  while(!Serial) ;

  Serial.println("\n\nSTART BBMOBILE DEMO APP") ;  

  // set the data rate for the BBMobile Software Serial port and set size of bbm_buf
  bbmSerial.begin(9600) ;
  bbm_buf.reserve(_SS_MAX_RX_BUFF) ;
  
  //-check serial communication with BBMobile module
  //------------------------------------------------
  Serial.print("Searching for BBMobile") ;  
  do {
    Serial.print(".") ;
    digitalWrite(LED_BUILTIN, HIGH);   //-turn the LED on
    delay(500) ;    
    digitalWrite(LED_BUILTIN, LOW);    //-turn the LED off
    delay(500);         
  } while(BBMobileSend(&bbmSerial, "<hello")) ;
  Serial.println("FOUND") ;  

  //-set BBMobile modules name
  //----------------------------------  
  Serial.print("Setting mobile name - ") ;  
  if(BBMobileSend(&bbmSerial, "<name,ARDUINO DEMO APP"))
  {
    Serial.println("err") ;
  } else Serial.println("OK") ;  

  //-set BBMobile modules PIN
  //----------------------------------    
  //Serial.print("Setting PIN - ") ;    
  //if( BBMobileSend(&bbmSerial, "<pin,123") )  //-set PIN to 123  
  Serial.print("Setting no PIN - ") ;    
  if( BBMobileSend(&bbmSerial, "<pin,0") )  //-delete PIN
  {
    Serial.println("err") ;
  } else Serial.println("OK") ;
}

void loop() {
  //lcd.setCursor(0, 1);
  //lcd.print(millis() / 1000);
}
