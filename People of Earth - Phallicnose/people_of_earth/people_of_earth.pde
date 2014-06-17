import moonlander.library.*;

// Minim must be imported when using Moonlander with soundtrack.
import ddf.minim.*;

Moonlander moonlander;
// Minim is needed for the music playback.
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
/* @pjs preload="ukkeli_torso.svg"; */
// Needed for audio
Minim minim;
AudioPlayer song;
PShape torso;
PShape kasi;
PShape jalka;
PShape ukkeli;
PShape planeetta;
PShape vuori;
PShape hirvio;
PShape etu;
PShape tahti;
PShape hirvioetu;
PShape silmat;
PShape phallicnose;
PShape alus;

float ukko_x=1920/2;
float ukko_y=400;
float theta=0;
float beta=0;
float alpha=0;
  int p = 0;
  int v=0;
  int t=150;
  int t2=0;
  int s=0;
  int a=0;
  float ukko_0x=400;
float ukko_0y=300;


void setup() {
  size(1920, 1080);
  // Your setup code
  moonlander = Moonlander.initWithSoundtrack(this, "Nico_Spahni_-_The_Digital_Age.mp3", 60, 1);
  //minim = new Minim(this);
  //song = minim.loadFile("melectric_-_mess.mp3");
  //song.play();
  moonlander.start();
  torso = loadShape("ukkeli_torso.svg");
  kasi = loadShape("ukkeli_kasi.svg");
  jalka = loadShape("ukkeli_jalka.svg");
  //ukkeli = loadShape("kokoukkeli.svg");
  planeetta = loadShape("planeetta.svg");
  vuori = loadShape("vuori.svg");
  hirvio = loadShape("hirvio.svg");
  etu = loadShape("etu.svg");
  tahti = loadShape("tahti.svg");
  hirvioetu = loadShape("hirvioetu.svg");
  silmat = loadShape("silmat.svg");
  phallicnose = loadShape("phallicnose.svg");
  alus = loadShape("alus.svg");
  
} 
void draw(){
  // Handles communication with Rocket. In player mode
    // does nothing. Must be called at the beginning of draw().
    moonlander.update();
  
 if (moonlander.getValue("alku")>=1) {
    background(0);
    shapeMode(CENTER);
    shape(phallicnose, width/2,height/2, 600, 600);
 }

  if (moonlander.getValue("sky")>=1) {
    fill(0);
    rect(0,0,1920,700);
  }
  
  if (moonlander.getValue("floor")>=1) {
   fill(200);
  rect(0,700,1920,1080);
  }
  
  if (moonlander.getValue("planet")>=1) {
   shape(planeetta, 1920-p, 20, 200, 200);
   p+=10;
   if (p > 1920+200)
     p=0;
  }
  
  if (moonlander.getValue("mountain")>=1) {
   shape(vuori, 1920-v, 400, 300, 300);
   v+=20;
   if (v > 1920+300)
     v=0;
  }
  
  if (moonlander.getValue("monster")>=1) {
  beta++;
  //if (beta > 90)
  //beta=0;
  shape(hirvio, 100, 200-sin(degrees(beta))*20, 600, 600);
  }
  
  if (moonlander.getValue("etu")>=1) {
  alpha++;
  //if (beta > 90)
  //beta=0;
  shape(etu, 350, 100-sin(degrees(alpha))*10, 1100, 1100);
  }
  
  if (moonlander.getValue("hirvioetu1")>=1) {
  alpha+=10;
  float alphar=radians(alpha);
  float tausta = radians(alpha)*2;
  background(sin(tausta)*100,0,sin(tausta)*100);
  shape(hirvioetu, 500, 100-sin(alphar)*50, 1000, 1000);
  }
  
    if (moonlander.getValue("hirvioetu")>=1) {
  alpha++;
  background(sin(alpha)*150,0,cos(alpha)*200);
  shape(hirvioetu, -500-sin(degrees(alpha))*100, -200-sin(degrees(alpha))*10, 3000, 3000);
  }
  
  if (moonlander.getValue("tahti")>=1) {
  t--;
  t2+=3;
  if (t<0) {
  t=150;
  t2=0;
  }
  shape(tahti, 0+t2, 300, 0.3*t, 0.3*t);
  shape(tahti, 0+t2, 100, 0.5*t, 0.5*t);
  shape(tahti, 1920-t2, 200, 0.5*t, 0.5*t);
  shape(tahti, 1920-t2, 350, 0.7*t, 0.7*t);
  shape(tahti, 1920-t2, 500, 0.2*t, 0.2*t);
  }
  if (moonlander.getValue("silmat")>=1) {
  float sr = radians(s);
  float tausta2 = radians(s)*100;
  background(sin(tausta2)*255,0,0);
  shape(silmat, -30, -600, 2050, 2050);
  fill(255,0,0);
  stroke(255,0,0);
  ellipse(800+(50*sin(sr)),530,120,120);
  ellipse(1150+(50*sin(sr)),530,120,120);
  s+=5;
  }
  
if (moonlander.getValue("tahdet2")>=1) {
  float sr = radians(s);
  float koko=sin(sr)*100;
  shape(tahti, 200, 300, koko, koko);
  shape(tahti, 800, 800, koko, koko);
  shape(tahti, 600, 200, koko, koko);
  shape(tahti, 1500, 700, koko, koko);
  shape(tahti, 1700, 500, koko, koko);
  s+=1;
  }
  
   if (moonlander.getValue("alus")>=1 && moonlander.getValue("alku")<1) {
   shapeMode(CORNER);  
   background(0);  
   shape(alus, 1920-a, 400, 3000, 300);
   if (a > 1920+3000)
   a=0;
   a+=10;
  }
  
  
  if (moonlander.getValue("ukkeli")>=1) {
  theta += 1;
  float c = sin(theta)-1; //+sin(theta*1.1)+1;
  //c=c/2;
  float korjaus=1.4;
  float jx=82*korjaus, jy=25*korjaus;
  pushMatrix();
  translate(ukko_x + jx, ukko_y+160 + jy);
  rotate(c);
  shape(jalka, -jx, -jy, 140, 140);
    popMatrix();
  //translate(-(ukko_x + jx), -(ukko_y+160 + jy));
  //float korjaus2=1.4;
  float kx=90, ky=20;
   pushMatrix();
  translate(ukko_x+kx+55, ukko_y+ky+95);
  rotate(c+degrees(-18));
  shape(kasi, -kx, -ky, 170, 170);
  popMatrix();
  pushMatrix();
   shape(torso, ukko_x, ukko_y, 200, 200);
    popMatrix();
   pushMatrix();
  translate(ukko_x+kx-60, ukko_y+ky+65);
  rotate(c-degrees(-10));
  shape(kasi, -kx, -ky, 170, 170);
    popMatrix();
   pushMatrix();
   translate(ukko_x+jx-34, ukko_y+160 + jy);
  rotate(c-degrees(40));
  shape(jalka, -jx, -jy, 140, 140);
    popMatrix();
  }
  if (moonlander.getValue("ruumis")>=1) {
    float tausta2 = radians(s)*100;
  background(sin(tausta2)*255,0,0);
  theta += 0.15;
  fill(255);
  //shape(torso, ukko_x, ukko_y, 200, 200);
  float c = (theta-1);
  float korjaus=1.4;
  float jx=82*korjaus, jy=25*korjaus;
  pushMatrix();
  translate(ukko_x + jx+20, ukko_y+160 + jy);
  rotate(c);
  shape(jalka, -jx, -jy, 140, 140);
    popMatrix();
  //translate(-(ukko_x + jx), -(ukko_y+160 + jy));
  //float korjaus2=1.4;
  float kx=90, ky=20;
   pushMatrix();
  translate(ukko_x+kx+55, ukko_y+ky+95);
  rotate(c+degrees(-18));
  shape(kasi, -kx, -ky, 170, 170);
  popMatrix();
  //pushMatrix();
   //shape(torso, ukko_x, ukko_y, 200, 200);
    //popMatrix();
   pushMatrix();
  translate(ukko_x+kx-60, ukko_y+ky+65);
  rotate(c-degrees(-100));
  shape(kasi, -kx, -ky, 170, 170);
    popMatrix();
   pushMatrix();
   translate(ukko_x+jx-34, ukko_y+160 + jy);
  rotate(c-degrees(40));
  shape(jalka, -jx, -jy, 140, 140);
    popMatrix();
    s++;
 
  if (moonlander.getValue("puu")>=1) {   
    background(0);
  theta += 0.005;
  fill(255);
  asd(width/2,height/2, 0);}
  
  if (moonlander.getValue("loppu")>=1) {   
  exit();
  }
  }
}

void asd(float ukko_x, float ukko_y, int mones){
  if (mones>=5){return;}
    //shape(torso, ukko_x, ukko_y, 200, 200);
    float c = sin(theta)-1;
    float korjaus=1.4;
    float jx=82*korjaus, jy=25*korjaus;
    pushMatrix();
      translate(ukko_x + jx, ukko_y+160 + jy);
      rotate(c);
      shape(jalka, -jx, -jy, 140, 140);
    popMatrix();
    //translate(-(ukko_x + jx), -(ukko_y+160 + jy));
    //float korjaus2=1.4;
    float kx=90, ky=20;
    
    pushMatrix();
      translate(ukko_x+kx+55, ukko_y+ky+95);
      rotate(c+degrees(-18));
      shape(kasi, -kx, -ky, 170, 170);
      scale(1.2);
      asd(0+155,0+50,mones+1);
    popMatrix();
    
    pushMatrix();
     shape(torso, ukko_x, ukko_y, 200, 200);
    popMatrix();
    
    pushMatrix();
      translate(ukko_x+kx-60, ukko_y+ky+65);
      rotate(c-degrees(-10));
      shape(kasi, -kx, -ky, 170, 170);
      scale(0.7);
      asd(0-155,0-50, mones+1);
    popMatrix();
    
    pushMatrix();
      translate(ukko_x+jx-34, ukko_y+160 + jy);
      rotate(c-degrees(40));
      shape(jalka, -jx, -jy, 140, 140);
    popMatrix();
}

