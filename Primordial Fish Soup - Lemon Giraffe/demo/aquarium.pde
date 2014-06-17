class Aquarium implements Effect {
  Background background;
  EvolveBlob evolveBlob;
  Puu puu;
  Ruusu ruusu;
  Group group;
  Greets greets;
  Demoni demoni;
  float dir = -1;
  Kuplat kuplat;
  JatkuvatKuplat jkuplat;

  float treeMultiplier = 0;
  float treeColor = 0;
  float puuSvengi = 0;
  float treeAlpha = 0;

  int mode;

  public void setup() {
    mode = 0;

    greets = new Greets();
    ruusu = new Ruusu();
    group = new Group();
    demoni = new Demoni();
    ruusu.setup();
    background = new Background();
    evolveBlob = new EvolveBlob();
    evolveBlob.setup();
    //fishes = new Fishes();
    puu = new Puu();
    background.setup();
    //fishes.setup();
    puu.setup();
    kuplat = new Kuplat();
    jkuplat = new JatkuvatKuplat();
    jkuplat.setup();
  }

  public float lastSecs = 0;

  int prevBar = -1;
  int prevBeat = -1;

  public void draw(float secs) {
    int curBar = floor(secs / (6.0 / 8.0));
    int curBeat = floor(secs / (6.0 / 8.0) * 4);

    boolean didBarChange = curBar != prevBar;
    prevBar = curBar;

    boolean didBeatChange = curBeat != prevBeat;
    prevBeat = curBeat;

    float delta = secs - lastSecs;
    if (lastSecs == 0.0) {
      delta = 0; }
    lastSecs = secs;

    if (secs > 5 && mode < 1) {
      mode = 1;
    }
    if (secs > 25 && mode < 2) {
      mode = 2;
      kuplat.setup();
    }
    if (secs > 28 && mode < 3) {
      mode = 3;
    }
    if (secs > 38 && mode < 4) {
      mode = 4;
      kuplat.setup();
    }
    if (secs > 41 && mode < 5) {
      mode = 5;
    }

    if (secs > 61 && mode < 6) {
      mode = 6;
    }

    if (secs > 81 && mode < 7) {
      mode = 7;
    }

    if (secs > 101 && mode < 8) {
      mode = 8;
    }
    if (secs > 121 && mode < 9) {
      mode = 9;
    }

    if (secs > 141 && mode < 10) {
      mode = 10;
      jkuplat.stop();
    }

    switch (mode) {
      case 0: //FADE IN
        background.multR += 0.15 * delta;
        if (background.multR > 1)
          background.multR = 1;

        background.multB += 0.15 * delta;
        if (background.multB > 1)
          background.multB = 1;
        break;

      case 1: // GROW TREES
        treeAlpha += 0.3 * delta;
        if (treeAlpha > 1)
          treeAlpha = 1;

        treeMultiplier += 0.1 * delta;
        if (treeMultiplier > 1)
          treeMultiplier = 1;
        treeColor += 0.1 * delta;
        if (treeColor > 1) 
          treeColor = 1;
        break;

      case 2: // BUBBLES
        treeMultiplier -= 0.4 * delta;
        if (treeMultiplier < 0)
          treeMultiplier  = 0;
        treeAlpha -= 0.5 * delta;
        if (treeAlpha < 0)
          treeAlpha = 0;
        ruusu.alpha += 0.34*delta;
        if (ruusu.alpha > 1)
          ruusu.alpha = 1;
        break;

      case 3: // BRING IN THE DNA ROSE WHATEVER
        break;

      case 4: // MORE BUBBLES
        ruusu.alpha -= 0.5*delta;
        if (ruusu.alpha < 0)
          ruusu.alpha = 0;
        break;

      case 5: // BRING IN THE BLOB, GROW THE TREES BACK
        treeAlpha += 0.25 * delta;
        if (treeAlpha > 1)
          treeAlpha = 1;

        if (treeMultiplier < 1)
          treeMultiplier += 0.10 * delta;
        else
          treeMultiplier = 1;
        puuSvengi += 0.1 * delta;
        if (puuSvengi > 1)
          puuSvengi = 1;


        break;

      case 6: // EVOLVE TO STARFISH
        evolveBlob.f.mode += 0.1 * delta;
        if (evolveBlob.f.mode > 0)
          evolveBlob.f.mode = 0;

        background.multG += 0.01 * delta;
        if (background.multG > 1)
          background.multG = 1;

        background.multB += 0.01 * delta;
        if (background.multB > 1)
          background.multB = 1;

        break;

      case 7: // EVOLVE TO FISH
        evolveBlob.f.mode += 0.1 * delta;
        if (evolveBlob.f.mode > 1)
          evolveBlob.f.mode = 1;

        background.multG += 0.02 * delta;
        if (background.multG > 1)
          background.multG = 1;

        background.multB += 0.02 * delta;
        if (background.multB > 1)
          background.multB = 1;

        break;

      case 8: // EVOLVE TO SQUID
        evolveBlob.f.mode += 0.1 * delta;
        if (evolveBlob.f.mode > 2)
          evolveBlob.f.mode = 2;

        background.multG += 0.02 * delta;
        if (background.multG > 1)
          background.multG = 1;

        background.multB += 0.02 * delta;
        if (background.multB > 1)
          background.multB = 1;
        break;

      case 9: // EVOLVE LOOP
        evolveBlob.f.mode += 0.4 * delta * dir;
        if (evolveBlob.f.mode > 2) {
          evolveBlob.f.mode = 2;
          dir = -1;
        }
        if (evolveBlob.f.mode < -1) {
          evolveBlob.f.mode = -1;
          dir = 1;
        }
        puuSvengi += 0.2 * delta;
        break;

      case 10: // FADEOUT
        background.multB -= 0.1 * delta;
        if (background.multB < 0)
          background.multB = 0;
        background.multR -= 0.1 * delta;
        if (background.multR < 0)
          background.multR = 0;
        background.multG -= 0.1 * delta;
        if (background.multG < 0)
          background.multG = 0;

        treeAlpha -= 0.1 * delta;
        if (treeAlpha < 0)
          treeAlpha = 0;

        treeMultiplier -= 0.1 * delta;
        if (treeMultiplier < 0)
          treeMultiplier = 0;
          evolveBlob.moveout = true;

        break;
    }

    if (didBarChange && mode > 4)
      evolveBlob.pulse();

    background.draw(secs);

    if (treeMultiplier > 0.01)
    {
      float r = height/12;
      r += cos(TWO_PI * secs  / (8.0 / 6.0)) * 2 * puuSvengi * 7;
      r *= treeMultiplier;
      
      float x = width/2-(width/4)+(width/8);
      float y = 0-(r/1.3);     
      puu.draw(secs, x, y, r, 0.5, 0.3, -0.2, treeColor, treeAlpha);

      
      r = height/13;
      r += cos(TWO_PI * secs / (8.0 / 6.0)) * 2 * puuSvengi * 7;
      r *= treeMultiplier;
      x = width/2+(width/4);
      y = height/15;     
      puu.draw(secs, x, y, r, 0.5, 0.2, -0.4, treeColor, treeAlpha);    

      r = height/15;
      r += cos(TWO_PI * secs / (8.0 / 6.0)) * 2 * puuSvengi * 7;
      r *= treeMultiplier;
      x = width/(width/4);
      y = 0-1.5*r;     
      puu.draw(secs, x, y, r, 0.5, 0.4, -0.2, treeColor * 0.90, treeAlpha); 

      r = height/17;
      r += cos(TWO_PI * secs / (8.0 / 6.0)) * 2 * puuSvengi * 7;
      r *= treeMultiplier;
      x = width/2;
      y = 0-2*r;
      puu.draw(secs, x, y, r, 0.5, 0.2, -0.2, treeColor * 0.85, treeAlpha); 
    }

    //fishes.draw(secs);

    if (mode == 1) {
      group.draw(delta);
      demoni.draw(delta);
    }


    if (mode == 3 || mode == 4)
      ruusu.draw(secs);

    if (mode >= 5)
      evolveBlob.draw(secs);

    if (secs > 84) {
      jkuplat.draw(secs);
    }

    if (mode == 9)
      greets.draw(delta);
    
    if (mode == 2 || mode == 4)
      kuplat.draw(secs);
  }
}
