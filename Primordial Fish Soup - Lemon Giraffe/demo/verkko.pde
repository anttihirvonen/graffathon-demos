 class Verkko implements Effect {
  int div1 = 1;
  int div2 = 10;
  float r = height/12;  
  void setup() {
  }

  void draw(float secs) {
    strokeWeight(1);
    float x = width/2;
    float y = 0; 

    background(0);
    
    stroke(0, 255, 0);
    
    tree(x, y, r, 12, secs);

  }
  void tree(float x, float y, float r, int end, float secs) {
    if (end < 1){ 
      return; 
    }
    float x2 = x + (r * cos(PI/4 + ((PI/2)/div1)));
    float y2 = y + (r * sin(PI/4 + ((PI/2)/div1)));
    line(x,height-y,x2,height-y2);
    tree(x2, y2, r, end-1, secs%20);    
    x2 = x + (r * cos(PI/4 + ((PI/2)/div2-(end/secs))));
    y2 = y + (r * sin(PI/4 + ((PI/2)/div2-(end/secs))));
    line(x,height-y,x2,height-y2);    
    tree(x2, y2, r, end-1, secs%35);
  }
}
