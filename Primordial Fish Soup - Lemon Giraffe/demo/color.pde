class Color {
  public int r;
  public int g;
  public int b;
  public int a;

  Color(int r,int g,int b) {
    this.r = r;
    this.g = g;
    this.b = b;
    this.a = 255;
  }

  Color(int r,int g,int b, int a) {
    this.r = r;
    this.g = g;
    this.b = b;
    this.a = 255;
  }

  public void setFill() {
    fill((float)this.r, (float)this.g, (float)this.b, (float)this.a);
  }

  public void setFill(float multR, float multG, float multB) {
    fill(
      multR * (float)this.r, 
      multG * (float)this.g,
      multB * (float)this.b,
      (float)this.a
    );
  }

  public void setStroke() {
    stroke((float)this.r, (float)this.g, (float)this.b, (float)this.a);
  }
}
