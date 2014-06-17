class Greets {
  int string = 0;
  int mode = 0;
  float alpha = 0;
  float wait = 0;

  Greets() 
  {
  }

  float t;

  void draw(float delta) {
    textSize(32);
    fill(255, 255, 255, alpha * 255);
    stroke(0, 0, 0, alpha * 255);

    textSize(40);
    switch (string) {
      case 0:
        text("Lemon Giraffe", 200, 200);
        text("sends greetz to", 200, 250);
        text("DOT", 200, 300);
        break;
      case 1:
        text("and", 200, 250);
        text("Peisik", 200, 300);
        break;
      case 2:
        text("also,", 200, 250);
        text("petrim", 200, 300);
        break;

      case 3:
        text("And our fish", 200, 200);
        text("sends greetz to", 200, 250);
        text("Napababa", 200, 300);
        break;
    }
    if (mode == 0) {
      alpha += delta * 0.4;
      if (alpha > 1) {
        alpha = 1;
        mode = 2;
      }
    }
    if (mode == 1) {
      wait += delta;
      if (wait > 8)
        mode = 2;
    }

    if (mode == 2) {
      alpha -= delta * 0.4;
      if (alpha < 0) {
        string++;
        wait = 0;
        mode = 0;
      }
    }
  }  
}
