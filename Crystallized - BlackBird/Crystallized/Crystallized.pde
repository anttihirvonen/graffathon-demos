
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

int CANVAS_WIDTH = 1920;
int CANVAS_HEIGHT = 1080;


int SONG_SKIP_MILLISECONDS = 5000;
Minim minim;
AudioPlayer song;
float ASPECT_RATIO = (float)CANVAS_WIDTH/CANVAS_HEIGHT;
int time;

ArrayList<SnowFlake> snowFlakes = new ArrayList<SnowFlake> ();
IceTunnel tunnel = new IceTunnel();
ArrayList<Beam> beams = new ArrayList<Beam>();
ArrayList<Shard> shards = new ArrayList<Shard>();
Rose rose;



void setup() {
  size(CANVAS_WIDTH, CANVAS_HEIGHT, P3D);
  fill(255, 255, 200);
  frameRate(30);
  stroke(200,200,255);
  setupAudio();
  perspective();
  setupObjects();
}

void setupAudio() {
  minim = new Minim(this);
  song = minim.loadFile("Atomic_cat_-_Lost_Dreams.mp3");
  song.play();
}

void setupObjects (){
  for (int k = 0; k < snowFlakeStartSync.length; k++){
    snowFlakes.add(new SnowFlake(sin(k*TWO_PI/21)*30 + sin(snowFlakeStartSync[k]%231)*10, 
    cos(k*TWO_PI/18)*30 + cos(snowFlakeStartSync[k]%162)*10,0,
    snowFlakeStartSync[k], snowFlakeEndSync[k]));
  }
  beams.add(new Beam(color(170,180,255), beam1EnterTime, beam1SteadyTime, beam1EndTime, 1));
  beams.add(new Beam(color(255,100,100), beam2EnterTime, beam2SteadyTime, beam2EndTime, -1));
  
  
  for (int k = 0; k < shardStartSync.length; k++){
    float t = (shardStartSync[k] - beam1SteadyTime)*0.001;
    shards.add(new Shard(sin((t-0.6)*TWO_PI/21)*15+cos((t-0.6)*10*TWO_PI/21)*5, 
      cos((t-0.6)*TWO_PI/21)*15+sin((t-0.6)*10*TWO_PI/21)*5,
      shardStartSync[k], shardEndSync[k]));
  }
  
  rose = new Rose(0,0,0,phase6Time, phase7Time);
}

void draw() {
  time = song.position();
  if (time < songEndTime){
    background(0, 0, 50);
    if(time > phase4Time)
    {
      background(0, 0, constrain(50-floor((time-phase4Time)*0.1), 0, 50));
    }
    lights();
  
    translate(CANVAS_WIDTH/2.0, CANVAS_HEIGHT/2.0, 10);
    scale(CANVAS_WIDTH/2.0/ASPECT_RATIO*0.02, -CANVAS_HEIGHT/2.0*0.02);
    //moveCamera();
    drawDemo();
  } else if (time < songEndTime + songSilenceTime){
    song.mute();
  } else{
    exit();
  }
}

void drawDemo(){
  pushMatrix();

  if (time > phase1Time && time < phase6Time){
    rotateZ((time-phase1Time)*-0.001);
  }
  if (time > phase4Time && time < phase6Time)
  {
    translate(0,0, (float)(time-phase4Time)*0.2);
  }
  if(time < phase5Time){
    for (int j = 0; j < snowFlakes.size(); j++){
      snowFlakes.get(j).display();
    }
  }

  if (time > phase5Time && time < phase6Time){
    tunnel.display();
  }
  popMatrix();
  if (time > beam1EnterTime)
    {
    pushMatrix();
      for (int j = 0; j < beams.size(); j++){
        beams.get(j).display();
      }
    popMatrix();
    pushMatrix();
      for (int j = 0; j < shards.size(); j++){
        shards.get(j).display();
      }
    popMatrix();
    }
  if (time > phase6Time)
    {
      rose.display();
    }
  
}



void moveCamera(){
  rotateY((mouseX/float(width)-0.5)*PI);   
  rotateX(mouseY/float(height)*PI); 
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



int[] snowFlakeStartSync = {381, 1031,  1213, 1565, 2374, 2992, 3482, 3917, 4335, 5446, 5824, 
  6594, 6786, 7271, 8146, 8621, 9108, 9516, 10021,};
int[] snowFlakeEndSync = {11656, 12376, 12794, 13908, 14349, 14837, 15232, 15696, 16764, 17136, 
  17949, 18134, 18552, 19667, 19992, 20456, 20921, 21408, 21408, 21408};
  
int[] shardStartSync = {54565, 56353, 58261, 60234, 62045, 64010, 66084};
int[] shardEndSync = {79202, 77507, 75696, 73792, 71795, 69961, 68173};
int phase1Time = 23000;  // first spin
int phase2Time = 28500;  // second spin
int phase3Time = 31000;  // third spin
int pulseTime = 34200;   // flakes pulse
int phase4Time = 43000;  // background darkening
int phase5Time = 47000;  // tunnel start
int phase6Time = 79700;  // tunnel end
int phase7Time = 97200;  // rose falls
int beam1EnterTime = 51000;
int beam1SteadyTime = 53500;
int beam1EndTime = 69300;
int beam2EnterTime = 61500;
int beam2SteadyTime = 58000;
int beam2EndTime = 81500;

int songEndTime = 104322;
int songSilenceTime = 3000;














