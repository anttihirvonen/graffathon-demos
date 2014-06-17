 class Puu { 
  float leftr = 0.85;
  float rightr = 0.95; 
  void setup() {
  }

  void draw(float secs, float x, float y, float r, float ang, float left, float right, float mult, float alpha) {
    strokeWeight(6);
    
    resetMatrix();

    stroke(50 * (1.0-mult), 255*mult, 92*mult, alpha * 255);
    line(x,height,x,height-y); //varrenpidennys
    tree(x, y, r, 0, secs, ang, left, right, mult, alpha);

  }
  void tree(float x, float y, float r, int end, float secs, float ang, float left, float right, float mult, float alpha) {
    if (end > 9 || r <= 0){ 
      return; 
    }
    stroke(50 * (1.0 - mult), 255*mult, 92*mult, alpha * 255);
    strokeWeight(6 - end/1.8);
    float asdf = cos(PI/2 + PI * secs * (6.0 / 8.0) ) / 20;
    //vasen
    float x2 = x + (r * cos(PI/4 + ((PI/2)*ang)));
    float y2 = y + (r * sin(PI/4 + ((PI/2)*ang)));
    line(x,height-y,x2,height-y2);
    tree(x2, y2, r*leftr, end+1, secs, ang+left+asdf, left, right, mult * 0.90, alpha);
    //oikea      
    tree(x2, y2, r*rightr, end+1, secs, ang+right+asdf, left, right, mult * 0.85, alpha);
  }
}
