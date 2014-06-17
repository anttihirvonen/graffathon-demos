class Group {
  public PImage texture;
  float x;
  public float y;

  int mode = 0;

  Group() 
  {
    y = height / 5;
    x = -512;
    texture = loadImage("GROUP.png");
  }

  float t;

  void draw(float delta) {
    if (mode == 0 || mode == 2) {
      x += delta * 150;
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
