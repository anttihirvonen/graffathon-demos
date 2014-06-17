 class JatkuvatKuplat {
  public PImage texture; 
  Kupla k[]; 
  boolean isStopped = false;
  void stop() {
    isStopped = true;
  }

  void setup() {
    k = new Kupla[20];
    this.texture = loadImage("kupla.png");
    for (int i = 0; i < k.length; i++){
      k[i] = new Kupla();
      k[i].texture = this.texture;
      k[i].size = random(width / 20) + 10;
        do {
        k[i].x = random(-sqrt(width / 2), sqrt(width / 2));
        k[i].x *= abs(k[i].x);
      k[i].x += k[i].x + width / 2;
      } while (k[i].x > width / 3 && k[i].x < width / 3 * 2);
      k[i].lift /= 5;
    }
  }

  void draw(float secs) {
    strokeWeight(1);
    resetMatrix();    
    for (int i = 0; i < k.length; i++){
        k[i].draw(secs);
        if (k[i].y < -20) {
          if (!isStopped) 
          {
          k[i] = new Kupla();
          k[i].texture = this.texture;
          k[i].y = height;
          k[i].size = random(width / 20) + 10;

          do {
          k[i].x = random(-sqrt(width / 2), sqrt(width / 2));
          k[i].x *= abs(k[i].x);
          k[i].x += k[i].x + width / 2;
          } while (k[i].x > width / 3 && k[i].x < width / 3 * 2);

          k[i].lift /= 5;
          }
        }        
    }
  }
}
