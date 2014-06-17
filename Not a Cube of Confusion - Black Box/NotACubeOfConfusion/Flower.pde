class Flower {
  float x, y, time, maxTime;
  color c;

  Flower(float maxTime, int seed) {
    x = 0;
    y = 0;
    time = 0;
    this.maxTime = maxTime;

    setColor(seed);
  }

  Flower(float maxTime, float r, float g, float b) {
    x = 0;
    y = 0;
    time = 0;
    this.maxTime = maxTime;
    this.c = color(r, g, b);
  }

  private void setColor(int seed) {
    float r = 150 + seed * 30;
    if (((int)r / 255) % 2 != 0) {
      r = 255 - r % 255;
    } else {
      r = r % 255;
    }

    float g = 100 + seed  * 20;
    if (((int)g / 255) % 2 != 0) {
      g = 255 - g % 255;
    } else {
      g = g % 255;
    }

    float b = 50;
    if (((int)b / 255) % 2 != 0) {
      b = 255 - b % 255;
    } else {
      b = b % 255;
    }
    c = color(r, g, b);
  }

  float getTime() {
    return time;
  }

  void display() {
    if (time > maxTime)
      return;

    time += .02;

    stroke(c);
    noFill();

    beginShape();
    for (float i = 0; i < 8; i++) {
      curveVertex((time + .75) * cos((i - .5) / 8 * (2 * PI)), (time + .75) * sin((i - .5) / 8 * (2 * PI)), -1);
      curveVertex((time + .75) * cos((i - .5) / 8 * (2 * PI)), (time + .75) * sin((i - .5) / 8 * (2 * PI)), -1);
      curveVertex((time +.75) * 1.2 * cos(i / 8 * (2 * PI)), (time + .75) * 1.2 * sin(i / 8 * (2 * PI)), -1);
      curveVertex((time + .75) * cos((i + .5) / 8 * (2 * PI)), (time + .75) * sin((i + .5) / 8 * (2 * PI)), -1);
      curveVertex((time + .75) * cos((i + .5) / 8 * (2 * PI)), (time + .75) * sin((i + .5) / 8 * (2 * PI)), -1);
    }
    curveVertex(time * cos((- .5) / 8 * (2 * PI)), time * sin((- .5) / 8 * (2 * PI)), -1);
    endShape();
  }
}
