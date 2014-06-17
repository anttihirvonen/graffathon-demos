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
int CANVAS_WIDTH = 480;
int CANVAS_HEIGHT = 360;

// You can skip backwards/forwards in your demo by using the 
// arrow keys; this controls how many milliseconds you skip
// with one keypress.
int SONG_SKIP_MILLISECONDS = 2000;

// Needed for audio
Minim minim;
AudioPlayer song;

PImage hakkis;
PImage maisema;
PImage mahtavaa1;
PImage mahtavaa2;
PImage mahtavaa3;
PImage hakkis_perusjanis;
PImage hakkis_tyytyvainen;
PImage hakkis_vihainen;
PImage einiinmahtavaa1;
PImage einiinmahtavaa2;
PImage einiinmahtavaa3;

/*
 * Processing's setup method.
 *
 * Do all your one-time setup routines in here.
 */
void setup() {
  // Set up the drawing area size and renderer (P2D / P3D).
  size(CANVAS_WIDTH, CANVAS_HEIGHT, P2D);
  frameRate(60);

  // Your setup code
  
  hakkis = loadImage("hakkis_basic.png");
  maisema = loadImage("vuoristo.png");
  mahtavaa1 = loadImage("mahtavaa1.png");
  mahtavaa2 = loadImage("mahtavaa2.png");
  mahtavaa3 = loadImage("mahtavaa3.png");
  einiinmahtavaa1 = loadImage("einiinmahtavaa1.png");
  einiinmahtavaa2 = loadImage("einiinmahtavaa2.png");
  einiinmahtavaa3 = loadImage("einiinmahtavaa3.png");
  hakkis_perusjanis = loadImage("hakkis_perusjanis.png");
  hakkis_tyytyvainen = loadImage("hakkis_tyytyvainen.png");
  hakkis_vihainen = loadImage("hakkis_vihainen.png");

  minim = new Minim(this);
  song = minim.loadFile("musa.mp3");
  song.play();
}


/*
 * Processing's drawing method
 */
//void draw() {
  // Draw something
  //background(100+100*sin(millis()/1000.0),0,0);
//}

void draw() {
 //background(100+100*sin(millis()/100.0),0,0);
 int vaihe1loppu = 29000;
 int vaihe2loppu = 39000;
 if (millis() < 29000.0) {
   background(255, 250*millis()/14000.0, 50*millis()/7000.0);
   image(hakkis_perusjanis, -10+millis()/200.0, -(-110+millis()/200.0), 300, 240);
   image(maisema, 0, 0, CANVAS_WIDTH, CANVAS_HEIGHT);
   
  } else if (millis() < 39000.0) {
   float col = sin(millis()*6)*20;
   background(255+col, 250+col, 50+col);
   PImage jompikumpi = hakkis_perusjanis;
   if (col < 0)
     jompikumpi = hakkis_tyytyvainen;
   image(jompikumpi, -10+vaihe1loppu/200.0, -(-110+vaihe1loppu/200.0), 300, 240);
   image(maisema, 0, 0, CANVAS_WIDTH, CANVAS_HEIGHT);
  } else if (millis() < 40000.0) {
    background(255, 255, 255);
  } else if (millis() < 41000.0) {
    image(mahtavaa1, 0, 0, CANVAS_WIDTH, CANVAS_HEIGHT);
  } else if (millis() < 42000.0) {
    image(mahtavaa2, 0, 0, CANVAS_WIDTH, CANVAS_HEIGHT);
  } else if (millis() < 43000.0) {
    image(mahtavaa3, 0, 0, CANVAS_WIDTH, CANVAS_HEIGHT);
  } else if (millis() < 50000.0) {
    float s = lerp(0.1,3.5,(millis()-43000.0)/7000);
    scale(s);
    image(hakkis_tyytyvainen, 0, 0, CANVAS_WIDTH, CANVAS_HEIGHT);
  } else if (millis() < 55000.0) {
    float s = lerp(0, 255, (millis()-50000.0)/5000);
    background(s, 0, 0);
    image(hakkis_vihainen, 0, 0, CANVAS_WIDTH, CANVAS_HEIGHT);
  } else if (millis() < 56000.0) {
    image(einiinmahtavaa1, 0, 0, CANVAS_WIDTH, CANVAS_HEIGHT);
  } else if (millis() < 57000.0) {
    image(einiinmahtavaa2, 0, 0, CANVAS_WIDTH, CANVAS_HEIGHT);
  } else if (millis() < 58000.0) {
    image(einiinmahtavaa3, 0, 0, CANVAS_WIDTH, CANVAS_HEIGHT); 
  }
  }
  

/* 
 * Simple playback controls 
 * for easier development.
 */
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
  // Space bar: play/payse
  else if (key == ' ') {
    if (song.isPlaying())
      song.pause();
    else
      song.play();
  }
  // Enter: spit out the current position
  // (for syncing)
  else if (key == ENTER) {
    print(song.position() + ", ");
  }
}
