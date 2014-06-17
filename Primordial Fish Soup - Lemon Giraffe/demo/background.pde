class Background implements Effect {
  Color colors[];
  int numLines;
  int lineHeight;
  int numSplits; 

  float scaleX, scaleY;
  float multR, multG, multB;

  void setup() {
    this.numLines = 34;
    this.lineHeight = ceil((float)height / (float)this.numLines);
    this.numSplits = 2;

    scaleX = 1;
    scaleY = 1;

    this.colors = new Color[6];
    this.colors[0] = new Color(0, 70, 134);
    this.colors[1] = new Color(20, 92, 128);
    this.colors[2] = new Color(0, 100, 140);
    this.colors[3] = new Color(20, 127, 158);
    this.colors[4] = new Color(0, 100, 130);
    this.colors[5] = new Color(20, 92, 118);
  }

  int[] getSplitPoints(int line, float secs) {
    int numSins = 15;
    int[] result = new int[numSins];

    int x = 50;
    int deltaX = ceil(width / (numSins + 1) * scaleX);

    for (int i = 0; i < numSins; ++i) {
      float modifier = i % 2 - 1 * sin(secs + i % 4);
      result[i] = ceil(sin((float)line * 0.12 * (i % 3 + 1) + i + (1.0 + secs / 3.0)) * width / 20.0 * scaleX * modifier + x);
      x += deltaX;
    };
    result = sort(result);
    return result;
  }

  void draw(float secs) {
    resetMatrix();
    noStroke();
    int[] previousSplitPoints = this.getSplitPoints(0, secs);
    for (int i = 1; i < this.numLines + 1; ++i) {
      int y = (i - 1) * this.lineHeight;
      int[] splitPoints = this.getSplitPoints(i, secs);
      int x1 = 0, previousX1 = 0; 
      int colorIndex = 0;
      for (int j = 0; j <= splitPoints.length; ++j) {
        int x2, previousX2;
        if (j == splitPoints.length) {
          x2 = width;
          previousX2 = width;
        }
        else {
          x2 = splitPoints[j];
          previousX2 = previousSplitPoints[j];
        }

        this.colors[colorIndex % this.colors.length].setFill(multR, multG, multB);

        beginShape();
          vertex(previousX1, y);
          vertex(previousX2, y);
          vertex(x2, y + this.lineHeight);
          vertex(x1, y + this.lineHeight);
        endShape();

        x1 = x2;
        previousX1 = previousX2;
        colorIndex++;
      }
      previousSplitPoints = splitPoints;
    }
  }
}
