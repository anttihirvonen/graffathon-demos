/* 
 * Code for starting a demo project
 *
 * Nothing extra except standard libraries
 * bundled with Processing 
 */

// Minim is needed for the music playback.
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

// These control how big the opened window is.
// Before you release your demo, set these to 
// full HD resolution (1920x1080).
int CANVAS_WIDTH = 1920;
int CANVAS_HEIGHT = 1080;
float ASPECT_RATIO = (float)CANVAS_WIDTH/CANVAS_HEIGHT;
int currentEffect = 0;

Effect effects[];

// You can skip backwards/forwards in your demo by using the 
// arrow keys; this controls how many milliseconds you skip
// with one keypress.
int SONG_SKIP_MILLISECONDS = 2000;

// Needed for audio
Minim minim;
AudioPlayer song;


/*
 * Processing's setup method.
 *
 * Do all your one-time setup routines in here.
 */
Aquarium a;
void setup() {
  // Set up the drawing area size and renderer (P2D / P3D).
  size(CANVAS_WIDTH, CANVAS_HEIGHT, P2D);
  frameRate(60);
  a = new Aquarium();
  a.setup();

  minim = new Minim(this);
  song = minim.loadFile("demobiisi2.wav");
  song.play();
  textSize(32);
  textSize(40);
}


/*
 * Processing's drawing method
 */
void draw() {
  if (!song.isPlaying())
    exit();

  float secs = song.position() / 1000.0;
  clear();
  a.draw(secs);

  //24.375
}

void keyPressed() {
  if (key == CODED) {
    // Left/right arrow keys: seek song
    if (keyCode == LEFT) {
      song.skip(-SONG_SKIP_MILLISECONDS);
    } 
    else if (keyCode == RIGHT) {
      song.skip(SONG_SKIP_MILLISECONDS);
    }
  }
  // Enter: spit out the current position
  // (for syncing)
  else if (key == ENTER) {
    print(song.position() + ", ");
  }
}
