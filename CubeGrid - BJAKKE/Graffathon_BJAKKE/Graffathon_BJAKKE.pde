import toxi.math.conversion.*;
import toxi.geom.*;
import toxi.math.*;
import toxi.geom.mesh2d.*;
import toxi.util.datatypes.*;
import toxi.util.events.*;
import toxi.geom.mesh.subdiv.*;
import toxi.geom.mesh.*;
import toxi.math.waves.*;
import toxi.util.*;
import toxi.math.noise.*;




//window related constants
//int CANVAS_WIDTH = 480; int CANVAS_HEIGHT = 360;
int CANVAS_WIDTH = 1920; int CANVAS_HEIGHT = 1080;
//int CANVAS_WIDTH = 640; int CANVAS_HEIGHT = 360;
int SONG_SKIP_MILLISECONDS = 2000;

//audio related constants
String SONG_FILE = "Freaky_-_For_a_Better_Days.wav";
int FFT_BUFFER_SIZE = 1024; // soittopuskurin koko
int FFT_WINDOW_SIZE = 2048; //2048; // fft-puskurin koko, muutettavissa napeilla a ja s

//graphics related constants
int GRID_SIZE = 5;
int GRID_DISTANCE = 450;

float TIME_GREETS_START = 22.5; //synced with music
float TIME_GREETS_STOP  = 40.0;
float TIME_INFO_STOP = 10;

float cameraPosMark1 = 0;
float cameraTimeMark1 = 0;

float WORM_BEGIN_TIME = 40.0;
float WORM_BEGIN_ROTATIONS_TIME = 45.0;

float DEMO_END_TIME = 103.2;

BallGrid fractal;
Worm worm;
AudioManager audioManager;

void setup() {  
  println("setup start");
  // The P3D parameter enables accelerated 3D rendering.
  size(CANVAS_WIDTH, CANVAS_HEIGHT, P3D);
  rectMode(CENTER);
     
  // Drawing options that don't change, modify as you wish
  frameRate(30);
  //noStroke();
  //fill(255);
  smooth();

  //setups audio
  audioManager = new AudioManager(this, SONG_FILE, FFT_BUFFER_SIZE, FFT_WINDOW_SIZE);
  fractal = new BallGrid(this, audioManager);
  worm = new Worm(this, 0, 0 ,0);
  audioManager.play();
  println("setup end");
}

void draw() {
  audioManager.update();
  
  //center view
  resetMatrix();
  background(255); 
  
  drawDemo(audioManager.currentTimeSeconds());
}


void keyPressed() {
  if (key == CODED) {
    // Left/right arrow keys: seek song
    if (keyCode == LEFT) {
      audioManager.skip(-SONG_SKIP_MILLISECONDS);
    } 
    else if (keyCode == RIGHT) {
      audioManager.skip(SONG_SKIP_MILLISECONDS);
    }
  }
  // Space bar: play/payse
  else if (key == ' ') {
    if (audioManager.isPlaying())
      audioManager.pause();
    else
      audioManager.play();
  }
}

void setCameraPosition(float seconds){
  // one degree rotation in radians per seconds
  Vec3D eye = new Vec3D(0.0, 0.0, 0.0);
  Vec3D cen = new Vec3D(0.0, 0.0, 0.0);
  Vec3D up = new Vec3D(0.0, 1.0, 0.0);
  
  
  // camera movement logic here..
  if(seconds < TIME_GREETS_START){
    eye.z = -2000 + cos(seconds * 0.3)*-1000;
    eye.rotateY(sin(seconds*0.3) * PI/2);

  } else if (seconds < TIME_GREETS_STOP) {
    eye.z = 2500;
    eye.x = GRID_DISTANCE * cos(seconds);
    eye.y = GRID_DISTANCE * sin(seconds);    
    eye.rotateY(sin((seconds-TIME_GREETS_START))*0.5);
    
  } else if (seconds < WORM_BEGIN_ROTATIONS_TIME){    
    eye.z = 2500;    
  } else if( seconds < DEMO_END_TIME){
    float timeT = seconds-WORM_BEGIN_ROTATIONS_TIME;
    eye.z = 2500;
    eye.x = GRID_DISTANCE * sin(timeT);
    eye.y = GRID_DISTANCE * -sin(timeT);  
    eye.rotateX(sin(timeT*0.3)*PI/2);
    eye.rotateY(-sin(timeT*0.2)*PI/2);
    eye.rotateZ(sin(timeT*0.1)*PI/2);
  } else{
    // do nothing -> blank 
  }
  
  
  
  beginCamera();
  camera(eye.x, eye.y, eye.z, cen.x, cen.y, cen.z, up.x, up.y, up.z);  
  endCamera();
  
  /*
  float dps = radians(seconds % 360);
  if(seconds < 22.5){   
    
    translate(cos(seconds) * 200, 0, -2000 + cos(seconds * 0.3)*-1000);//+ -sin(seconds*0.5) * -1000);
    rotateY(dps*5);
    rotateZ(dps*10 * sin(dps));
  } else if (seconds < 32){
    cameraPosMark1 = -4000 + (seconds -22.5)*500;
    translate(GRID_DISTANCE/2, GRID_DISTANCE/2, cameraPosMark1); //move camera to position   
  } else if (seconds < 36) {
    translate(GRID_DISTANCE/2, GRID_DISTANCE/2, cameraPosMark1); //hold camera at position
    cameraTimeMark1 = seconds;
  } else if (seconds < 40){
    translate(GRID_DISTANCE/2, GRID_DISTANCE/2, cameraPosMark1); //rotate camera at position
    float rotation_amount = (seconds - cameraTimeMark1) * 30;
    if(rotation_amount > 180){
      rotation_amount = 180; 
    }
    rotateX(radians(rotation_amount));
    
  } else {
    translate(GRID_DISTANCE/2, GRID_DISTANCE/2,0);
    translate(cos(seconds) * 200, 0, -2000 + cos(seconds * 0.3)*-1000);
    rotateY(dps);
    rotateZ(dps*5);
  }*/
  
  
  //rotateY(seconds*sin(seconds*0.2)*0.8);
  //rotateZ(seconds*sin(cos(seconds))*0.1);
  //rotateX(seconds*0.2);
}

void drawBackground(){
  background(0);
}

void drawDemo(float seconds) {
  println("TIME: ", seconds );
  setCameraPosition(seconds);
  drawBackground();

  if(seconds > DEMO_END_TIME){
    audioManager.pause(); 
  }


  //start text  
  if(seconds < TIME_INFO_STOP){
    pushMatrix();
    rotateY(PI+sin(seconds)*0.7);
    
    fill(255);
    textSize(40);
    textAlign(CENTER);
    text("Graffathon 2014", 0, -60, 0);
    text("CubeGrid", 0, 0, 0);
    text("By BJAKKE", 0, +60, 0);
    popMatrix();
  }
  
  //Greets 
  if(seconds > TIME_GREETS_START && seconds < TIME_GREETS_STOP){
    fill(255);
    textSize(60);
    textAlign(CENTER);
    text("GREETINGS TO EVERYONE!", 200*sin(seconds*0.5), cos(seconds*0.9)*300, 0);
  }


  fractal.draw(GRID_SIZE,GRID_SIZE,GRID_SIZE, GRID_DISTANCE);

   
  if(seconds >= WORM_BEGIN_TIME){
    pushMatrix();
    translate(GRID_DISTANCE/2, GRID_DISTANCE/2, 0); 
    worm.setStartTime(seconds ); // will set only once
    worm.draw(seconds );
    popMatrix();
  }

}
