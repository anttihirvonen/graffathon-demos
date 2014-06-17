Mesh blob;
Mesh blobPulse;

Mesh fishDefault;
Mesh fishUpperFin;
Mesh fishLowerFin;
Mesh fishTail;
Mesh fishMouth;

Mesh seaStar;
Mesh seaStarPulse;

Mesh squid;
Mesh squidPulse;


class Fish {
  MeshSet meshSet;
  public float fins;
  public float tail;
  public float mouth;

  public float mode = -1;

  public float energy;

  public PImage blobTexture;
  public PImage fishTexture;
  public PImage seastarTexture;
  public PImage squidTexture;

  public Color fillColor;
  public Color strokeColor;

  public float speedX;
  public float speedY;
  public float initSpeedX;
  public float initSpeedY;
  public float x;
  public float y;

  public float seastarness;
  public float fishiness;
  public float squidness;
  public float blobness;

  public float phase;

  public void step(float sec, float secdiff) {
    x += speedX * secdiff;
    y += speedY * secdiff; 

    speedX *= 1 - 2.995 * secdiff;
    speedY *= 1 - 2.995 * secdiff;


    energy *= 1.0 - 0.95 * secdiff;

    fishiness = 0; 
    seastarness = 0; 
    squidness = 0;
    blobness = 0;
    if (mode < 0)
    {
      blobness = -mode;
      seastarness = 1 + mode;
    }
    else if (mode < 1)
    {
      seastarness = 1 - mode;
      fishiness = mode;
    }
    else if (mode <= 2) {
      fishiness = 2 - mode;
      squidness = mode - 1;
    }
    else {
      seastarness = mode - 2;
      squidness = mode - 2;
      fishiness = mode - 2;
    }

    meshSet.parameters[0] = fishiness;
    meshSet.parameters[1] = energy * fishiness;
    meshSet.parameters[2] = energy * fishiness;
    meshSet.parameters[3] = energy * fishiness;
    meshSet.parameters[4] = (sin(sec * 3 + phase) * 0.5 + 0.5) * fishiness;
    meshSet.parameters[5] = seastarness;
    meshSet.parameters[6] = energy * seastarness;
    meshSet.parameters[7] = squidness;
    meshSet.parameters[8] = energy * squidness; 
    meshSet.parameters[9] = blobness;
    meshSet.parameters[10] = energy * blobness;
  }

  public void pulse() {
    energy = 1;
    speedX = initSpeedX;
    speedY = initSpeedY;
  }

  Fish() {
    meshSet = new MeshSet(11, 200);
    meshSet.setMesh(0, fishDefault, 0);
    meshSet.setMesh(1, fishUpperFin, 0);
    meshSet.setMesh(2, fishLowerFin, 0);
    meshSet.setMesh(3, fishTail, 0);
    meshSet.setMesh(4, fishMouth, 0);
    meshSet.setMesh(5, seaStar, 0.3);
    meshSet.setMesh(6, seaStarPulse, 0.3);
    meshSet.setMesh(7, squid, 0);
    meshSet.setMesh(8, squidPulse, 0);
    meshSet.setMesh(9, blob, 0);
    meshSet.setMesh(10, blobPulse, 0);

    meshSet.parameters[0] = 1;
    meshSet.parameters[1] = 0;
    meshSet.parameters[2] = 0;
    meshSet.parameters[3] = 0;
    meshSet.parameters[4] = 0;
    meshSet.parameters[5] = 0;
    meshSet.parameters[6] = 0;
    meshSet.parameters[7] = 0;
    meshSet.parameters[8] = 0;
    meshSet.parameters[9] = 0;
    meshSet.parameters[10] = 0;
  }

  void draw() {
    pushMatrix();

    translate(x, y);

    rotate(atan2(initSpeedX, initSpeedY));

    Mesh m = meshSet.getMesh();

    scale(height / 3);

    if (blobness > 0)
      m.renderWithImage(blobTexture, 255);
    if (seastarness > 0)
      m.renderWithImage(seastarTexture, (int)(blobness > 0 ? (seastarness * 255) : 255));
    if (fishiness > 0)
      m.renderWithImage(fishTexture, (int)(seastarness > 0 ? (fishiness * 255) : 255));
    if (squidness > 0)
      m.renderWithImage(squidTexture, (int)(squidness * 255));


    float eye1X 
      = 0.7 * fishiness
      + -0.2 * seastarness
      + 0.7 * squidness;
    float eye1Y 
      = -0.1 * fishiness
      + 0 * seastarness
      + -0.15 * squidness;
      ;
    float eye2X 
      = 0.7 * fishiness
      + 0.2 * seastarness
      + 0.7 * squidness;
    float eye2Y 
      = -0.1 * fishiness
      + 0 * seastarness
      + 0.15 * squidness;

    fill (0, 255 * (1.0 - blobness));
    ellipse(eye1X, eye1Y, 0.13, 0.13);
    fill (255, 255 * (1.0 - blobness));
    ellipse(eye1X + 0.04, eye1Y - 0.04, 0.04, 0.04);

    fill (0, 255 * (1.0 - blobness));
    ellipse(eye2X, eye2Y, 0.13, 0.13);
    fill (255, 255 * (1.0 - blobness));
    ellipse(eye2X + 0.04, eye2Y - 0.04, 0.04, 0.04);

    popMatrix();
  }
}

class EvolveBlob implements Effect {
  Fish f;
  boolean moveout; 
  PImage blobTexture;
  PImage fishTexture;
  PImage seastarTexture;
  PImage squidTexture;
  int lastPulse;

  void setup() {
    fishDefault = new Mesh(17);
    blob = new Mesh(8);
    blobPulse = new Mesh(8);
    fishUpperFin = new Mesh(17);
    fishLowerFin = new Mesh(17);
    fishTail = new Mesh(17);
    fishMouth = new Mesh(17);

    blob
      .v(1, 0)
      .v(0, -0.4)
      .v(-0.5, -0.5)
      .v(-1, -0.5)
      .v(-0.9, -0.3)
      .v(-0.7, 0)
      .v(-0.4, 0.6)
      .v(0.8, 0.8);

    blobPulse
      .v(-0.5, -0.2)
      .v(-0.3, 0.3)
      .v(-0.3, 0.3)
      .v(0.1, 0.5)
      .v(0.1, 0.5)
      .v(0.3, 0.2)
      .v(-0.2, 0.2)
      .v(-0.2, 0.1);

    fishDefault
      .v(1,    0.1)    //Lower lip
      .v(0.96, 0)      //Mouth
      .v(1,    -0.1)   //Upper lip
      .v(0.6,  -0.28)
      .v(0.2,  -0.3) // Upper fin begin
      .v(0,    -0.35) // Upper fin top
      .v(-0.3, -0.5) // Upper fin top
      .v(-0.3, -0.15) // Upper fin end
      .v(-0.3, -0.2) // Tail begin
      .v(-0.35, -0.17) // Tail upper
      .v(-0.4,  0) // Tail middle
      .v(-0.35,  0.17) // Tail middle
      .v(-0.3,  0.2) // Tail end
      .v(-0.3,  0.15) // Lower fin begin
      .v(-0.3,  0.5) // Lower fin bottom
      .v(0.2,  0.3) // Lower fin end
      .v(0.6,  0.28); // Lower fin end

    fishUpperFin
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(-0.05, -0.4)
      .v(-0.03, -0.5)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0);

    fishLowerFin
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(-0.05, 0.5)
      .v(0, 0)
      .v(0, 0);

    fishTail
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(-0.25, 0)
      .v(-0.65, -0.35)
      .v(-0.25, 0)
      .v(-0.65, 0.35)
      .v(-0.25, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0);

    fishMouth
      .v(0, 0.05)
      .v(-0.2, 0)
      .v(0, -0.05)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0)
      .v(0, 0);

    seaStar = new Mesh(10);

    for (int i = 0; i < 10;) {
      seaStar.v(cos(-TWO_PI * i / 10.0), sin (-TWO_PI * i / 10.0));
      ++i;
      seaStar.v(cos(-TWO_PI * i / 10.0) * 0.3, sin (-TWO_PI * i / 10.0) * 0.3);
      ++i;
    }

    seaStarPulse = new Mesh(10);

    for (int i = 0; i < 10;) {
      seaStarPulse.v(0, 0);
      ++i;
      seaStarPulse.v(cos(-TWO_PI * i / 10.0) * 0.3, sin (-TWO_PI * i / 10.0) * 0.3);
      ++i;
    }

    squid = new Mesh(50);
    squid
      .v(1,    0) 
      .v(0.98, -0.02)
      .v(0.96, -0.015)
      .v(0.6,  -0.515)
      .v(0.15, -0.2)
      .v(0,    -0.8)
      .v(0,    -0.8)
      .v(0,    -0.8)
      .v(0,    -0.8)
      .v(0,    -0.8)

      .v(-0.95,-0.9)

      //.v(-1,   -0.95)
      //.v(-0.2, -0.90)
      .v(-1,   -0.85)
      .v(-0.2, -0.70)
      .v(-0.1, -0.65)
      .v(-0.2, -0.60)
      .v(-1,   -0.55)

      .v(-0.2, -0.40)
      .v(-0.1, -0.35)
      .v(-0.2, -0.30)
      .v(-1,  -0.20)
      .v(-0.2, -0.10)
      .v(-0.1, -0.05)
      .v(-0.2, -0.00)
      .v(-1,  0.05)
      .v(-0.2, 0.10)
      .v(-0.1, 0.15)

      .v(-0.2, 0.20)
      .v(-1,  0.25)
      .v(-0.2, 0.30)
      .v(-0.1, 0.35)
      .v(-0.2, 0.40)
      .v(-1,  0.45)
      .v(-0.2, 0.50)
      .v(-0.1, 0.55)
      .v(-0.2, 0.60)
      .v(-1,  0.65)

      .v(-0.2, 0.70)
      .v(-0.1, 0.75)
      .v(-0.2, 0.80)
      .v(-1,  0.85)
      .v(-0.95,0.9)

      .v(0,    0.8)

      .v(0,    0.8)
      .v(0,    0.8)
      .v(0,    0.8)
      .v(0,    0.8)

      .v(0.15, 0.2)
      .v(0.6,  0.515)
      .v(0.96, 0.015)
      .v(0.98, 0.02)
      ;

    squidPulse = new Mesh(50);
    squidPulse
      .v(0,    0) 
      .v(0,    0) 
      .v(0,    0) 
      .v(0,    -0.3) 
      .v(0,    0) 

      .v(0.3,    0.1) 
      .v(0.3,    0.1) 
      .v(0.3,    0.1) 
      .v(0.3,    0.1) 
      .v(0.3,    0.1) 

      .v(0,    0) 

      .v(0,    0) 
      .v(0.2,  0)
      .v(0.2,  0)
      .v(0.2,  0)
      .v(0,    0) 

      .v(0.2,  0)
      .v(0.2,  0)
      .v(0.2,  0)
      .v(0,    0) 
      .v(0.2,  0)
      .v(0.2,  0)
      .v(0.2,  0)
      .v(0,    0) 

      .v(0.2,  0)
      .v(0.2,  0)
      .v(0.2,  0)
      .v(0,    0) 

      .v(0.2,  0)
      .v(0.2,  0)
      .v(0.2,  0)
      .v(0,    0) 
      .v(0.2,  0)
      .v(0.2,  0)
      .v(0.2,  0)
      .v(0,    0) 

      .v(0.2,  0)
      .v(0.2,  0)
      .v(0.2,  0)
      .v(0,    0) 
      .v(0, 0)

      .v(0.3, 0.1)
      .v(0.3, 0.1)
      .v(0.3, 0.1)
      .v(0.3, 0.1)
      .v(0.3, 0.1)

      .v(0,    0)
      .v(0,  0.3)
      .v(0,    0)
      .v(0,    0);


    lastPulse = 0;
    f = new Fish();
    f.phase = 1;
    f.strokeColor = new Color(0,94,128);

    this.blobTexture = loadImage("renderclouds.jpg");
    this.fishTexture = loadImage("ananas.jpg");
    this.seastarTexture = loadImage("seastar.jpg");
    this.squidTexture = loadImage("mustekala1.jpg");

    f.blobTexture = this.blobTexture;
    f.fishTexture = this.fishTexture;
    f.seastarTexture = this.seastarTexture;
    f.squidTexture = this.squidTexture;

    f.x = -width;
    f.y = -height;
    //f.x = width / 2;
    //f.x = height / 2;
    f.speedX = 0;
    f.speedY = 0;
    f.initSpeedX = width / 3;
    f.initSpeedY = height / 3;
    lastSec = 0;
  }

  float lastSec;

  void pulse() {
    if (moveout) {
    f.initSpeedX = 150;
    f.initSpeedY = 150;
    }
    else {
      float distx = width / 2 - f.x;
      float disty = height / 2 - f.y;
      distx *= distx;
      disty *= disty;
      if (distx + disty > 12000) {
        f.initSpeedX = width / 2 - f.x;
        f.initSpeedY = height / 2 - f.y;
        float l = 400 / sqrt(f.initSpeedX * f.initSpeedX + f.initSpeedY * f.initSpeedY);
        f.initSpeedX *= l;
        f.initSpeedY *= l;
      }
    }
    f.pulse();
  }

  void draw(float secs) {
    resetMatrix();


    float delta = secs - lastSec;
    if (lastSec == 0)
      delta = 0;
    f.step(secs, delta);
    //f.mode=-1;
    //f.mode=(0.5 + 0.5* sin(secs/10)) * 3.0 - 1.0;
    lastSec = secs;

    f.draw();
  }
}
