class Demoni {
  public PImage texture;
  float x;
  public float y;

  int mode = 0;

  Demoni() 
  {
    y = height / 2;
    x = -1024 * 2.2;
    texture = loadImage("DEMONI.png");
  }

  float t;

  void draw(float delta) {
    if (mode == 0 || mode == 2) {
      x += delta * 200;
    }

    if (mode == 1)  {
      t += delta;
      if (t > 3)
        mode = 2;
    }

    if (x > 200 && mode == 0) {
      mode = 1;
    }

    texture(texture);
    tint(255, 255);
    image(texture, x, y, 768, 384);   
  }  
}
