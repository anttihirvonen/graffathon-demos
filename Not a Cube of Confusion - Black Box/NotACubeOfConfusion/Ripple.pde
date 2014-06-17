class Ripple {
  int i, a, b, index;
  int oldind, newind, mapind;
  short ripplemap[]; // the height map
  int col[]; // the actual pixels
  int riprad;
  int rwidth, rheight;
  int ttexture[];
  int ssize;

  float[][] randArr = new float[10][10];
  float x1, y1;
  PImage img;
  PFont fnt;

  Ripple() {
    // constructor
    index = 0;
    x1 = width / 2;
    y1 = height / 2;
    riprad = 3;
    fnt = loadFont("Impact-48.vlw");
    textFont(fnt);
    rwidth = width >> 1;
    rheight = height >> 1;
    ssize = width * (height + 2) * 2;
    ripplemap = new short[ssize];
    col = new int[width * height];
    ttexture = new int[width * height];
    oldind = width;
    newind = width * (height + 3);

    for (int j = 0; j < 10; j++) {
      for (int i = 0; i < 10; i++) {
        randArr[i][j] = random(width * height);
      }
    }
  }
  Box box;
  void init() {
    img = loadImage("data/rect.png");
    img.resize(width, height);
    box = new Box();
  }

  void newframe() {
    // update the height map and the image
    i = oldind;
    oldind = newind;
    newind = i;

    i = 0;
    mapind = oldind;
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        short data = (short)((ripplemap[mapind - width] + ripplemap[mapind + width] +
          ripplemap[mapind - 1] + ripplemap[mapind + 1]) >> 1);
        data -= ripplemap[newind + i];
        data -= data >> 5;
        if (x == 0 || y == 0) // avoid the wraparound effect
          ripplemap[newind + i] = 0;
        else
          ripplemap[newind + i] = data;

        // where data = 0 then still, where data > 0 then wave
        data = (short)(1024 - data);

        // offsets
        a = ((x - rwidth) * data / 1024) + rwidth;
        b = ((y - rheight) * data / 1024) + rheight;

        //bounds check
        if (a >= width)
          a = width - 1;
        if (a < 0)
          a = 0;
        if (b >= height)
          b = height-1;
        if (b < 0)
          b=0;

        col[i] = img.pixels[a + (b * width)];
        mapind++;
        i++;
      }
    }
    simulate();
  }

  void simulate() {

      float temp = randArr[index/ 10][(index) % 10];
      index = (index + 3) % 100;
      x1 = temp % width;
      y1 = temp / width;

      for (float j = y1 - ripple.riprad; j < y1 + ripple.riprad; j++) {
        for (float k = x1 - ripple.riprad; k < x1 + ripple.riprad; k++) {
          if (j >= 0 && j < height && k >= 0 && k < width) {
            ripple.ripplemap[(int)(ripple.oldind + (j * width) + k)] += 512;
          }
        }
      }
    
  }

  void draw(float time) {  
    resetShader();
    
    loadPixels();
    img.loadPixels();
    for (int loc = 0; loc < width * height; loc++) {
      pixels[loc] = col[loc];
    }
    updatePixels();
    newframe();
    
    box.drawCube(width/2.0, height/2.0+50, -150, 0, time*0.001f, 100, 0, 0, 1, 1);
    
    if(time < 2500){
      fill(160, 160, 160, 255 - (float)(time) / 2500 * 255);
      rect(0, 0, width, height);
    }
    
    fill(0);
    textSize(32);
    text("By Black Box", min(time / 5.0 - 700, width/2.0-100), height / 2 - 100);
    text("Thank you, and see you next year", min(time / 5.0 - 1200, width/2.0 - 250), height / 2 +200);
    
    if (time / 5.0 - 2200 > width/2.0-250)
    {
        fill(0, 0, 0, ((time / 5.0 - 2200) - (width/2.0-250)) / (time / 5.0 - 2200) * 255 * 2);
        rect(0, 0, width, height);
        
        song.setGain(((time / 5.0 - 2200) - (width/2.0-250)) / (time / 5.0 - 2200) * (-80));
        //song.shiftGain(-20, 0.0, 10000);
    }
  }
}

