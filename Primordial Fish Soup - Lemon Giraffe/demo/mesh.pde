class Mesh {
  public float x[], y[];
  int curCoord;

  Mesh (int size) {
    this.x = new float[size];
    this.y = new float[size];
    curCoord = 0;
  }

  Mesh v(float x, float y) {
    this.x[curCoord] = x;
    this.y[curCoord] = y;
    curCoord++;
    return this;
  }

  void renderWithImage(PImage image, int opacity) {
    float uFactor = image.width * 0.5;
    float vFactor = image.height * 0.5;
    noStroke();
    noFill();
    beginShape();
    texture(image);
    tint(255, opacity);
    for (int i = 0; i < x.length; ++i) {
      vertex(
        x[i],
        y[i],
        (1 + x[i]) * uFactor,
        (1 + y[i]) * vFactor);
    }
    endShape();
  }
}


