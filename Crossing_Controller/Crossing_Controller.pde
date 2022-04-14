import processing.serial.*;
Serial myPort;

//Faded circle to move around with initial size
PImage Face;
int size = 250;

//The xPoint arrays are the locations of the 'digital LED's' you hover over, and are used to check brightness at
//The bright arrays are used to store the current brightness of each LED, which are sent to Arduino over Serial
int[] xPoint1 = {70, 100, 130, 160, 190, 220, 250, 280, 310, 340, 370, 400, 430, 460, 490, 520,
                 550, 580, 610, 640, 670, 700, 730, 760};
int[] xPoint2 = {70, 100, 130, 160, 190, 220, 250, 280, 310, 340, 370, 400, 430, 460, 490, 520,
                 550, 580, 610, 640, 670, 700, 730, 760};
int[] bright1 = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int[] bright2 = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

void setup() {
  size(1280, 720);
  //Connect with Arduino
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[1], 9600);

  Face = loadImage("Face.png");
  imageMode(CENTER);
  stroke(100);
}

void draw() {
  background(0);
  //Circle follows mouse to change brightness of pixels in 'digital LEDs'
  image(Face, mouseX, mouseY, size, size);

  //Draw all the 'digital led lights'
  noFill();
  for (int i = 0; i < xPoint1.length; i++) {
    ellipse(xPoint1[i], 330, 20, 20);
  }
  for (int i = 0; i < xPoint2.length; i++) {
    ellipse(xPoint2[i], 360, 20, 20);
  }
  
  //Showing mouseX and mouseY for debugging
  text("Mouse X: " + mouseX, 20, 50);
  text("Mouse Y: " + mouseY, 20, 80);

  //If mouse has moved, check brightness of center pixel of each digital LED and store in Array
  if (mouseX != pmouseX || mouseY != pmouseY) {
    for (int i = 0; i < xPoint1.length; i++) {
      bright1[i] = int(brightness(get(xPoint1[i], 330)));
    }
    for (int i = 0; i < xPoint2.length; i++) {
      bright2[i] = int(brightness(get(xPoint2[i], 360)));
    }
     
    //Send arrays of brightness to Arduino
    send();
  }
  
  //Debugging
  printArray(bright2);
}

// Use Q and W keys to decrease or increase size of circle, causing more pixels to be lit up
void keyPressed() {
  if (keyCode == 'Q') {
    size -= 25;
  }
  if (keyCode == 'W') {
    size += 25;
  }
}

// Send arrays over Serial to Arduino, using start and stop marker, telling Arduino that values in between belong together
void send() {
  myPort.write('<');
  
  for (int i = 0; i < bright1.length; i++) {
    myPort.write(char(bright1[i]));
  }
  for (int i = 0; i < bright2.length; i++) {
    myPort.write(char(bright2[i]));
  }
  
  myPort.write('>');
  delay(100);
}
