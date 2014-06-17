PShader tunneli;

/* 
 * A simple example of how to use
 * Processing as a demo platform.
 * 
 * Features:
 *  - Setup for rendering resolution-independent
 *    2D graphics
 *  - Music playback with Minim
 *  - Simple play/pause/seek-functionality
 */
 
import moonlander.library.*;
 
// Minim is needed for the music playback.
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

// All these you can (must) change!
// These control how big the opened window is.
// Before you release your demo, set these to 
// full HD resolution (1920x1080).
int CANVAS_WIDTH = 1920; //960;
int CANVAS_HEIGHT = 1080; //720;

// You can skip backwards/forwards in your demo by using the 
// arrow keys; this controls how many milliseconds you skip
// with one keypress.
int SONG_SKIP_MILLISECONDS = 2000;

// Don't change this – needed for resolution independent rendering
float ASPECT_RATIO = (float)CANVAS_WIDTH/CANVAS_HEIGHT;

// Needed for audio
Minim minim;
AudioPlayer song;

Moonlander moonlander;

PImage ninja;
PImage taru;
PImage miranda;

PShader gre;
PImage tex;

/*
 * Sets up audio playing: call this last in setup()
 * so that the song doesn't start to play too early.
 *
 * By default, playback doesn't start automatically –
 * you must press spacebar to start it.
 */
void setupAudio() {
  minim = new Minim(this);
  song = minim.loadFile("They're Out There.mp3");
  // Uncomment this if you want the demo to start instantly
  song.play();
}

/*
 * Processing's setup method.
 *
 * Do all your one-time setup routines in here.
 */
void setup() {
  moonlander = Moonlander.initWithSoundtrack(this, "They're Out There.mp3", 127, 8);
  
  // Set up the drawing area size and renderer (usually P2D or P3D,
  // respectively for accelerated 2D/3D graphics).
  size(CANVAS_WIDTH, CANVAS_HEIGHT, P3D);

  // Drawing options that don't change, modify as you wish
  noStroke();
  frameRate(30);
  fill(255);
  smooth();
  
  rectMode(CENTER);
  ninja = loadImage("sydanNinja.png");
  taru = loadImage("sydanTaru.png");
  miranda = loadImage("sydanMiranda.png");
  textureMode(NORMAL);
  
  tunneli = loadShader("tunneli.glsl"); 
  tunneli.set("iResolution", (float)width, (float)height);
  
  
  gre = loadShader("gre.glsl"); 
  tex = loadImage("data/graffathon.png");
  
  gre.set("iResolution", (float)width, (float)height);
  gre.set("iChannel0", tex);

  setupAudio(); // tämä vikaksi! jotta musa pysyy synkassa
  
  moonlander.start();
}

void effect1(int time) {
  pushMatrix();
  
  background(0);
  
  stroke(60, 0, 100);
  
  float distance = 0.5;
   
  drawCircles(time, 0.0, 0.001, (cos(time*0.001))*0.2);
  
  popMatrix();
}

void effect2(int time) {
  pushMatrix();
  
  background(0);
  
  //float distance = 0.5;//(float) moonlander.getValue("distance");

  scale(0.5);

  noStroke();
  
  drawCircles(time, 0.4*sin(time*0.001), 0.001, 0.00);
  drawCircles(time, 0.8*sin(time*0.001), 0.0012, 0.05);
  drawCircles(time, 1.2*sin(time*0.001), 0.0013, 0.07);

  
  popMatrix();
}

void effect3(int time) {
  pushMatrix();
  
  stroke(60, 0, 100);
  
  //float distance = 0.5;//(float) moonlander.getValue("distance");

  scale(0.5);

  drawCircles(time, 0.4*sin(time*0.001), 0.001, 0.00);
  
  popMatrix();
}

void konnakursio(int time, int level, int shards) {
   if (level <= 0) {
    return;
   } 
   
   pushMatrix();
     
   scale(0.7);
   
   float rot = 10*sin(time * 0.001);
   rotateX(radians(200.0 + rot));
   rotateY(radians(50.0 + rot));
   
   
   fill(255, 0, (level+1)*30*(1.5+sin(time*0.001)));

   noStroke();
   konna();
   // sphere(350);
   
   for (int i=0; i < shards; i++) {
     rotateZ(1);
     rotateX(1);

     translate(150*time*0.0001, 0, 0);
     konnakursio(time, level - 1, shards);
   }
   
   popMatrix();
}

void effectKonnaKursio(int time) {
  resetMatrix();
  background(0);
  
  float secs = time / 1000.0;

  imageMode(CENTER);
  sphereDetail(10);
  
  pushMatrix();
  
  translate(0, 150, -800.0);
  
  konnakursio(time, 8,3);
  
  popMatrix();
}

void konna() {

  scale(1.0);
  sphere(100);
}


void konna2() {
  scale(1.0);
  box(20.0, 120.0, 20.0);
}

void effectKonnaKursio2(int time) {
  resetMatrix();
  background(0);
  
  float secs = time / 1000.0;
  
  pushMatrix();
  
  translate(0, -height/2.0 - 100, -800.0);
  
  konnakursio2(time, 30, 1);
  
  translate (-400, -200, -400);
  
  konnakursio2(time, 30, 1);
  
  translate (800, 0, 0);
  
  konnakursio2(time, 30, 1);
  
  popMatrix();
}

void konnakursio2(int time, int level, int shards) {
   if (level <= 0) {
    return;
   }
   
   if (time > 20000) {
     translate(100, 300, -100);
     fill(100, 255, 150+(level+1)*10*sin(time*0.001));
   }
   else {
     fill(200+(level+1)*10*sin(time*0.001), 255, 50+(level+1)*10);
   }
   
   pushMatrix();
     
   scale(1.0);

   noStroke();
   konna2();
   
   for (int i=0; i < shards; i++) {
     if (time > 20000) {
       rotateZ(1);
     }
     rotateY(radians(30)*sin(time*0.001));

     translate(60*time*0.0001, 40, 0);
     konnakursio2(time, level - 1, shards);
   }
   
   popMatrix();
}

void texturedBox(float dx, float dy, float dz, int i){
  dx*=0.5;
  dy*=0.5;
  dz*=0.5;
  noStroke();
  beginShape();
  if(i == 0) {
    texture(ninja);
  }
  else if (i == 1) {
    texture(taru);
  }
  else if (i == 2) {
    texture(miranda);
  }
  
  vertex( dx,  dy, dz, 1., 1.);
  vertex( dx, -dy, dz, 1., 0.);
  vertex(-dx, -dy, dz, 0., 0.);
  vertex(-dx,  dy, dz, 0., 1.);
  endShape();


}

void sydamia(){
  scale(ASPECT_RATIO/(CANVAS_WIDTH/2.0), -2.0/CANVAS_HEIGHT);
  scale(0.5);
  
  for(int i=0; i<3; i++){
   pushMatrix();
   //translate(width/2, height/2, 0);
   translate(-150, -50, 0);
   translate(i*150, 0, 0);

      
    rotateY(millis()*0.005);
    noStroke();
    //fill(200, 30, 100);
    //texture(sydan);
    texturedBox(50, 100, 10, i);
    
    popMatrix();
  }
}

void kuutioita(){
  shader(tunneli);
  
  scale(ASPECT_RATIO/(CANVAS_WIDTH/2.0), -2.0/CANVAS_HEIGHT);
  scale(0.5);
  
  for(int j=0; j<10; j++){
    for(int i=0; i<5; i++){
     pushMatrix();
     //translate(width/2, height/2, 0);
     translate(-200, 0, 0);
     translate(i*100, 0, -j*400);
     if(i==1 || i==3)
       translate(0, 100, 0);
     else
        translate(0, -100, 0);
      tunneli.set("iGlobalTime", (float)millis()*0.001);  
      rotateY(millis()*0.005);
      rotateZ(millis()*0.0001);
      noStroke();
      fill(200, 30, 100);
      //texture(sydan);
      box(100, 100, 100);
      
      popMatrix();
    }
  }
}

void greets(int time) {
  shader(gre);
  gre.set("iGlobalTime", (float)time*0.001);
  
  scale(ASPECT_RATIO/(CANVAS_WIDTH/2.0), -2.0/CANVAS_HEIGHT);
  scale(0.5);
  
  pushMatrix();
  fill(0, 30, 100);
  translate(-200, 200, 0);
  box(1920, 1080, 30);
  popMatrix();
}

/*
 * Your drawing code ends up in here!
 *
 */
void drawDemo(int time) {
  if (time < 10000) {
    resetShader();
    effect1(time);
  }
  else if (time < 19500) {
    resetShader();
    effect3(time - 10000);
  }
  else if (time < 30000) {
    resetShader();
    effect2(time - 19500);
  }
  else if (time < 60000) {
    resetShader();
    effectKonnaKursio(time - 30000);
  }
  else if (time < 100000) {
    resetShader();
    effectKonnaKursio2(time - 60000);
  }
  else if (time < 110000) {
    resetShader();
    sydamia();
  }
  else if (time < 120000) {
    resetShader();
    kuutioita();
  }
  else {
    resetShader();
    greets(time+11000);
  }
}

void drawCircles(float time, float distance, float speed, float size) {
  pushMatrix();
  
  for (float i = 0; i < 23; i++) {
    fill(i*20, 0, i*20);
    
    /*if (time > 5000) {
      fill(22*20 - i*20, 0, 22*20 - i*20);
    }*/
    
    ellipse(distance*sin(time*speed+i*2.0), 
            distance*cos(time*speed+i*2.0), 
            size+1.0/(i+2.0),
            size+1.0/(i+2.0)); // x, y, leveys, korkeus
  }
  
  popMatrix();
}

/*
 * Draws coordinate axes (for reference).
 * You can remove this method if you don't 
 * need to see the axes.
 */
void drawAxes() {
  // Drawing options for axes
  stroke(255);
  strokeWeight(0.004);
  fill(255);

  // X-axis
  /*line(-ASPECT_RATIO, 0, ASPECT_RATIO, 0); 
  pushMatrix();
  resetMatrix();
  text(String.format("%.3f", -ASPECT_RATIO), 12, CANVAS_HEIGHT/2);
  text(String.format("%.3f", ASPECT_RATIO), CANVAS_WIDTH-42, CANVAS_HEIGHT/2);
  popMatrix();
  
  // Y-axis
  line(0, -1, 0, 1);
  pushMatrix();
  resetMatrix();
  text("1", CANVAS_WIDTH/2+12, 12);
  text("-1", CANVAS_WIDTH/2+12, CANVAS_HEIGHT - 12);
  popMatrix();*/
}

/*
 * Processing's drawing method – all
 * rendering should be done here!
 */
void draw() {
  moonlander.update();
  
  // Reset all transformations.
  resetMatrix();
  

  // The following lines map coordinates so that we can
  // draw in a resolution independent coordinate system. 
  //
  // After this line coordinate axes are as follows:
  //   x: -ASPECT_RATIO ... ASPECT_RATION
  //   y: -1 ... 1  
  // Negative x is at left, y at bottom, origo at the center of 
  // the screen.
  // This is the coordinate system you're probably used to
  // already!
  //translate(CANVAS_WIDTH/2.0, CANVAS_HEIGHT/2.0); // needed in 2D mode
  translate(-50,0,-200); // needed in 3D mode
  scale((CANVAS_WIDTH/2.0)/ASPECT_RATIO, -CANVAS_HEIGHT/2.0);
  
  // Clear the screen after previous frame.
  // If you comment this line, you always draw on top the last frame,
  // which can lead to something interesting.
  clear();

  // Draw coordinate axes for reference.
  drawAxes();
  // Draw demo at the current song position.
  drawDemo(millis());//song.position());
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

