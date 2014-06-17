class Clock {
  float x, y, clockTime, radius;
  int scatterCount, scatterMax;

  Clock(float x, float y) {
    this.x = x;
    this.y = y;
    clockTime = 0;
    radius = .9;
    scatterCount = 0;
    scatterMax = 200;
  }

  void custom() {
    if (clockTime >= 720) {
      clockTime = 720;
      return;
    }

    clockTime = 720.0 * sqrt(millis()) / (50.0 * sqrt(5.0));
  }

  //Not used on default
  void update(float amount) {
    clockTime += amount;
  }

  void display() {
    drawOuter(0, 0, 0);
    drawCenter(0, 0);
    drawLines(0, 0, 0);

    //Needles
    //time = time % 720; //uncomment if 'looping' required
    float hAngle = -((clockTime / 60) % 12) / 12 * 2 * PI + PI / 2;
    float mAngle = -(clockTime % 60) / 60 * 2 * PI + PI / 2;

    //Motion blur
    pushMatrix();

    for (int i = 1; i <= 2; i++) {
      stroke(0, 0, 0, 64 / i / i);
      fill(120, 120, 120, 64 / i / i);
      drawNeedle(5, hAngle + radians(i * 5 * (720 - clockTime) / 720), 0, 0, 0);
    }

    for (int i = 1; i <= 2; i++) {
      stroke(0, 0, 0, 64 / i / i);
      fill(120, 120, 120, 64 / i / i);
      drawNeedle(2, mAngle + radians(i * 10 * (720 - clockTime) / 720), 0, 0, 0);
    }
    popMatrix();

    //hour needle
    fill(120);
    drawNeedle(5, hAngle, 0, 0, 0);

    //Minute needle
    fill(120);
    drawNeedle(2, mAngle, 0, 0, 0);
  }

  //outer ring
  private void drawOuter(float dx, float dy, float rotation) {
    pushMatrix();
    ellipseMode(CENTER);
    translate(dx, dy);
    rotateZ(rotation);
    fill(125, 125, 255);
    ellipse(x, y, radius * 2.1, radius * 2.1);
    fill(255);
    ellipse(x, y, radius * 2, radius * 2);
    popMatrix();
  }

  //Center ellipse
  private void drawCenter(float dx, float dy) {
    pushMatrix();
    translate(dx, dy);
    fill(0);
    ellipse(x, y, radius * .1, radius * .1);
    popMatrix();
  }

  private void drawLines(float dx, float dy, float rotation) {
    pushMatrix();
    translate(dx, dy);
    rotateZ(rotation);
    fill(100, 100, 200);

    //Minute lines
    for (int i = 1; i <= 60; i++) {
      line(x + cos(radians(i * 6)) * radius * 0.85, y + sin(radians(i * 6)) * radius * 0.85, x + cos(radians(i * 6)) * radius * 0.9, y + sin(radians(i * 6)) * radius * 0.9);
    }

    //Hour lines
    for (int i = 1; i <= 12; i++) {
      line(x + cos(radians(i * 30)) * radius * 0.75, y + sin(radians(i * 30)) * radius * 0.75, x + cos(radians(i * 30)) * radius * 0.9, y + sin(radians(i * 30)) * radius * 0.9);
    }
    popMatrix();
  }

  private void drawNeedle(float thickness, float angle, float dx, float dy, float rotation) {
    pushMatrix();
    translate(dx, dy);
    rotateZ(rotation);

    beginShape();
    tint(255, 126);
    curveVertex(x, y);
    curveVertex(x, y);
    curveVertex(x + cos(angle - radians(thickness)) * radius / 2, y + sin(angle - radians(thickness)) * radius / 2);
    curveVertex(x + cos(angle) * radius, y + sin(angle) * radius);
    curveVertex(x + cos(angle + radians(thickness)) * radius / 2, y + sin(angle + radians(thickness)) * radius / 2);
    curveVertex(x, y);
    curveVertex(x, y);
    endShape();

    popMatrix();
  }

  void scatter() {
    scatterCount = min(scatterMax, scatterCount + 1);

    if (scatterCount < scatterMax) {
      float ratio = (float)scatterCount/scatterMax * 3;
      drawOuter(-ASPECT_RATIO * 4 * ratio, 5 * ratio, radians(180) * ratio);
      drawCenter(ASPECT_RATIO * ratio, 3 * ratio);
      drawLines(ASPECT_RATIO * ratio, -3 * ratio, radians(180) * ratio);
      drawNeedle(5, PI / 2, ASPECT_RATIO * 3 * ratio, 0, radians(180) * ratio);
      drawNeedle(2, PI / 2, -ASPECT_RATIO * 2 * ratio, -2 * ratio, radians(180) * ratio);
    }
  }

  boolean ready() {
    return clockTime == 720;
  }
  
  float ratio() {
    return clockTime / 720.0;
  }
}

