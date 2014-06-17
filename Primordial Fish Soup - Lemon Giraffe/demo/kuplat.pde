class Kupla {
  public PImage texture;
  float x;
  public float y;
  float size;
  float mod;
  float lift;

  Kupla() {
    y = height + 50+ random(height) * 2; 
    size = random(width / 3); 
    x = random(width) - size / 2;
    mod = random(width / 300);
    lift = height/(random(height / 35)+200);
  }

  void draw(float secs) {
    tint(255, 127);  
    texture(texture);
    x = x + sin(secs * 0.5)*mod;
    y = y - lift * secs;
    image(texture, x, y, size, size);   
  }  
}
 
 class Kuplat {
  public PImage texture; 
  Kupla k[]; 

  void setup() {
    k = new Kupla[200];
    this.texture = loadImage("kupla.png");
    for (int i = 0; i < k.length; i++){
      k[i] = new Kupla();
      k[i].texture = this.texture;
    }
  }

  void draw(float secs) {
    strokeWeight(1);
    resetMatrix();    
    for (int i = 0; i < k.length; i++){
        if (k[i].y > -20) {
          k[i].draw(secs);
          //k[i] = null;
          //k[i] = new Kupla();
          //k[i].texture = this.texture;
          //k[i].y = height;
        }        
    }
  }
}
