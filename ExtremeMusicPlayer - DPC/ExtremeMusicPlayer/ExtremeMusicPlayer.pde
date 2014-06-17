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
import java.util.*;

// These control how big the opened window is.
// Before you release your demo, set these to 
// full HD resolution (1920x1080).
PImage screen;
int X = 1920;
int Y = 1050;
PFont font1;
PFont font2;
PFont font3;
int CANVAS_WIDTH = 1920;
int CANVAS_HEIGHT = 1050;
int volume = 0;
int caller;
int laskin;
int laskin2;

int songlength = 158*1000;
float timescale = 2*X/5;
float speed = timescale/songlength;
int distance;
int k;

String mzkfile = "Dalen1.wav";

// You can skip backwards/forwards in your demo by using the 
// arrow keys; this controls how many milliseconds you skip
// with one keypress.
int SONG_SKIP_MILLISECONDS = 2000;

// Needed for audio
Minim minim;
AudioPlayer song;
MultiChannelBuffer buffers; // sama biisi bufferissa kerrallaan
float[] sampledata; // bufferin samplet raakana
FFT fft;

int bufsize = 1024; // soittopuskurin koko
int windowsize = 16384; // fft-puskurin koko, muutettavissa napeilla a ja s
float drawscale = 20.0; // y-skaalaus piirtäessä visualisaatiota
int rate; // samplerate
float effufade;
boolean showbeats = false;

BeatDetect ding;

/*
 * Processing's setup method.
 *
 * Do all your one-time setup routines in here.
 */
void setup() {
  // Set up the drawing area size and renderer (P2D / P3D).
  size(CANVAS_WIDTH, CANVAS_HEIGHT);
  frameRate(80);

  // Your setup code
  screen = loadImage("screen.jpg");
  
  font1 = loadFont("Aharoni-Bold-15.vlw");
  font2 = loadFont("font2.vlw");
  font3 = loadFont("AngsanaUPC-Italic-40.vlw");

  minim = new Minim(this);
  song = minim.loadFile(mzkfile, bufsize);
  buffers = new MultiChannelBuffer(2, 2); // initnumeroilla ei väliä
  
  rate = (int)song.sampleRate();
  minim.loadFileIntoBuffer(mzkfile, buffers);
  sampledata = buffers.getChannel(0); // vain vasen kanava
  fft = new FFT(windowsize, rate);
  fft.window(FFT.HAMMING); 
  
  ding = new BeatDetect(windowsize, rate);
  ding.detectMode(BeatDetect.FREQ_ENERGY);
  
  song.play();
  
  laskin = 0;
  
}


// mistä kohdasta luetaan fft-sampleikkuna
int player_samplepos() {
  // minim palauttaa millisekunteja
  float secs = song.position() / 1000.0;
  // aika sampleyksiköissä
  int samplepos = (int)(secs * song.sampleRate());
  // nykyhetki ikkunan keskelle, vaihtoehtona mm.
  // koko windowsize eli aika ikkunan lopussa 
  samplepos -= windowsize/2;
  // ei vahingossakaan negatiiviseks
  samplepos = max(samplepos, 0);
  // eikä toisenkaan reunan yli
  samplepos = min(samplepos, sampledata.length - windowsize);
  return samplepos;
}

// ikkunan koko menee fft:lle ja beatdetectille
void setwindow(int newwind) {
  windowsize = newwind;
  fft = new FFT(windowsize, rate);
  fft.window(FFT.HAMMING); 
  ding = new BeatDetect(windowsize, rate);
}


/*
 * Processing's drawing method
 */
void draw() {
  
  textFont(font1);
  
  image(screen,0,0);
  
  
  //Great circles
  
  fill(0,92, 168, 50);
  ellipse(X/2, Y/2, 800, 800);
  fill(0,92, 168, 50);
  ellipse(X/2, Y/2, 793, 793);
  
  fill(0,111, 201, 50);
  ellipse(X/2, Y/2, 700, 700);
  fill(0,111, 201, 50);
  ellipse(X/2, Y/2, 693, 693);
  
  fill(0,65, 129, 50);
  ellipse(X/2, Y/2, 600, 600);
  caller = 1;
  effects(caller);
  
  fill(0,249, 243);
  ellipse(X/2, Y/2, 540, 540);
  
  fill(0,49, 92);
  ellipse(X/2, Y/2, 532, 532);
  
  fill(0,249, 243);
  ellipse(X/2, Y/2, 524, 524);
  
  fill(0,49, 92);
  ellipse(X/2, Y/2, 506, 506);
  
  laskin = laskin + 6;
  int lkm;
  int j = 0;
  for (lkm = 30; lkm > 0; lkm--){
    pushMatrix();
    translate(X / 2, Y / 2);
    rotate(radians(laskin + lkm*2));
    stroke(95,187, 255, 255-j*10);
    smooth();
    line(-177, -177, 177, 177);
    popMatrix();
    j++;
  }

  laskin2 = laskin2 -6;
  
  j = 0;
  for (lkm = 10; lkm > 0; lkm--){
    pushMatrix();
    translate(X / 2, Y / 2);
    rotate(radians(laskin2 - lkm*2));
    stroke(95,187, 255, 255-j*10);
    smooth();
    line(-177, -177, 177, 177);
    popMatrix();
    j++;
  }
  
  
  
  stroke(0,0,0);
 
  
  //Middle circle
  
  fill(4, 97, 192);
  ellipse(X/2, Y/2, 90, 90);
  
  fill(4, 49, 92);
  ellipse(X/2, Y/2, 80, 80);
  
  if (volume < 10){
      textFont(font2);
      fill(95,187, 255);
      text(volume, X/2-11, Y/2+25);
      volume += 1;
      textFont(font1);
  }
  else if (volume < 100 && volume >= 10){
      textFont(font2);
      fill(95,187, 255);
      text(volume, X/2-28, Y/2+25);
      volume += 1;
      textFont(font1);
  }
  else {
      textFont(font2);
      fill(95,187, 255);
      text(volume = 0, X/2-11, Y/2+25);
      textFont(font1);
  }
  
  
  //Small lower circles
  
  stroke(#0d2585);
  fill(95,187, 255);
  ellipse(9*X/32, 13*Y/16, 80, 80);
  fill(0,24, 78);
  ellipse(9*X/32, 13*Y/16, 72, 72);
  
  j = 0;
  for (lkm = 30; lkm > 0; lkm--){
    pushMatrix();
    translate(9*X/32, 13*Y/16);
    rotate(radians(laskin + lkm*2));
    stroke(95,187, 255, 255-j*10);
    smooth();
    line(-25, -25, 25, 25);
    popMatrix();
    j++;
  }
  
  stroke(#0d2585);
  fill(95,187, 255);
  ellipse(23*X/32, 13*Y/16, 80, 80);
  fill(0,24, 78);
  ellipse(23*X/32, 13*Y/16, 72, 72);
  
  j = 0;
  for (lkm = 30; lkm > 0; lkm--){
    pushMatrix();
    translate(23*X/32, 13*Y/16);
    rotate(radians(laskin2 - lkm*2));
    stroke(95,187, 255, 255-j*10);
    smooth();
    line(-25, -25, 25, 25);
    popMatrix();
    j++;
  }
  
  //Upper box
  
  noStroke();
  fill(1, 49, 102);
  rect(0,0,X, Y/10);
  
  stroke(0,0,0);
  fill(0,90,200);
  arc(X/2, Y/10, 300, 40, PI, 2*PI);
  
  fill(4, 97, 192);
  rect(X/4,Y/35,X/2, Y/20);
  
  stroke(0,0,0);
  fill(1, 49, 102);
  arc(X/2, 3*Y/37, 300, 30, PI, 2*PI);
  
  fill(4, 97, 192);
  rect(0,0,X, Y/40);
  
  fill(1, 30, 65);
  quad(X/4, 0, 3*X/4, 0, 49*X/64, Y/40, 15*X/64, Y/40);
  
  //Song name scroller
  k = k + 5;
  if(k > 7*X/10){
    k = 0;
  }
    textFont(font3);
    fill(95,187, 255);
    text("Dalen - The New World ----- DPC 2014", k+2, 5*Y/80-5);
    textFont(font1);
  
  noStroke();
  fill(1, 49, 102);
  rect(0,Y/35, X/4, Y/20);
  
  fill(1, 49, 102);
  rect(3*X/4+1, Y/35,X, Y/20);
  stroke(0);
  
  //Upper small circles
  //Left side
  
  fill(95,187, 255);
  ellipse(2*X/60, 5*Y/80, 72, 72);
  fill(1, 49, 102);
  ellipse(2*X/60, 5*Y/80, 65, 65);
  noStroke();
  fill(1, 49, 150);
  ellipse(2*X/60, 5*Y/80, 51, 51);
  fill(1, 49, 102);
  ellipse(2*X/60, 5*Y/80, 30, 30);
  stroke(0,0,0);
  
  fill(95,187, 255);
  ellipse(5*X/60, 5*Y/80, 72, 72);
  fill(1, 49, 102);
  ellipse(5*X/60, 5*Y/80, 65, 65);
  noStroke();
  fill(1, 49, 150);
  ellipse(5*X/60, 5*Y/80, 51, 51);
  fill(1, 49, 102);
  ellipse(5*X/60, 5*Y/80, 30, 30);
  stroke(0,0,0);
  
  fill(95,187, 255);
  ellipse(8*X/60, 5*Y/80, 72, 72);
  fill(1, 49, 102);
  ellipse(8*X/60, 5*Y/80, 65, 65);
  noStroke();
  fill(1, 49, 150);
  ellipse(8*X/60, 5*Y/80, 51, 51);
  fill(1, 49, 102);
  ellipse(8*X/60, 5*Y/80, 30, 30);
  stroke(0,0,0);
  
  fill(95,187, 255);
  ellipse(11*X/60, 5*Y/80, 72, 72);
  fill(1, 49, 102);
  ellipse(11*X/60, 5*Y/80, 65, 65);
  noStroke();
  fill(1, 49, 150);
  ellipse(11*X/60, 5*Y/80, 51, 51);
  fill(1, 49, 102);
  ellipse(11*X/60, 5*Y/80, 30, 30);
  stroke(0,0,0);
  
  
  
  //Right side
  
  fill(95,187, 255);
  ellipse(58*X/60, 5*Y/80, 72, 72);
  fill(1, 49, 102);
  ellipse(58*X/60, 5*Y/80, 65, 65);
  noStroke();
  fill(1, 49, 150);
  ellipse(58*X/60, 5*Y/80, 51, 51);
  fill(1, 49, 102);
  ellipse(58*X/60, 5*Y/80, 30, 30);
  stroke(0,0,0);
  
  fill(95,187, 255);
  ellipse(55*X/60, 5*Y/80, 72, 72);
  fill(1, 49, 102);
  ellipse(55*X/60, 5*Y/80, 65, 65);
  noStroke();
  fill(1, 49, 150);
  ellipse(55*X/60, 5*Y/80, 51, 51);
  fill(1, 49, 102);
  ellipse(55*X/60, 5*Y/80, 30, 30);
  stroke(0,0,0);
  
  fill(95,187, 255);
  ellipse(52*X/60, 5*Y/80, 72, 72);
  fill(1, 49, 102);
  ellipse(52*X/60, 5*Y/80, 65, 65);
  noStroke();
  fill(1, 49, 150);
  ellipse(52*X/60, 5*Y/80, 51, 51);
  fill(1, 49, 102);
  ellipse(52*X/60, 5*Y/80, 30, 30);
  stroke(0,0,0);
  
  fill(95,187, 255);
  ellipse(49*X/60, 5*Y/80, 72, 72);
  fill(1, 49, 102);
  ellipse(49*X/60, 5*Y/80, 65, 65);
  noStroke();
  fill(1, 49, 150);
  ellipse(49*X/60, 5*Y/80, 51, 51);
  fill(1, 49, 102);
  ellipse(49*X/60, 5*Y/80, 30, 30);
  stroke(0,0,0);
  
  caller = 2;
  effects(caller);
  
  
  //Upper text
  
  fill(44, 189, 255);
  text("Extreme Music Player V1.00", 9*X/20, 3*Y/160);
  
  fill(95,187, 255);
  text("Bass Intensity Level", 5*X/60, 3*Y/160);
  
  fill(95,187, 255);
  text("Distortion", 52*X/60, 3*Y/160);
  
  
  
  //Bottom boxes
  
  fill(4, 97, 192);
  rect(0, 39*Y/40,X, Y);
  
  fill(1, 30, 65);
  quad(49*X/64, Y, 15*X/64, Y, X/4, 39*Y/40, 3*X/4, 39*Y/40);
  
  
  
  // 2nd lower boxes
  
  fill(4, 97, 192);
  rect(6, 36*Y/40, 15*X/128, 5*Y/80);
  
  fill(4, 97, 192);
  rect(16*X/128, 36*Y/40, 15*X/128, 5*Y/80);
  
  fill(4, 97, 192);
  rect(97*X/128, 36*Y/40, 15*X/128, 5*Y/80);
  
  fill(4, 97, 192);
  rect(225*X/256, 36*Y/40, 15*X/128, 5*Y/80);
  
  
  
  //Soundtrack timeline box
  noStroke();
  fill(8, 31, 89);
  rect(32*X/128, 36*Y/40, 64*X/128, 2*Y/80);
  stroke(0,0,0);
  
  stroke(95,187, 255);
  line(32*X/128, 36*Y/40, 32*X/128, 37*Y/40);
  
  
  
  //Timeline calculator
  
  line(33*X/128, 149*Y/160, 95*X/128, 149*Y/160);
  line(33*X/128, 155*Y/160, 95*X/128, 155*Y/160);
  
  fill(95,187, 255);
  rect(77*X/256-15, 151*Y/160, 2*X/5+30, 2);
  fill(24, 55, 101);
  stroke(24, 55, 101);
  rect(77*X/256, 151*Y/160+6, 2*X/5, 1);
  
  fill(255,255,255);
  ellipse(77*X/256+ speed*song.position(), 151*Y/160+3, 10,10);
  
  stroke(0,0,0);
  
  
  
  // Copyright text
  
  fill(95,187, 255);
  text("Copyright © Dalen Production Company 2014", 8*X/20, 318*Y/320);
  
  
  
  //Viivat alaboxeissa
  
  text("----- Soundtrack Timeline -----",55*X/128, 147*Y/160);
  
  analyze();
bands();
  
  //Far Left and far right side boxes
  
  
  stroke(95,187, 255);
  fill(1, 49, 102, 50);
  rect(0, Y/10 + 2, 4*X/60, 8*Y/10 - 8);
  
  fill(1, 49, 102, 50);
  rect(56*X/60, Y/10 + 2, 4*X/60, 8*Y/10 - 8);
  stroke(0,0,0);
  
  
  fill(1, 49, 102, 50);
  rect(48*X/60, Y/10 + 2, 10*X/60, 8*Y/10 - 8);

  fill(1, 49, 102, 50);
  rect(2*X/60, Y/10 + 2, 10*X/60, 8*Y/10 - 8);
  
  
  
  //Random right side waves
  for(int i = 0; i < song.bufferSize() - 1; i++)
  {
    float x1 = map( i, 0, song.bufferSize(), 0, 2*Y/3);
    float x2 = map( i+1, 0, song.bufferSize(), 0, 2*Y/3);
    
    stroke(255);
    float a1 = song.left.get(i)*50 + 17*X/20;
    float a2 = song.left.get(i+1)*50 + 17*X/20;
    float b1 = 60 + song.right.get(i)*50 + 17*X/20;
    float b2 = 60 + song.right.get(i+1)*50 + 17*X/20;
    line(a1, x1 + 3*Y/20, a2, x2 + 3*Y/20);
    line(b1, x1 + 3*Y/20, b2, x2 + 3*Y/20);
  }
  stroke(0,0,0);



}

void analyze() {
  int samplepos = player_samplepos();
  float[] window = Arrays.copyOfRange(sampledata, samplepos, samplepos + windowsize);
  fft.forward(window);
  ding.detect(window);
}


void effects(int caller) {
  // fft-väli
  int f_a = 70;
  int f_b = 77;
  
  // beatdetectin arvoväli, käyttää muita indeksejä
  int b_a = 22;
  int b_b = 24;
  
  // ellipsin moduloitava säde
  float ellrad = 20;
  
  // beatdetect
  stroke(95,187, 255);
  fill(95,187, 255, 50);
  if (ding.isRange(b_a, b_b, 2))
    effufade = 5;
    
  if (ellrad*effufade*5 > 800){
    ellipse(X/2, Y/2, 800, 800);
  }
  else {
    ellipse(X/2, Y/2, ellrad*effufade*5, ellrad*effufade*5);
  }
  effufade *= 0.95;
  
  // omakeksimä fft ja threshold
  fill(95,187, 255, 50);
  float ffts = 0;
   for (int i = f_a; i <= f_b; i++)
     ffts += fft.getBand(i);
   float pwr = ffts / (f_b - f_a + 1); // linearisoi yhden bandin levyiseksi (keskiarvo)
   if (pwr > 0.5*Y/2/drawscale) // yli puolet näytöllä näkyvästä piikistä
     fill(95,187, 255, 50);
   
 if(caller == 1){
     if (ellrad*pwr*3 > 800){
      ellipse(X/2, Y/2, 800, 800);
    }
    else {
      ellipse(X/2, Y/2, ellrad*pwr*3, ellrad*pwr*3);
    }
    
    if (ellrad*pwr*2.5 > 800){
      ellipse(X/2, Y/2, 800, 800);
    }
    else {
      ellipse(X/2, Y/2, ellrad*pwr*2.5, ellrad*pwr*2.5);
    }
    if (ellrad*pwr*2.75 > 800){
      ellipse(X/2, Y/2, 800, 800);
    }
    else {
      ellipse(X/2, Y/2, ellrad*pwr*2.75, ellrad*pwr*2.75);
    }
 }
  else if(caller == 2){
    fill(95,187, 255, 30);
    if (ellrad*pwr*2.75 > 68){
      ellipse(2*X/60, 5*Y/80, 68, 68);
    }
    else {
      ellipse(2*X/60, 5*Y/80, ellrad*pwr*2.75, ellrad*pwr*2.75);
    }
    
    if (ellrad*pwr*1.5 > 68){
      ellipse(5*X/60, 5*Y/80, 68, 68);
    }
    else {
      ellipse(5*X/60, 5*Y/80, ellrad*pwr*2.75, ellrad*pwr*2.75);
    }
    
    
    
    if (ellrad*pwr*2 > 68){
      ellipse(8*X/60, 5*Y/80, 68, 68);
    }
    else {
      ellipse(8*X/60, 5*Y/80, ellrad*pwr*2.75, ellrad*pwr*2.75);
    }
    
    
    
    if (ellrad*pwr*2.2 > 68){
      ellipse(11*X/60, 5*Y/80, 68, 68);
    }
    else {
      ellipse(11*X/60, 5*Y/80, ellrad*pwr*2.75, ellrad*pwr*2.75);
    }
    
    
    
    if (ellrad*pwr*1.8 > 68){
      ellipse(58*X/60, 5*Y/80, 68, 68);
    }
    else {
      ellipse(58*X/60, 5*Y/80, ellrad*pwr*2.75, ellrad*pwr*2.75);
    }
    
    
    
    
    if (ellrad*pwr*2 > 68){
      ellipse(55*X/60, 5*Y/80, 68, 68);
    }
    else {
      ellipse(55*X/60, 5*Y/80, ellrad*pwr*2.75, ellrad*pwr*2.75);
    }
    
    
    
    if (ellrad*pwr*1.75 > 68){
      ellipse(52*X/60, 5*Y/80, 68, 68);
    }
    else {
      ellipse(52*X/60, 5*Y/80, ellrad*pwr*2.75, ellrad*pwr*2.75);
    }
    
    
    if (ellrad*pwr*1.5 > 68){
      ellipse(49*X/60, 5*Y/80, 68, 68);
    }
    else {
      ellipse(49*X/60, 5*Y/80, ellrad*pwr*2.75, ellrad*pwr*2.75);
    }
    
    
    
    
    if (ellrad*pwr*2.75 > 68){
      ellipse(2*X/60, 5*Y/80, 68, 68);
    }
    else {
      ellipse(2*X/60, 5*Y/80, ellrad*pwr*2.75, ellrad*pwr*2.75);
    }
    
    
    
  }
  
  fill(0);
}


void bands() {
  stroke(255);

  // jaetaan spektri koko näytölle
  int samples_per_pix = fft.specSize() / X;
  int pixs_per_sample = X / fft.specSize();
  for(int x = 0; x < 7*Y/10; x++) {
    float amplitude = 0;
    float amplitude2 = 0;
    
    if (samples_per_pix >= 1) {
      for (int b = x * samples_per_pix; b < (x + 1) * samples_per_pix; b++)
        amplitude += fft.getBand(b);
      amplitude /= samples_per_pix;
    } else {
      amplitude = fft.getBand(x / pixs_per_sample) * pixs_per_sample ;
    }
    amplitude2 = fft.getBand(x);
    if (amplitude > 6){
        amplitude = 6;
    }
    if (amplitude2 > 6){
        amplitude2 = 6;
    }
    
    // skalaattu
    float distance = (Y/2- amplitude * drawscale - 27*X/160) - (Y/2 - 27*X/160);
    float border = 4*(10*X/60)/10;
   
        line(Y/2- amplitude * drawscale - 22*X/160, x + X/10, Y/2 - 22*X/160, x + X/10);
        // skaalaamaton, bufferin alkuvaiheesta
        line(Y/2 + amplitude2 * drawscale - 22*X/160, x + X/10, Y/2 - 22*X/160,x + X/10);
    
    
        
  }
  
  // beatdetectin tulokset laatikoina
  if (showbeats) {
    stroke(0, 255, 255);
    fill(255, 0, 0);
    int w = width / ding.dectectSize();
    println(ding.dectectSize(), mouseX/w);  
    for (int i = 0; i < ding.dectectSize(); i++) {
      int x = i * w;
      if (ding.isOnset(i))
        rect(x, height/2, w, 20);
    }
  }
}






























/* 
 * Simple playback controls 
 * for easier development.
 */
 /*
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
*/

