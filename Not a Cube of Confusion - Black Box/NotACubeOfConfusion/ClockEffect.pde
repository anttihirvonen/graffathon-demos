int CANVAS_WIDTH;
int CANVAS_HEIGHT;

float ASPECT_RATIO;

int TIME;
float SECONDS;

float END;
float DARKEN;

//Clock variables
Clock clock;

//Backgound flower effect
BgEffect bgEffect = new BgEffect();

//Fire Effect
int fireCount = 6;
FireEffect[] f;


void initClockEffect() {
  END = 20;
  DARKEN = 6;

  CANVAS_WIDTH = width;
  CANVAS_HEIGHT = height;
  ASPECT_RATIO = (float)width/height;

  //Clock
  clock = new Clock(0, 0);

  //Fire Effect
  f = new FireEffect[fireCount * 2];
  int pixelSize = 8; //Increse to lower the processing consumation (and old-school feel), decrease to increase theoretical 'quality' (6 feels the best ATM)
  for (int i = 0; i < fireCount; i++) {
    f[i] = new FireEffect(ASPECT_RATIO * (i - (float)fireCount / 2) / (fireCount / 2), 0, ASPECT_RATIO / fireCount * 1.5, 1.0, pixelSize, 0);
  }

  //Downside
  for (int i = 0; i < fireCount; i++) {
    f[fireCount + i] = new FireEffect(ASPECT_RATIO * (i - (float)fireCount / 2) / (fireCount / 2), 0, ASPECT_RATIO / fireCount * 1.5, 1.0, pixelSize, PI);
  }
}


/*
 * Processing's drawing method
 */
float weight = 0.08;

void drawClockEffect(float time) {
  SECONDS = time / 1000.0;
  drawOpening(time);
}

//Opening drawn under assumption: 60FPS
void drawOpening(float time) {
  clear();
  if (SECONDS > END) {
    //background(255);
    return;
  }

  translate(CANVAS_WIDTH/2.0, CANVAS_HEIGHT/2.0);
  scale(CANVAS_WIDTH/2.0/ASPECT_RATIO, -CANVAS_HEIGHT/2.0);

  //Match strokewidth with scaling
  strokeWeight(weight);

  bgEffect.display(weight, clock.ratio() > 0.75);

  //clock.update(2);
  clock.custom();

  if (clock.ready())
    clock.scatter();
  else  
    clock.display();

  if (SECONDS > 1) {
    pushMatrix();
    translate(0, 0, -1);

    //Fire-effect
    for (int i = 0; i < f.length; i++) {
      pushMatrix();
      float dir = f[i].getDir();
      if (dir >= 0)
        translate(cos(millis() / 1000.0) / 8, min(0, (DARKEN - SECONDS) * .15), 0);
      else
        translate(cos(millis() / 1000.0) / 8, max(0, -(DARKEN - SECONDS) * .15), 0);

      f[i].display(time);
      popMatrix();
    }
    popMatrix();
  }
}




