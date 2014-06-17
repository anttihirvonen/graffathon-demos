 class Ruusu implements Effect {
   float alpha = 0;
  float r = height/12;  
  float leftr = 0.85;
  float rightr = 0.95; 
  void setup() {
  }

  void draw(float secs) {
    float x = width/2;
    float y = height/2.7;

    //background(0);
    resetMatrix();
    strokeWeight(2.0);
    tree(x, y, r, 0, secs, 0.5, 1);
  }
  void tree(float x, float y, float r, int end, float secs, float ang, float mult) {
    stroke(255 * mult, 32 * (1.0 - mult), 64 * mult, 255 * alpha);
    if (end > 9 || r <= 0){ 
      return; 
    }
    float asdf = sin(secs);
    //vasen
    float x2 = x + (r * cos(PI/4 + ((PI/2)*ang)));
    float y2 = y + (r * sin(PI/4 + ((PI/2)*ang)));
    line(x,height-y,x2,height-y2);
    tree(x2, y2, r*leftr, end+1, secs, ang+0.2+asdf, mult * 0.95);
    //oikea      
    tree(x2, y2, r*rightr, end+1, secs, ang-0.2+asdf, mult*0.86);
  }
}
