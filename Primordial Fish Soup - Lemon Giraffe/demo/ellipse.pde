class Ellipse implements Effect {
  void setup() {
  }

  void draw(float secs) {
    resetMatrix();
    translate(CANVAS_WIDTH/2.0, CANVAS_HEIGHT/2.0);
    scale(CANVAS_WIDTH/2.0/ASPECT_RATIO, -CANVAS_HEIGHT/2.0);
    // Clear the screen after previous frame.
    // If you comment this, you always draw on top the last frame,
    // which can lead to something interesting.
    clear();
    noStroke();
    fill(255);
    ellipse(0., 0., 1.0, 1.0);
  }
}
