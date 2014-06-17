class FireEffect {
  float x, y, rot;
  int w, h; 
  int min = 0;
  int max = 99;
  int[][] colorArr;
  int pixelSize; //Pixel multiplier, 4 by default

  float[][] randArr = new float[10][10];
  int index = 0;

  //Note: Height won't affect fire texture after certain amount (~height/2), especially if width is small
  FireEffect(float x, float y, float w, float h, int pixelSize, float rot) {
    this.x = x;
    this.y = y;
    this.pixelSize = pixelSize;
    this.w = (int)(w / ASPECT_RATIO * CANVAS_WIDTH) / pixelSize;
    this.h = (int)(h * CANVAS_HEIGHT) / pixelSize;
    this.rot = rot;
    colorArr = new int[this.w][this.h];


    for (int j = 0; j < 10; j++) {
      for (int i = 0; i < 10; i++) {
        randArr[i][j] = random(100);
      }
    }
  }

  private void initColors(float time)
  {
    for (int i = 0; i < w; i++) {
      float r = randArr[index / 10][index % 10];
      index = (index + 1) % 100;
      
      if (r < 70)
        colorArr[i][h-1] = min;
      else
        colorArr[i][h-1] = max;
    }

    for (int i = 0; i < w; i++) {
      for (int j = h - 2; j > 0; j--) {
        if (i == 0 || i == w - 1)
          colorArr[i][j] = min;
        else {
          colorArr[i][j] = (colorArr[i - 1][j + 1] + colorArr[i][j + 1] + colorArr[i + 1][j + 1]) / 3;
        }
      }
    }
  }

  void display(float time) {
    initColors(time);
    noStroke();

    pushMatrix();
    rotateZ(rot);

    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        float value = colorArr[i][j];
        fill(getColor(value));

        if (value > 5) {
          rect(x + (float)i * pixelSize / CANVAS_WIDTH * ASPECT_RATIO, y - (float)j * pixelSize / CANVAS_HEIGHT, 
          ASPECT_RATIO * 2.0 / CANVAS_WIDTH * pixelSize, 2.0 / CANVAS_HEIGHT * pixelSize);
        }
      }
    }
    popMatrix();
    stroke(0);
  }

  //normal red/orange fire
  private color getColor(float value) {
    //return color(255 * value / max, 160 * value / max, 0);

    if (value < max * .33) {
      return color((value / (max * .33)) * 255, 0, 0);
    } else if (value >= max * .33 && value < max * .67) {
      return color(255, ((max * .67 - value) / (max * .34)) * 160, 0);
    } 
    return color(255, ((max * .67 - value) / (max * .34)) * 160, 125); 
    //return color(255, 255, ((max - value) / max) * 255);
  }

  //Blue-yellowish fire
  private color getColor2(float value) {
    if (value < max * .33) {
      return color((value / (max * .33)) * 255, (value / (max * .33)) * 255, 0);
    } else if (value >= max * .33 && value < max * .67) {
      return color(0, ((max * .67 - value) / (max * .34)) * 160, 255);
    } 
    return color(((max - value) / max) * 255, ((max * .67 - value) / (max * .34)) * 160, 255);
  }

  //Greenish fire
  private color getColor3(float value) {
    //return color(255 * value / max, 160 * value / max, 0);

    if (value < max * .33) {
      return color(0, (value / (max * .33)) * 255, 0);
    } else if (value >= max * .33 && value < max * .67) {
      return color(0, 255, ((max * .67 - value) / (max * .34)) * 160);
    } 
    return color(((max - value) / max) * 255, 255, ((max * .67 - value) / (max * .34)) * 160);
  }

  float getDir() {
    return sin(rot);
  }
}

