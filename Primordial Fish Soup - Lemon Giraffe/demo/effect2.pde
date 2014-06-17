class Effect2 implements Effect {
  void setup() {
  }

  void draw(float secs) {
    int d = 100;
    int p1 = d;
    int p2 = p1+d;
    int p3 = p2+d;
    int p4 = p3+d;
    
    background(0);
    translate(140, 0);
    
    // Draw gray box
    stroke(153, 0, 0);
    line(p3, p3, p2, p3);
    line(p2, p3, p2, p2);
    line(p2, p2, p3, p2);
    line(p3, p2, p3, p3);
    
    // Draw white points
    stroke(255, 200, 200);
    star(p1, p1, 30, 70, 5);
    star(p2, p2, 30, 50, 7);
    star(p3, p3, 20, 40, 9);
  }
  void star(float x, float y, float radius1, float radius2, int npoints) {
    float angle = TWO_PI / npoints;
    float halfAngle = angle/2.0;
    beginShape();
    for (float a = 0; a < TWO_PI; a += angle) {
      float sx = x + cos(a) * radius2;
      float sy = y + sin(a) * radius2;
      vertex(sx, sy);
      sx = x + cos(a+halfAngle) * radius1;
      sy = y + sin(a+halfAngle) * radius1;
      vertex(sx, sy);
    }
    endShape(CLOSE);
  }
}
