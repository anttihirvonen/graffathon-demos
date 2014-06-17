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

// You can skip backwards/forwards in your demo by using the 
// arrow keys; this controls how many milliseconds you skip
// with one keypress.
int SONG_SKIP_MILLISECONDS = 2000;
float ASPECT_RATIO = (float)CANVAS_WIDTH/CANVAS_HEIGHT;
// Needed for audio
Minim minim;
AudioPlayer song;
PFont f;

/*
 * Processing's setup method.
 *
 * Do all your one-time setup routines in here.
 */
void setup() {
  // Set up the drawing area size and renderer (P2D / P3D).
  size(CANVAS_WIDTH, CANVAS_HEIGHT, P2D);
  frameRate(60);
noStroke();
fill(255);

  // Your setup code
  f= createFont("Georgia",40,true);
  textFont(f);
  textAlign(CENTER);
smooth();
  minim = new Minim(this);
  song = minim.loadFile("../casual.mp3");
  song.play();
}

void drawSun(int time){
  fill(255,0,0);
  
 for ( int i = 0; i < 18; i++){
   if (time < 3550)
   rotate(sin(time*0.0001));
   else
   rotate(PI/9.0);
  quad(-0.1/8, 0, 0.3/8, 0, 0.2/8, 3, -0.3/8, 4);
  
 }
  //fill(0);
//ellipse(0.,0., .6, .6); 
fill(255,0,0);
ellipse(0.,0., .5, .5);  
}

void rotateSun(int time){
  if (time < 29000)
  fill(255,0,0);
  float kikka = 255.0/5000.0;
  if (time > 29000)
  fill(255,0,0,255-(time-29000)*kikka);
  if (time > 4000 && time < 6000)
      translate(0, (time-4000)*0.00025);
  if (time >= 6000 && time < 17000 )
translate(sin((time*.001-6)*.5), (cos((time*.001-6))*.5));
if (time > 17000){
  float te= 0.1*min(1.0,(time-16000)*0.0001); 
translate(sin((time*.001-6)*.5), (cos((time*.001-6))*.05*te));
}
  if (time < 4000){
    rotate((time-3550)*0.00015);
  }
 for ( int i = 0; i < 18; i++){
   rotate(PI/9.0);
  
   if (time > 4000 )
     rotate(-(time-4000)*0.00015 + 1.0);
     if (time >=16000){
     float tt = .1*min(1.0, (time-16000)*.0001);
     translate(((time*.001-32))*tt, ((time*.001-32)*tt));
     
     
     }
     //if( time >=13000)
     //fill(0,0,255);
  quad(-0.1/8, 0, 0.3/8, 0, 0.2/8, 3, -0.3/8, 4);
  
 }
  //fill(0);
//ellipse(0.,0., .6, .6);


fill(255,0,0);
if (time <12000)
ellipse(0.,0., .5, .5);
if (time >= 12000 && time <16000 )
ellipse(0.,0., (.5*(16000-time)/4000), (.5*(16000-time)/4000));

}
void risE(int time){
   float r1step = 245.0/2000.0;
    float g1step = 100.0/2000.0;
    float b1step = 10.0/2000.0;
    float step1 = time-4000;
    float r2 = (118.0-245.0)/3000.0;
    float g2 = (4-100.0)/3000.0;
    float b2 = 7/3000.0;
    float s2 = time - 6000;
    float r3 = 2/4000;
    float g3 = 113/4000;
    float b3 = 5/4000;
    float r4 = 247.0/3000;
    float g4 = 113.0/3000;
    float b4 = 15.0/3000;
    
    
  if (time >4000 && time<6000)
   
 background(step1*r1step,step1*g1step,step1*b1step);
//background(245,100,10) 
  
  if (time >6000 && time < 9000)
    background(2000*r1step+r2*s2,2000*g1step+g2*s2,2000*b1step+b2*s2);
  
  if (time >9000 && time < 12000)
  background(118.0-r2*(s2-3000),4-g2*(s2-3000),7-b2*(s2-3000));

  if (time >12000 && time < 16000)
  background(245+r3*(s2-6000), 100+g3*(s2-6000), 10+b3*(s2-6000));
  if (time >16000 && time < 19000){
  background(247-r4*(time-16000), 113.0-g4*(time-16000), 15.0-b4*(time-16000));
  //print("hola");
  }
  }
  void testBall(int time){
    float v = 255.0/(5000.0);
    
    fill(255,255,255,(time-29000)*v);
  ellipse(0.,0.,1,1);
  }
  
  void crediitti(int time){
    scale(1,-1);
   // translate(0.0,0.5);
  String cre = "Credits";
  String cre2 = "Musat";
  String cre3 = "No2theLag";
  String cre4 = "JayHey";
  String cre5 = "Larry Rum Band";
  String cre6 = "Casual Teens";
  float v = 255/2000;
  
if (time > 34500)
  fill(0);
 if(time < 34500)
  fill(255-v);
  textSize(0.1);
  text(cre,0.0,-0.4);
  text(cre2,0.0,0.0);
  text(cre3, 0.0, -0.32);
  text(cre4, 0.0, -0.24);
  text(cre5, 0.0, 0.1);
  text(cre6, 0.0, 0.18);
  
  }
/*
 * Processing's drawing method
 */
void draw() {
  // Draw something
  resetMatrix();
  translate(CANVAS_WIDTH/2.0, CANVAS_HEIGHT/2.0);
  scale(CANVAS_WIDTH/2.0/ASPECT_RATIO, -CANVAS_HEIGHT/2.0);
  
  clear();
    if (song.position() > 29000)
  testBall(song.position());
  if (song.position() > 32000)
  crediitti(song.position());
  if (song.position() < 3550)
  drawSun(song.position());
  if (song.position() > 3550 && song.position() < 34000){
    risE(song.position());  
    rotateSun(song.position());
  

}
if (song.position() >= 38250)
exit();
  
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
