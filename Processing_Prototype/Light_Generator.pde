//First checks if marbles are within the gradients that control the settings. If two marbles are used, both settings are stored and a random value
//between them is chosen. If only one marble is used, if statements are used to check which one and that specific setting is returned. If nu marbles
//are used, a random setting is selected.
void Color() {
  if (dist(xMarble[0], yMarble[0], 400, height/2) < 350 && dist(xMarble[1], yMarble[1], 400, height/2) < 350) {
    int hueA = int(hue(get(xMarble[0], yMarble[0])));
    int hueB = int(hue(get(xMarble[1], yMarble[1])));

    if (hueB < hueA) {
      hueResult = int(random(0, hueA-hueB) + hueB);
    } else {
      hueResult = int(random(hueA, hueB));
    }
  } else if (dist(xMarble[0], yMarble[0], 400, height/2) < 350) {
    hueResult = int(hue(get(xMarble[0], yMarble[0])));
  } else if (dist(xMarble[1], yMarble[1], 400, height/2) < 350) {
    hueResult = int(hue(get(xMarble[1], yMarble[1])));
  } else {
    hueResult = int(random(0, 360));
  }
  setHue(); //Send settings to hue lights
}

//First checks if marbles are within the gradients that control the settings. If two marbles are used, both settings are stored and a random value
//between them is chosen. If only one marble is used, if statements are used to check which one and that specific setting is returned. If nu marbles
//are used, a random setting is selected.
void Saturation() {
  if (dist(xMarble[2], yMarble[2], 400, height/2) < 350 && dist(xMarble[3], yMarble[3], 400, height/2) < 350) {
    int satA = int(dist(xMarble[2], yMarble[2], 400, height/2));
    int satB = int(dist(xMarble[3], yMarble[3], 400, height/2));

    if (satA > satB) {
      satResult = int(map(random(satB, satA), 0, 350, 0, 100));
    } else {
      satResult = int(map(random(satA, satB), 0, 350, 0, 100));
    }
  } else if (dist(xMarble[2], yMarble[2], 400, height/2) < 350) {
    satResult = int(map(dist(xMarble[2], yMarble[2], 400, height/2), 0, 350, 0, 100));
  } else if (dist(xMarble[3], yMarble[3], 400, height/2) < 350) {
    satResult = int(map(dist(xMarble[3], yMarble[3], 400, height/2), 0, 350, 0, 100));
  } else {
    satResult = int(random(0, 100));
  }
  setHue(); //Send settings to hue lights
}

//First checks if marbles are within the gradients that control the settings. If two marbles are used, both settings are stored and a random value
//between them is chosen. If only one marble is used, if statements are used to check which one and that specific setting is returned. If nu marbles
//are used, a random setting is selected.
void Temperature() {
  if (xMarble[4] > 845 && xMarble[4] < 905 && yMarble[4] > height/2 && yMarble[4] < height/2 + 350 &&
    xMarble[5] > 845 && xMarble[5] < 905 && yMarble[5] > height/2 && yMarble[5] < height/2 + 350) {
    int pos;

    if (yMarble[4] > yMarble[5]) {
      pos = int(random(yMarble[5], yMarble[4]));
    } else {
      pos = int(random(yMarble[4], yMarble[5]));
    }

    tempResult = get(875, pos);
  } else if (xMarble[4] > 845 && xMarble[4] < 905 && yMarble[4] > height/2 && yMarble[4] < height/2 + 350) {
    tempResult = get(875, yMarble[4]);
  } else if (xMarble[5] > 845 && xMarble[5] < 905 && yMarble[5] > height/2 && yMarble[5] < height/2 + 350) {
    tempResult = get(875, yMarble[5]);
  } else {
    tempResult = 360;
  }
  setHue(); //Send settings to hue lights
}

//First checks if marbles are within the gradients that control the settings. If two marbles are used, both settings are stored and a random value
//between them is chosen. If only one marble is used, if statements are used to check which one and that specific setting is returned. If nu marbles
//are used, a random setting is selected.
void Brightness() {
  if (xMarble[6] > 945 && xMarble[6] < 1005 && yMarble[6] > height/2 && yMarble[6] < height/2 + 350 &&
    xMarble[7] > 945 && xMarble[7] < 1005 && yMarble[7] > height/2 && yMarble[7] < height/2 + 350) {
    int pos;

    if (yMarble[6] > yMarble[7]) {
      pos = int(random(yMarble[7], yMarble[6]));
    } else {
      pos = int(random(yMarble[6], yMarble[7]));
    }

    briResult = int(100 - map(pos, height/2, height/2 + 350, 0, 100));
  } else if (xMarble[6] > 945 && xMarble[6] < 1005 && yMarble[6] > height/2 && yMarble[6] < height/2 + 350) {
    briResult = int(100 - map(yMarble[6], height/2, height/2 + 350, 0, 100));
  } else if (xMarble[7] > 945 && xMarble[7] < 1005 && yMarble[7] > height/2 && yMarble[7] < height/2 + 350) {
    briResult = int(100 - map(yMarble[7], height/2, height/2 + 350, 0, 100));
  } else {
    briResult = 100;
  }
  setHue(); //Send settings to hue lights
}
