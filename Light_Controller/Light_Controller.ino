#include <Adafruit_NeoPixel.h>
#define pinT 5
#define pinB 3
int pixelCount = 24;

//Separate connections for top and bottom strip used in prototype
Adafruit_NeoPixel stripT = Adafruit_NeoPixel(pixelCount, pinT, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel stripB = Adafruit_NeoPixel(pixelCount, pinB, NEO_GRB + NEO_KHZ800);

//Value that controls which LED the value is assigned to
int led = 0;

//Stores all 48 brightness values in on array. Splitting values for both strips happens below
int briVals[48] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

//Check if newData has been received and needs to be processed
bool newData = false;

void setup() {
  Serial.begin(9600);
  //yield();

  stripT.begin();
  stripB.begin();

  stripT.show();
  stripB.show();
}



void loop() {
  readSerial();
}



void readSerial() {
  //As long as there is data, repeat this code
  while (Serial.available() > 0) {
    char inc = Serial.read(); //Save current incoming character

    //Checking 'newData' prevents start/stop markers to be read as brightness values
    if (newData == true) {
      briVals[led] = inc; //Store brightness value in array
      led++; //Make sure the next value goes to the next LED

      if (led == sizeof(briVals)) {
        led = 0; //Once whole array is filled, start from first position again
      }
    }

    if (inc == '<') { //Start marker
      led = 0; //Move to beginning of array
      newData = true; //Allow data to be signed to array
    } else if (inc == '>') { //End marker
      newData = false; //Stop data being signed to array
      break; //Move out of while loop
    }
  }

  //Set first 24 values to the first strip
  for (int i = 0; i < pixelCount; i++) {
    stripT.setPixelColor(i, briVals[i], briVals[i], briVals[i]);
  }
  stripT.show();


  //Set second 24 values to second strip
  for (int i = pixelCount; i < pixelCount * 2; i++) {
    stripB.setPixelColor(i-pixelCount, briVals[i], briVals[i], briVals[i]);
  }
  stripB.show();
}
