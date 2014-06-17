
class BgEffect {
  Flower[] flowers;
  int mx;
  int oldest;
  int seed;
  float timeBetween;
  float maxTime; //time needed to replace the oldest effect with a new one
  float lineWeight;

  BgEffect() {
    mx = 7;
    oldest = 0;
    seed = 0;
    flowers = new Flower[mx];

    timeBetween = .3;
    maxTime = 1.8;
    lineWeight = 0.8;

    for (int i = 0; i < mx; i++) {
      flowers[i] = new Flower(maxTime, seed);
      seed += 1;
    }
  }

  void update(boolean end) {
    if (flowers[oldest].getTime() > maxTime) {
      if (end) {
        float g = (END - SECONDS * 60) / END;
        flowers[oldest] = new Flower(maxTime, g * 150, g * 150, g * 150);
      } else {
        flowers[oldest] = new Flower(maxTime, seed);
      }
      oldest = (oldest + 1) % mx;
      seed += 1;
    }
  }

  void display(float weight, boolean end) {
    update(end);

    strokeWeight(lineWeight); 
    strokeCap(ROUND);

    for (int i = 0; i < flowers.length; i++) {
      if (i == oldest)
        flowers[i].display();
      else if (flowers[(i + mx - 1) % mx].getTime() > timeBetween)
        flowers[i].display();
    }

    strokeCap(SQUARE);
    strokeWeight(weight);

    stroke(0);
  }
}

