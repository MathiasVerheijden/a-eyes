//NOTE: Temperature settings generated from this program are not sent to Philips Hue lights as they do not support both color and temperature settings in the same bulb at the same time.

import http.requests.*;

//These values can be found in developer mode of Hue bridge. Check Philips Hue API how to do this
String Username = "[INSERT USERNAME]";
String IP = "[INSER HUE BRIDGE IP]";

// Place is the locations of the placeholders
// Marble is the current locations of the marbles
// Cachhe is the previous locations of the marbles, to check if a marble has moved
// The first two values are for setting hue, the next two for saturation, the next two for temperature, and the final two for brightness
int[] xPlace = {875, 975, 875, 975, 875, 975, 875, 975};
int[] yPlace = {100, 100, 180, 180, 260, 260, 340, 340};
int[] xMarble = {875, 975, 875, 975, 875, 975, 875, 975};
int[] yMarble = {100, 100, 180, 180, 260, 260, 340, 340};
int[] xCache = {875, 975, 875, 975, 875, 975, 875, 975};
int[] yCache = {100, 100, 180, 180, 260, 260, 340, 340};

// Variables to store the current light settings
int hueResult;
int satResult;
int briResult;
color tempResult = 360;

// Booleans used to activate functions in draw()
int selected = -1;
boolean hue = false;
boolean sat = false;
boolean bri = false;
boolean temp = false;

// Images used in the sketch
PImage cl_wheel;
PImage br_slider;
PImage ct_slider;

void setup() {
  size(1112, 834);
  colorMode(HSB, 360, 100, 100, 100);
  background(240);

  cl_wheel = loadImage("Color_Ring.png");
  ct_slider = loadImage("Temp_Slider.png");
  br_slider = loadImage("Bright_Slider.png");

  imageMode(CENTER);
  ellipseMode(CENTER);
  textSize(28);
  textAlign(LEFT);

  fill(360);
  // Calls function to get current state of the Hue lights
  getHue();
}


void draw() {
  background(120);

  //Draw displays
  fill(tempResult);
  ellipse(400, height/2, 680, 680);
  image(cl_wheel, 400, height/2, 700, 700);
  image(ct_slider, 875, height/2 + 175, 60, 350);
  image(br_slider, 975, height/2 + 175, 60, 350);
  
  //Draws black circle over hue/saturation circle. Opacity based on brightness setting
  if (briResult < 100) {
    fill(0, 0, 0, 100 - briResult);
    ellipse(400, height/2, 700, 700);
  }

  //Values are set true in mouseReleased(), corresponding function is executed to update light settings
  if (hue == true) {
    Color();
    hue = false;
  }
  if (sat == true) {
    Saturation();
    sat = false;
  }
  if (temp == true) {
    Temperature();
    temp = false;
  }
  if (bri == true) {
    Brightness();
    bri = false;
  }

  //Draw Placeholders
  stroke(0);
  fill(360);
  for (int i = 0; i < 8; i++) {
    ellipse(xPlace[i], yPlace[i], 70, 70);
  }

  //Draw Marbles
  stroke(360);
  fill(300);
  for (int i = 0; i < 8; i++) {
    ellipse(xMarble[i], yMarble[i], 60, 60);
  }

  //selected is determined in mousePressed. Correspoding marble will stick to mouse location.
  if (mousePressed == true && selected != -1) {
    xMarble[selected] = mouseX;
    yMarble[selected] = mouseY;
  }


  //Showing mouseX and mouseY for debugging
  text("Mouse X: " + mouseX, 20, 50);
  text("Mouse Y: " + mouseY, 20, 80);
  text("Hue " + hueResult, 20, 720);
  text("Sat " + satResult, 20, 750);
  text("Temp " + tempResult, 20, 780);
  text("Bri " + briResult, 20, 810);
}


// Once mouse is pressed, distance between mouse and every marble location is checked. When one distance is shorter than the marble size, that marble becomes 'selected'
void mousePressed() {
  for (int i = 0; i < 8; i++) {
    if (dist(xMarble[i], yMarble[i], mouseX, mouseY) < 60) {
      selected = i;
    }
  }
}

// Once mouse is released, a new setting has been made, so all locations should be checked.
void mouseReleased() {
  // If a marble is over its placeholder, it is placed exactly to the middle of the placeholder
  if (selected != -1 && dist(xMarble[selected], yMarble[selected], xPlace[selected], yPlace[selected]) < 60) {
    xMarble[selected] = xPlace[selected];
    yMarble[selected] = yPlace[selected];
  }
  //The mouse is no longer pressed, so selected is set to -1 so no marbles move along with mouse
  selected = -1;

  // For each setting (hue, sat, temp, bright), the current location is checked against the cached location. If there is a difference, a function is called to determine the new light setting
  for (int i = 0; i < 2; i++) {
    if (xMarble[i] != xCache[i]) {
      xCache[i] = xMarble[i]; //Update cache to new
      hue = true;
    }
  }

  for (int i = 2; i < 4; i++) {
    if (xMarble[i] != xCache[i]) {
      xCache[i] = xMarble[i]; //Update cache to new
      sat = true;
    }
  }

  for (int i = 4; i < 6; i++) {
    if (xMarble[i] != xCache[i]) {
      xCache[i] = xMarble[i]; //Update cache to new
      temp = true;
    }
  }

  for (int i = 6; i < 8; i++) {
    if (xMarble[i] != xCache[i]) {
      xCache[i] = xMarble[i]; //Update cache to new
      bri = true;
    }
  }
}

// Function used to send HTTP PUT requests to the Hue bridge using the given IP, username
// and lightnumber in the URL. Adds brightness and temperature in JSON format and changes lights.
// Uses modified version of HTTP requests library for processing (see PostRequest.java), since
// PUT requests are originally not supported at this moment. The original library is still required.
void setHue() {
  int hue = int(map(hueResult, 0, 360, 0, 65535));
  int bri = int(map(briResult, 0, 100, 0, 254));
  int sat = int(map(satResult, 0, 100, 0, 254));
  
  PostRequest put = new PostRequest("http://"+IP+"/api/"+Username+"/lights/1/state");
  put.method("PUT");
  put.addJson("{\"bri\":"+bri+", \"hue\":"+hue+", \"sat\":"+sat+", \"on\":true}");
  put.send();
  delay(100);
  return;
}

// Function used to send HTTP GET requests to the Hue bridge using the given IP, username
// and lightnumber in the URL. Can also be room number to conrol all lights. Gets nested JSON object,
// so double parse is required. Then, gets integer values of current settings of the lights.
void getHue() {
  GetRequest get = new GetRequest("http://"+IP+"/api/"+Username+"/lights/1");
  get.send();
  JSONObject lightState = parseJSONObject(get.getContent());
  JSONObject State = lightState.getJSONObject("state");
  int bri = State.getInt("bri");
  int hue = State.getInt("hue");
  int sat = State.getInt("sat");
  
  //Light values are mapped to the ranges used in this program
  briResult = int(map(bri, 0, 254, 0, 100));
  satResult = int(map(sat, 0, 254, 0, 100));
  hueResult = int(map(hue, 0, 65535, 0, 360));
}
